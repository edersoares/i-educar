<?php

namespace App\Http\Controllers;

use App\Http\Requests\ComponentBatchOperationRequest;
use App\Jobs\ComponentBatchOperationJob;
use App\Models\ComponentBatchOperation;
use App\Models\Enums\ComponentBatchStatus;
use App\Models\LegacyCourse;
use App\Models\LegacyDiscipline;
use App\Models\LegacyGrade;
use App\Models\LegacySchool;
use App\Models\LegacySchoolGradeDiscipline;
use App\Models\NotificationType;
use App\Process;
use App\Services\ComponentBatchManagerService;
use App\Services\NotificationService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Bus;
use Illuminate\Support\Facades\DB;

class ComponentBatchManagerController extends Controller
{
    public function index(Request $request)
    {
        $this->breadcrumb('Gerenciamento em Lote de Componentes', [
            url('intranet/educar_configuracoes_index.php') => 'Configurações',
        ]);
        $this->menu(Process::COMPONENT_BATCH_MANAGER);

        $operations = ComponentBatchOperation::query()
            ->orderByDesc('created_at')
            ->paginate(20);

        return view('component-batch-manager.index', [
            'operations' => $operations,
        ]);
    }

    public function create()
    {
        $this->breadcrumb('Gerenciamento em Lote de Componentes', [
            url('intranet/educar_configuracoes_index.php') => 'Configurações',
        ]);
        $this->menu(Process::COMPONENT_BATCH_MANAGER);

        $disciplines = LegacyDiscipline::query()->orderBy('nome')->pluck('nome', 'id');

        return view('component-batch-manager.create', [
            'disciplines' => $disciplines,
        ]);
    }

    public function apiCourses(Request $request)
    {
        $schoolIds = array_filter((array) $request->input('school_ids', []));
        $year = $request->input('year');

        $courses = LegacyCourse::query()
            ->active()
            ->when(!empty($schoolIds), fn ($q) => $q
                ->join('pmieducar.escola_curso as ec', 'ec.ref_cod_curso', 'curso.cod_curso')
                ->where('ec.ativo', 1)
                ->whereIn('ec.ref_cod_escola', $schoolIds)
                ->when($year, fn ($q) => $q->whereRaw('ARRAY[?::smallint] <@ ec.anos_letivos', [$year]))
            )
            ->select('curso.cod_curso', 'curso.nm_curso')
            ->distinct()
            ->orderBy('curso.nm_curso')
            ->pluck('nm_curso', 'cod_curso');

        return response()->json($courses);
    }

    public function apiGrades(Request $request)
    {
        $schoolIds = array_filter((array) $request->input('school_ids', []));
        $courseIds = array_filter((array) $request->input('course_ids', []));
        $year = $request->input('year');

        $grades = LegacyGrade::query()
            ->active()
            ->when(!empty($schoolIds), fn ($q) => $q
                ->join('pmieducar.escola_serie as es', 'es.ref_cod_serie', 'serie.cod_serie')
                ->where('es.ativo', 1)
                ->whereIn('es.ref_cod_escola', $schoolIds)
                ->when($year, fn ($q) => $q->whereRaw('ARRAY[?::smallint] <@ es.anos_letivos', [$year]))
            )
            ->when(!empty($courseIds), fn ($q) => $q->whereIn('serie.ref_cod_curso', $courseIds))
            ->select('serie.cod_serie', 'serie.nm_serie')
            ->distinct()
            ->orderBy('serie.nm_serie')
            ->pluck('nm_serie', 'cod_serie');

        return response()->json($grades);
    }

    public function apiDisciplines(Request $request)
    {
        $schoolIds = array_filter((array) $request->input('school_ids', []));
        $gradeIds = array_filter((array) $request->input('grade_ids', []));
        $year = $request->input('year');

        if (empty($schoolIds) && empty($gradeIds)) {
            return response()->json(LegacyDiscipline::query()->orderBy('nome')->pluck('nome', 'id'));
        }

        $disciplines = LegacySchoolGradeDiscipline::query()
            ->join('modules.componente_curricular as cc', 'cc.id', 'escola_serie_disciplina.ref_cod_disciplina')
            ->where('escola_serie_disciplina.ativo', 1)
            ->when(!empty($schoolIds), fn ($q) => $q->whereIn('escola_serie_disciplina.ref_ref_cod_escola', $schoolIds))
            ->when(!empty($gradeIds), fn ($q) => $q->whereIn('escola_serie_disciplina.ref_ref_cod_serie', $gradeIds))
            ->when($year, fn ($q) => $q->whereRaw('ARRAY[?::smallint] <@ escola_serie_disciplina.anos_letivos', [$year]))
            ->select('cc.id', 'cc.nome')
            ->distinct()
            ->orderBy('cc.nome')
            ->pluck('nome', 'id');

        return response()->json($disciplines);
    }

