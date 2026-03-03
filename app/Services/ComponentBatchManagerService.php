<?php

namespace App\Services;

use App\Models\ComponentBatchOperation;
use App\Models\Enums\ComponentBatchStatus;
use App\Models\LegacyDisciplineAbsence;
use App\Models\LegacyDisciplineAcademicYear;
use App\Models\LegacyDisciplineDescriptiveOpinion;
use App\Models\LegacyDisciplineSchoolClass;
use App\Models\LegacyDisciplineScore;
use App\Models\LegacyDisciplineScoreAverage;
use App\Models\LegacySchoolClass;
use App\Models\LegacySchoolClassTeacher;
use App\Models\LegacySchoolClassTeacherDiscipline;
use App\Models\LegacySchoolGradeDiscipline;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Support\Facades\DB;

class ComponentBatchManagerService
{
    private const RECORD_TYPE_LABELS = [
        'nota_media' => 'Médias',
        'nota' => 'Notas',
        'falta' => 'Faltas',
        'parecer' => 'Pareceres',
        'componente_turma' => 'Componentes da turma',
        'professor_disciplina' => 'Vínculos professor/disciplina',
        'professor_turma' => 'Vínculos professor/turma',
        'escola_serie_disciplina' => 'Componentes da série da escola',
        'componente_ano_escolar' => 'Componentes da série',
    ];

    private const RECORD_MODELS = [
        'nota_media' => [LegacyDisciplineScoreAverage::class, 'registrationScore'],
        'nota' => [LegacyDisciplineScore::class, 'registrationScore'],
        'falta' => [LegacyDisciplineAbsence::class, 'studentAbsence'],
        'parecer' => [LegacyDisciplineDescriptiveOpinion::class, 'studentDescriptiveOpinion'],
    ];

    public function calculatePreview(array $params): array
    {
        $year = $params['year'];
        $gradeIds = $params['grade_ids'];
        $schoolIds = $params['school_ids'] ?? null;
        $disciplineIds = $params['discipline_ids'];
        $removeRecords = $params['remove_records'] ?? false;
        $unlinkClassComponents = $params['unlink_class_components'] ?? false;
        $unlinkTeacherDisciplines = $params['unlink_teacher_disciplines'] ?? false;
        $unlinkSchoolGradeDisciplines = $params['unlink_school_grade_disciplines'] ?? false;
        $unlinkGradeComponents = $params['unlink_grade_components'] ?? false;

        $turmaIds = $this->getAffectedTurmaIds(year: $year, gradeIds: $gradeIds, schoolIds: $schoolIds);

        $preview = [
            'turma_count' => count($turmaIds),
            'idiario' => null,
        ];

        if ($removeRecords && !($params['skip_idiario'] ?? false) && iDiarioService::hasIdiarioConfigurations()) {
            $preview['idiario'] = $this->getIdiarioPreview($params);
        }

        if ($removeRecords) {
            foreach (self::RECORD_MODELS as $key => [$model, $relation]) {
                $preview[$key] = $this->registrationScopedQuery($model, $relation, $gradeIds, $disciplineIds, $year, $schoolIds)->count();
            }
        }

        if ($unlinkClassComponents && count($turmaIds) > 0) {
            $preview['componente_turma'] = $this->componentesTurmaQuery($turmaIds, $disciplineIds)->count();
        }

        if ($unlinkTeacherDisciplines && count($turmaIds) > 0) {
            $preview['professor_disciplina'] = $this->professorDisciplinaQuery($turmaIds, $disciplineIds)->count();
            $preview['professor_turma'] = $this->professorTurmaQuery($turmaIds)->count();
        }

        if ($unlinkSchoolGradeDisciplines) {
            $preview['escola_serie_disciplina'] = $this->escolaSerieDisciplinaQuery($gradeIds, $disciplineIds, $schoolIds)
                ->whereRaw('ARRAY[?::smallint] <@ anos_letivos', [$year])
                ->count();
        }

        if ($unlinkGradeComponents) {
            $preview['componente_ano_escolar'] = $this->componenteAnoEscolarQuery($gradeIds, $disciplineIds)
                ->whereRaw('ARRAY[?::smallint] <@ anos_letivos', [$year])
                ->count();
        }

        return $preview;
    }

