<?php

use App\Models\LegacyEnrollment;
use App\Models\RegistrationStatus;
use App\Process;
use App\Services\EnrollmentService;
use Carbon\Carbon;
use Illuminate\Support\Facades\DB;

return new class extends clsCadastro
{
    public $ref_cod_matricula;

    public $ref_cod_turma;

    public $sequencial;

    public $matricula_situacao;

    public function Inicializar()
    {
        $retorno = 'Editar';

        $this->ref_cod_matricula = $_GET['ref_cod_matricula'];
        $this->ref_cod_turma = $_GET['ref_cod_turma'];
        $this->sequencial = $_GET['sequencial'];

        if ($this->user()->cannot(abilities: 'modify', arguments: Process::ENROLLMENT_HISTORY)) {
            $this->simpleRedirect(url: "/enrollment-history/{$this->ref_cod_matricula}");
        }

        $this->fexcluir = $this->user()->can(abilities: 'remove', arguments: Process::ENROLLMENT_HISTORY);

        $this->breadcrumb(currentPage: 'Histórico de enturmações da matrícula', breadcrumbs: [
            url(path: 'intranet/educar_index.php') => 'Escola',
        ]);
        $this->url_cancelar = route(name: 'enrollments.enrollment-history', parameters: ['id' => $this->ref_cod_matricula]);

        return $retorno;
    }

    public function Gerar()
    {
        $this->campoOculto(nome: 'ref_cod_matricula', valor: $this->ref_cod_matricula);
        $this->campoOculto(nome: 'ref_cod_turma', valor: $this->ref_cod_turma);

        $enturmacao = new clsPmieducarMatriculaTurma(ref_cod_matricula: $this->ref_cod_matricula);
        $enturmacao->ref_cod_matricula = $this->ref_cod_matricula;
        $enturmacao->ref_cod_turma = $this->ref_cod_turma;
        $enturmacao->sequencial = $this->sequencial;
        $enturmacao = $enturmacao->detalhe();

        if (!$enturmacao) {
            $this->simpleRedirect(url: "/enrollment-history/{$this->ref_cod_matricula}");
        }

        $matricula = new clsPmieducarMatricula(cod_matricula: $this->ref_cod_matricula);
        $matricula = $matricula->detalhe();

        $instituicao = new clsPmieducarInstituicao(cod_instituicao: $matricula['ref_cod_instituicao']);
        $instituicao = $instituicao->detalhe();

        $escola = new clsPmieducarEscola(cod_escola: $matricula['ref_ref_cod_escola']);
        $escola = $escola->detalhe();

        $this->campoRotulo(nome: 'ano', campo: 'Ano', valor: $matricula['ano']);
        $this->campoRotulo(nome: 'nm_instituicao', campo: 'Instituição', valor: $instituicao['nm_instituicao']);
        $this->campoRotulo(nome: 'nm_escola', campo: 'Escola', valor: $escola['nome']);
        $this->campoRotulo(nome: 'nm_pessoa', campo: 'Nome do Aluno', valor: $enturmacao['nome']);
        $this->campoRotulo(nome: 'sequencial', campo: 'Sequencial', valor: $enturmacao['sequencial']);

        $situacao = RegistrationStatus::getRegistrationAndEnrollmentStatus()[$matricula['aprovado']] ?? '';

        $required = false;

        if (!$enturmacao['ativo']) {
            $required = true;
        }

        $this->campoRotulo(nome: 'situacao', campo: 'Situação', valor: $situacao);
        $this->inputsHelper()->date(attrName: 'data_enturmacao', inputOptions: ['label' => 'Data enturmação', 'value' => dataToBrasil(data_original: $enturmacao['data_enturmacao']), 'placeholder' => '']);
        $this->inputsHelper()->date(attrName: 'data_exclusao', inputOptions: ['label' => 'Data de saída', 'value' => dataToBrasil(data_original: $enturmacao['data_exclusao']), 'placeholder' => '', 'required' => $required]);

        $situacoesMatricula = [
            '' => 'Selecione',
            'transferido' => 'Transferido',
            'remanejado' => 'Remanejado',
            'reclassificado' => 'Reclassificado',
            'abandono' => 'Deixou de Frequentar',
            'falecido' => 'Falecido',
        ];

        $options = [
            'label' => 'Situação',
            'value' => $this->buscaSituacao(enturmacao: $enturmacao),
            'resources' => $situacoesMatricula,
            'inline' => true,
            'required' => false,
        ];

        $this->inputsHelper()->select(attrName: 'matricula_situacao', inputOptions: $options);

        Portabilis_View_Helper_Application::loadJavascript(viewInstance: $this, files: '/vendor/legacy/intranet/scripts/extra/matricua-historico.js');
    }

    public function buscaSituacao(array $enturmacao): string
    {
        if (dbBool(val: $enturmacao['transferido'])) {
            return 'transferido';
        }

        if (dbBool(val: $enturmacao['remanejado'])) {
            return 'remanejado';
        }

        if (dbBool(val: $enturmacao['reclassificado'])) {
            return 'reclassificado';
        }

        if (dbBool(val: $enturmacao['abandono'])) {
            return 'abandono';
        }

        if (dbBool(val: $enturmacao['falecido'])) {
            return 'falecido';
        }

        return '';
    }

    public function Editar()
    {
        $enrollment = LegacyEnrollment::query()
            ->where('ref_cod_matricula', $this->ref_cod_matricula)
            ->whereSchoolClass($this->ref_cod_turma)
            ->where('sequencial', $this->sequencial)
            ->firstOrFail();

        $dataEnturmacao = dataToBanco(data_original: $this->data_enturmacao);
        $dataExclusao = dataToBanco(data_original: $this->data_exclusao);

        $enturmacao = new clsPmieducarMatriculaTurma;
        $dataSaidaEnturmacaoAnterior = $enturmacao->getDataSaidaEnturmacaoAnterior(ref_matricula: $this->ref_cod_matricula, sequencial: $this->sequencial);
        $dataEntradaEnturmacaoSeguinte = $enturmacao->getDataEntradaEnturmacaoSeguinte(ref_matricula: $this->ref_cod_matricula, sequencial: $this->sequencial);

        $matricula = new clsPmieducarMatricula(cod_matricula: $this->ref_cod_matricula);
        $matricula = $matricula->detalhe();
        $dataSaidaMatricula = '';

        if ($matricula['data_cancel']) {
            $dataSaidaMatricula = date(format: 'Y-m-d', timestamp: strtotime(datetime: $matricula['data_cancel']));
        }

        $seqUltimaEnturmacao = $enturmacao->getUltimaEnturmacao(ref_matricula: $this->ref_cod_matricula);

        if ($dataExclusao && ($dataExclusao < $dataEnturmacao)) {
            $this->mensagem = 'Edição não realizada. A data de saída não pode ser anterior a data de enturmação.';

            return false;
        }

        if ($dataExclusao && $dataEntradaEnturmacaoSeguinte && ($dataExclusao > $dataEntradaEnturmacaoSeguinte)) {
            $this->mensagem = 'Edição não realizada. A data de saída não pode ser posterior a data de entrada da enturmação seguinte.';

            return false;
        }

        if ($dataSaidaEnturmacaoAnterior && ($dataEnturmacao < $dataSaidaEnturmacaoAnterior)) {
            $this->mensagem = 'Edição não realizada. A data de enturmação não pode ser anterior a data de saída da enturmação antecessora.';

            return false;
        }

        if (
            $dataSaidaMatricula
            && ($dataExclusao > $dataSaidaMatricula)
            && (
                $matricula['aprovado'] == App_Model_MatriculaSituacao::TRANSFERIDO
                || $matricula['aprovado'] == App_Model_MatriculaSituacao::ABANDONO
                || $matricula['aprovado'] == App_Model_MatriculaSituacao::RECLASSIFICADO
            ) && ($this->sequencial == $seqUltimaEnturmacao)
        ) {
            $this->mensagem = 'Edição não realizada. A data de saída não pode ser posterior a data de saída da matricula.';

            return false;
        }

        if ($this->matricula_situacao && !$dataExclusao) {
            $this->mensagem = 'Edição não realizada. É necessário informar a data de saída ao selecionar uma situação.';

            return false;
        }

        DB::beginTransaction();

        try {
            if ($enrollment->data_enturmacao?->format('Y-m-d') !== $dataEnturmacao) {
                $enrollment->data_enturmacao = $dataEnturmacao;
                $enrollment->save();
            }

            if ($this->matricula_situacao && $dataExclusao && $enrollment->ativo) {
                $enrollmentService = new EnrollmentService(auth()->user());
                $date = Carbon::parse($dataExclusao);

                $cancelou = $enrollmentService->cancelEnrollment($enrollment, $date);

                if (!$cancelou) {
                    DB::rollBack();
                    $this->mensagem = 'Edição não realizada. Erro ao desativar a enturmação.';

                    return false;
                }

                $enrollmentService->markWithSituation($enrollment, $this->matricula_situacao);
            } else {
                $enrollment->data_exclusao = $dataExclusao ?: null;
                $enrollment->ref_usuario_exc = $this->pessoa_logada;
                $enrollment->transferido = $this->matricula_situacao === 'transferido';
                $enrollment->remanejado = $this->matricula_situacao === 'remanejado';
                $enrollment->reclassificado = $this->matricula_situacao === 'reclassificado';
                $enrollment->abandono = $this->matricula_situacao === 'abandono';
                $enrollment->falecido = $this->matricula_situacao === 'falecido';
                $enrollment->save();
            }

            if (empty($dataSaidaMatricula)) {
                $dataSaidaMatricula = $dataExclusao;

                $matricula_get = new clsPmieducarMatricula(
                    cod_matricula: $this->ref_cod_matricula,
                    ref_usuario_cad: $matricula['ref_usuario_cad'],
                    ref_cod_aluno: $matricula['ref_cod_aluno'],
                    aprovado: $matricula['aprovado'],
                    ano: $matricula['ano'],
                    ultima_matricula: $matricula['ultima_matricula'],
                    ref_cod_curso: $matricula['ref_cod_curso'],
                    data_cancel: $dataSaidaMatricula,
                );
                $matricula_get->edita();
            }

            DB::commit();

            $this->mensagem = 'Edição efetuada com sucesso.';
            $this->simpleRedirect(url: "/enrollment-history/{$this->ref_cod_matricula}");
        } catch (\Throwable $e) {
            DB::rollBack();
            $this->mensagem = 'Edição não realizada. ' . $e->getMessage();

            return false;
        }
    }

    private function enturmacaoRemanejadaMesmaTurma($sequencial)
    {
        return LegacyEnrollment::query()
            ->where('ref_cod_turma', $this->ref_cod_turma)
            ->where('ref_cod_matricula', $this->ref_cod_matricula)
            ->where('sequencial', $sequencial)
            ->where('remanejado_mesma_turma', true)
            ->first();
    }

    public function Excluir()
    {
        $enturmacao = LegacyEnrollment::query()
            ->where('ref_cod_turma', $this->ref_cod_turma)
            ->where('ref_cod_matricula', $this->ref_cod_matricula)
            ->where('sequencial', $this->sequencial)
            ->first();

        DB::beginTransaction();

        if ($enturmacao->remanejado_mesma_turma) {
            $proximaEnturmacao = $this->enturmacaoRemanejadaMesmaTurma($this->sequencial + 1);

            if ($proximaEnturmacao) {
                $proximaEnturmacao->update(['remanejado_mesma_turma' => false]);
            }
        }

        $excluiu = $enturmacao->delete();
        DB::commit();

        if ($excluiu) {
            $this->mensagem = 'Exclusão efetuada com sucesso.';
            $this->simpleRedirect(url: "/enrollment-history/{$this->ref_cod_matricula}");
        }

        $this->mensagem = 'Exclusão não realizada.';

        return false;
    }

    public function Formular()
    {
        $this->title = 'Bloqueio do ano letivo';

        $this->processoAp = Process::ENROLLMENT_HISTORY;
    }
};