    public function preview(ComponentBatchOperationRequest $request)
    {
        $this->breadcrumb('Preview da Operação', [
            url('intranet/educar_configuracoes_index.php') => 'Configurações',
            route('component-batch-manager.create') => 'Gerenciamento de Componentes',
        ]);
        $this->menu(Process::COMPONENT_BATCH_MANAGER);

        $validated = $request->validated();

        if (empty($validated['grade_ids'])) {
            $validated['grade_ids'] = LegacyGrade::query()
                ->active()
                ->whereIn('ref_cod_curso', $validated['course_ids'])
                ->pluck('cod_serie')
                ->toArray();
        }

        if (empty($validated['grade_ids'])) {
            return redirect()->route('component-batch-manager.create')
                ->withErrors(['Nenhuma série encontrada para os cursos selecionados.'])
                ->withInput();
        }

        $service = app(ComponentBatchManagerService::class);
        $preview = $service->calculatePreview($validated);

        session(['batch_operation_preview_data' => array_merge($validated, [
            'preview_counts' => $preview,
        ])]);

        $warnings = $this->buildWarnings(validated: $validated, preview: $preview, service: $service);

        ['totalIeducar' => $totalIeducar, 'totalIdiario' => $totalIdiario] = ComponentBatchManagerService::sumPreviewCounts($preview);

        $blockingError = null;
        if ($totalIeducar === 0 && $totalIdiario === 0) {
            $blockingError = 'Nenhum registro encontrado para os filtros selecionados.';
        }

        return view('component-batch-manager.preview', array_merge(
            $this->resolveNames($validated),
            [
                'params' => $validated,
                'preview' => $preview,
                'warnings' => $warnings,
                'blockingError' => $blockingError,
                'totalIeducar' => $totalIeducar,
                'totalIdiario' => $totalIdiario,
            ]
        ));
    }

    public function execute(Request $request)
    {
        $data = session('batch_operation_preview_data');

        if (!$data) {
            return redirect()->route('component-batch-manager.create')
                ->withErrors(['Sessão expirada. Refaça o processo.']);
        }

        $operation = ComponentBatchOperation::create([
            'user_id' => $request->user()->getKey(),
            'data' => $data,
        ]);

        $job = new ComponentBatchOperationJob(
            operation: $operation,
            databaseConnection: DB::getDefaultConnection(),
        );
        $userId = $request->user()->getKey();

        Bus::batch([$job])
            ->then(function () use ($userId, $operation) {
                (new NotificationService)->createByUser(
                    userId: $userId,
                    text: 'Remoção de componentes concluída com sucesso.',
                    link: route('component-batch-manager.show', $operation),
                    type: NotificationType::OTHER
                );
            })
            ->catch(function () use ($userId, $operation) {
                (new NotificationService)->createByUser(
                    userId: $userId,
                    text: 'Erro na remoção de componentes. Clique para ver detalhes.',
                    link: route('component-batch-manager.show', $operation),
                    type: NotificationType::OTHER
                );
            })
            ->dispatch();

        session()->forget('batch_operation_preview_data');

        return redirect()->route('component-batch-manager.show', $operation);
    }