    public function execute(ComponentBatchOperation $operation): array
    {
        $startedAt = now();
        $timings = [];

        $operation->update(['status_id' => ComponentBatchStatus::RUNNING->value]);

        $data = $operation->data;
        $previewCounts = $data['preview_counts'] ?? [];

        ['totalIeducar' => $totalIeducar, 'totalIdiario' => $totalIdiario] = self::sumPreviewCounts($previewCounts);

        $warnings = [];

        if ($totalIdiario > 0 && ($data['remove_records'] ?? false) && iDiarioService::hasIdiarioConfigurations()) {
            $t = now();
            $warnings = $this->executeIdiarioDeletion($data, $previewCounts, $operation);
            $timings['idiario'] = $t->diffInSeconds(now());
        }

        if ($totalIeducar > 0) {
            $t = now();
            $counts = $this->executeIeducarDeletion($data);
            $timings['ieducar'] = $t->diffInSeconds(now());
        } else {
            $counts = [];
        }

        $data['result_counts'] = $counts;

        $t = now();
        $postCounts = $this->calculatePreview(array_merge($data, ['skip_idiario' => true]));
        $timings['verificacao'] = $t->diffInSeconds(now());

        $data['post_counts'] = $postCounts;

        $warnings = array_merge($warnings, $this->buildVerificationWarnings($postCounts));
        $data['verification_warnings'] = $warnings;
        $timings['total'] = $startedAt->diffInSeconds(now());
        $data['execution_time'] = $timings;

        $operation->update([
            'status_id' => ComponentBatchStatus::COMPLETED->value,
            'data' => $data,
        ]);

        return $counts;
    }

    private function executeIdiarioDeletion(array &$data, array $previewCounts, ComponentBatchOperation $operation): array
    {
        $warnings = [];

        $result = app(iDiarioService::class)->deleteDisciplineRecords($data);

        if (($result['success'] ?? false) !== true) {
            $data['idiario_error_detail'] = $result;
            $operation->update(['data' => $data]);

            throw new \RuntimeException('Não foi possível excluir os registros do i-Diário. Verifique se o serviço está disponível e tente novamente.');
        }

        $data['idiario_deleted'] = $result['deleted'] ?? null;

        $data['post_idiario'] = $this->getIdiarioPreview($data);
        $remainingIdiario = self::sumIdiarioCounts($data['post_idiario']);

        if ($remainingIdiario > 0) {
            $operation->update(['data' => $data]);

            throw new \RuntimeException(
                "Exclusão do i-Diário incompleta: {$remainingIdiario} registros remanescentes. Operação no i-Educar cancelada."
            );
        }

        $previewIdiario = self::sumIdiarioCounts($previewCounts['idiario'] ?? null);
        if ($data['idiario_deleted'] !== null && $data['idiario_deleted'] !== $previewIdiario) {
            $warnings[] = "i-Diário: destroy_batch retornou {$data['idiario_deleted']} exclusões, mas o preview contava {$previewIdiario}. Recontagem confirmou 0 remanescentes.";
        }

        return $warnings;
    }

    private function executeIeducarDeletion(array $data): array
    {
        $year = $data['year'];
        $gradeIds = $data['grade_ids'];
        $schoolIds = $data['school_ids'] ?? null;
        $disciplineIds = $data['discipline_ids'];

        return DB::transaction(function () use ($data, $year, $gradeIds, $schoolIds, $disciplineIds) {
            $counts = [];

            if ($data['remove_records'] ?? false) {
                foreach (self::RECORD_MODELS as $key => [$model, $relation]) {
                    $counts[$key] = $this->registrationScopedQuery($model, $relation, $gradeIds, $disciplineIds, $year, $schoolIds)->delete();
                }
            }

            $turmaIds = (($data['unlink_class_components'] ?? false) || ($data['unlink_teacher_disciplines'] ?? false))
                ? $this->getAffectedTurmaIds(year: $year, gradeIds: $gradeIds, schoolIds: $schoolIds)
                : [];

            if (($data['unlink_class_components'] ?? false) && count($turmaIds) > 0) {
                $counts['componente_turma'] = $this->componentesTurmaQuery($turmaIds, $disciplineIds)->delete();
            }

            if (($data['unlink_teacher_disciplines'] ?? false) && count($turmaIds) > 0) {
                $counts['professor_disciplina'] = $this->professorDisciplinaQuery($turmaIds, $disciplineIds)->delete();
                $counts['professor_turma'] = $this->professorTurmaQuery($turmaIds)->update(['updated_at' => now()]);
            }

            if ($data['unlink_school_grade_disciplines'] ?? false) {
                $counts['escola_serie_disciplina'] = $this->unlinkEscolaSerieDisciplina(
                    gradeIds: $gradeIds,
                    disciplineIds: $disciplineIds,
                    year: $year,
                    schoolIds: $schoolIds,
                );
            }

            if ($data['unlink_grade_components'] ?? false) {
                $counts['componente_ano_escolar'] = $this->unlinkComponenteAnoEscolar(
                    gradeIds: $gradeIds,
                    disciplineIds: $disciplineIds,
                    year: $year,
                );
            }

            return $counts;
        });
    }

    private function buildVerificationWarnings(array $postCounts): array
    {
        $warnings = [];
        ['totalIeducar' => $remainingIeducar] = self::sumPreviewCounts($postCounts);

        if ($remainingIeducar > 0) {
            foreach ($postCounts as $key => $value) {
                if (is_int($value) && $key !== 'turma_count' && $value > 0) {
                    $label = self::RECORD_TYPE_LABELS[$key] ?? $key;
                    $warnings[] = "{$label}: {$value} registros remanescentes após exclusão.";
                }
            }
        }

        return $warnings;
    }

    public static function sumIdiarioCounts(?array $idiarioData): int
    {
        $total = 0;

        if ($idiarioData && !isset($idiarioData['error'])) {
            foreach ($idiarioData as $item) {
                if (is_array($item) && isset($item['count'])) {
                    $total += (int) $item['count'];
                }
            }
        }

        return $total;
    }

    public static function sumPreviewCounts(array $preview): array
    {
        $totalIeducar = 0;
        foreach ($preview as $key => $value) {
            if (is_int($value) && $key !== 'turma_count') {
                $totalIeducar += $value;
            }
        }

        $totalIdiario = self::sumIdiarioCounts($preview['idiario'] ?? null);

        return ['totalIeducar' => $totalIeducar, 'totalIdiario' => $totalIdiario];
    }

    public function failed(ComponentBatchOperation $operation, string $error): void
    {
        $operation->refresh();

        $friendlyMessage = str_starts_with($error, 'Exclusão do i-Diário')
            || str_starts_with($error, 'Não foi possível')
            ? $error
            : 'Ocorreu um erro inesperado durante a execução. Contate o administrador.';

        $data = $operation->data ?? [];
        $data['error_detail'] = $error;

        $operation->update([
            'status_id' => ComponentBatchStatus::FAILED->value,
            'error_message' => $friendlyMessage,
            'data' => $data,
        ]);
    }

    private function getAffectedTurmaIds(int $year, array $gradeIds, ?array $schoolIds): array
    {
        return LegacySchoolClass::query()
            ->whereIn('ref_ref_cod_serie', $gradeIds)
            ->where('ano', $year)
            ->when($schoolIds, fn ($q) => $q->whereIn('ref_ref_cod_escola', $schoolIds))
            ->pluck('cod_turma')
            ->toArray();
    }