    public function show(ComponentBatchOperation $componentBatchOperation)
    {
        $this->breadcrumb('Resultado da Operação', [
            url('intranet/educar_configuracoes_index.php') => 'Configurações',
            route('component-batch-manager.create') => 'Gerenciamento de Componentes',
        ]);
        $this->menu(Process::COMPONENT_BATCH_MANAGER);

        $data = $componentBatchOperation->data;
        $status = $componentBatchOperation->status();
        $previewCounts = $data['preview_counts'] ?? [];
        $postCounts = $data['post_counts'] ?? null;
        $postIdiario = $data['post_idiario'] ?? null;
        $verificationWarnings = $data['verification_warnings'] ?? [];

        ['totalIeducar' => $totalIeducar, 'totalIdiario' => $totalIdiario] = ComponentBatchManagerService::sumPreviewCounts($previewCounts);
        ['totalIeducar' => $totalPostIeducar] = ComponentBatchManagerService::sumPreviewCounts($postCounts ?? []);
        $totalPostIdiario = ComponentBatchManagerService::sumIdiarioCounts($postIdiario);

        $hasVerificationData = $postCounts || $postIdiario;
        $showVerification = $status === ComponentBatchStatus::COMPLETED
            || ($status === ComponentBatchStatus::FAILED && $hasVerificationData);

        return view('component-batch-manager.show', array_merge(
            $this->resolveNames($data),
            [
                'operation' => $componentBatchOperation,
                'status' => $status,
                'previewCounts' => $previewCounts,
                'totalIeducar' => $totalIeducar,
                'totalIdiario' => $totalIdiario,
                'postCounts' => $postCounts,
                'postIdiario' => $postIdiario,
                'verificationWarnings' => $verificationWarnings,
                'showVerification' => $showVerification,
                'totalPostIeducar' => $totalPostIeducar,
                'totalPostIdiario' => $totalPostIdiario,
            ]
        ));
    }

    private function buildWarnings(array $validated, array $preview, ComponentBatchManagerService $service): array
    {
        $warnings = [];

        if (($validated['unlink_class_components'] ?? false)
            && !($validated['remove_records'] ?? false)) {
            $hasRecords = ($preview['nota_media'] ?? 0) + ($preview['nota'] ?? 0)
                + ($preview['falta'] ?? 0) + ($preview['parecer'] ?? 0);

            if ($hasRecords === 0 && ($preview['turma_count'] ?? 0) > 0) {
                $tempPreview = $service->calculatePreview(array_merge($validated, [
                    'remove_records' => true,
                    'unlink_class_components' => false,
                    'unlink_teacher_disciplines' => false,
                    'unlink_school_grade_disciplines' => false,
                    'unlink_grade_components' => false,
                    'skip_idiario' => true,
                ]));
                $hasRecords = ($tempPreview['nota_media'] ?? 0) + ($tempPreview['nota'] ?? 0)
                    + ($tempPreview['falta'] ?? 0) + ($tempPreview['parecer'] ?? 0);
            }

            if ($hasRecords > 0) {
                $warnings[] = "Existem {$hasRecords} lançamentos. Desvincular sem remover pode gerar inconsistência.";
            }
        }

        if (($validated['unlink_class_components'] ?? false)
            && !($validated['unlink_teacher_disciplines'] ?? false)) {
            $warnings[] = 'Vínculos de professor/disciplina continuarão apontando para componentes removidos da turma.';
        }

        if ((($validated['unlink_school_grade_disciplines'] ?? false) || ($validated['unlink_grade_components'] ?? false))
            && !($validated['unlink_class_components'] ?? false)) {
            $warnings[] = 'Componentes continuarão vinculados nas turmas.';
        }

        return $warnings;
    }

    private function resolveNames(array $data): array
    {
        return [
            'schoolNames' => !empty($data['school_ids'])
                ? LegacySchool::whereIn('cod_escola', $data['school_ids'])->get()->map(fn ($s) => "{$s->name} ({$s->cod_escola})")->toArray()
                : [],
            'courseNames' => !empty($data['course_ids'])
                ? LegacyCourse::whereIn('cod_curso', $data['course_ids'])->get()->map(fn ($c) => "{$c->nm_curso} ({$c->cod_curso})")->toArray()
                : [],
            'gradeNames' => LegacyGrade::whereIn('cod_serie', $data['grade_ids'] ?? [])->get()->map(fn ($g) => "{$g->nm_serie} ({$g->cod_serie})")->toArray(),
            'disciplineNames' => LegacyDiscipline::query()
                ->whereIn('id', $data['discipline_ids'] ?? [])
                ->get()
                ->map(fn ($d) => "{$d->nome} ({$d->id})")
                ->toArray(),
        ];
    }
}