    private function getIdiarioPreview(array $params): ?array
    {
        try {
            $service = app(iDiarioService::class);

            return $service->getDisciplineRecordsCount($params);
        } catch (\Exception $e) {
            return ['error' => $e->getMessage()];
        }
    }

    /**
     * @param  class-string  $modelClass
     */
    private function registrationScopedQuery(
        string $modelClass,
        string $parentRelation,
        array $gradeIds,
        array $disciplineIds,
        int $year,
        ?array $schoolIds,
    ): Builder {
        return $modelClass::query()
            ->whereIn('componente_curricular_id', $disciplineIds)
            ->whereHas("{$parentRelation}.registration", function ($q) use ($gradeIds, $year, $schoolIds) {
                $q->whereIn('ref_ref_cod_serie', $gradeIds)
                    ->where('ano', $year)
                    ->when($schoolIds, fn ($q) => $q->whereIn('ref_ref_cod_escola', $schoolIds));
            });
    }

    private function componentesTurmaQuery(array $turmaIds, array $disciplineIds): Builder
    {
        return LegacyDisciplineSchoolClass::query()
            ->whereIn('turma_id', $turmaIds)
            ->whereIn('componente_curricular_id', $disciplineIds);
    }

    private function professorDisciplinaQuery(array $turmaIds, array $disciplineIds): Builder
    {
        return LegacySchoolClassTeacherDiscipline::query()
            ->whereIn('componente_curricular_id', $disciplineIds)
            ->whereHas('schoolClassTeacher', fn ($q) => $q->whereIn('turma_id', $turmaIds));
    }

    private function professorTurmaQuery(array $turmaIds): Builder
    {
        return LegacySchoolClassTeacher::query()
            ->whereIn('turma_id', $turmaIds);
    }

    private function escolaSerieDisciplinaQuery(array $gradeIds, array $disciplineIds, ?array $schoolIds = null): Builder
    {
        return LegacySchoolGradeDiscipline::query()
            ->whereIn('ref_ref_cod_serie', $gradeIds)
            ->whereIn('ref_cod_disciplina', $disciplineIds)
            ->when($schoolIds, fn ($q) => $q->whereIn('ref_ref_cod_escola', $schoolIds));
    }

    private function componenteAnoEscolarQuery(array $gradeIds, array $disciplineIds): Builder
    {
        return LegacyDisciplineAcademicYear::query()
            ->whereIn('ano_escolar_id', $gradeIds)
            ->whereIn('componente_curricular_id', $disciplineIds);
    }

    private function unlinkEscolaSerieDisciplina(array $gradeIds, array $disciplineIds, int $year, ?array $schoolIds = null): int
    {
        $base = $this->escolaSerieDisciplinaQuery($gradeIds, $disciplineIds, $schoolIds);

        $updated = (clone $base)
            ->whereRaw('ARRAY[?::smallint] <@ anos_letivos', [$year])
            ->update([
                'anos_letivos' => DB::raw("array_remove(anos_letivos, {$year}::smallint)"),
                'updated_at' => now(),
            ]);

        (clone $base)->whereRaw("anos_letivos = '{}'")->delete();

        return $updated;
    }

    private function unlinkComponenteAnoEscolar(array $gradeIds, array $disciplineIds, int $year): int
    {
        $base = $this->componenteAnoEscolarQuery($gradeIds, $disciplineIds);

        $updated = (clone $base)
            ->whereRaw('ARRAY[?::smallint] <@ anos_letivos', [$year])
            ->update([
                'anos_letivos' => DB::raw("array_remove(anos_letivos, {$year}::smallint)"),
                'updated_at' => now(),
            ]);

        (clone $base)->whereRaw("anos_letivos = '{}'")->delete();

        return $updated;
    }
}
