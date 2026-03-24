<?php

return new class extends clsDetalhe
{
    public $titulo;

    public $id;

    public $ano;

    public $servidor_id;

    public $funcao_exercida;

    public $tipo_vinculo;

    public $ref_cod_instituicao;

    public $ref_cod_escola;

    public $ref_cod_curso;

    public $ref_cod_serie;

    public $ref_cod_turma;

    public function Gerar()
    {
        $this->titulo = 'Servidor Vínculo Turma - Detalhe';

        $this->id = $_GET['id'];

        $registro = DB::selectOne("SELECT pt.id, pt.ano, pt.instituicao_id, pt.servidor_id, pt.turma_id, pt.funcao_exercida, pt.tipo_vinculo, pt.permite_lancar_faltas_componente, pt.turno_id, pt.data_inicial, pt.data_fim, pt.leciona_itinerario_tecnico_profissional, pt.area_itinerario, t.nm_turma, s.nm_serie, c.nm_curso, p.nome as nm_escola
            FROM modules.professor_turma pt, pmieducar.turma t, pmieducar.serie s, pmieducar.curso c, pmieducar.escola e, cadastro.pessoa p
            WHERE pt.turma_id = t.cod_turma AND t.ref_ref_cod_serie = s.cod_serie AND s.ref_cod_curso = c.cod_curso
            AND t.ref_ref_cod_escola = e.cod_escola AND e.ref_idpes = p.idpes AND id = ?", [$this->id]);
        $registro = $registro ? (array) $registro : null;

        if (!$registro) {
            $this->simpleRedirect(url: 'educar_servidor_professor_vinculo_lst.php');
        }

        $resources_funcao = [null => 'Selecione',
            1 => 'Docente',
            2 => 'Auxiliar/Assistente educacional',
            3 => 'Profissional/Monitor de atividade complementar',
            4 => 'Tradutor Intérprete de LIBRAS',
            5 => 'Docente titular - Coordenador de tutoria (de módulo ou disciplina) - EAD',
            6 => 'Docente tutor - Auxiliar (de módulo ou disciplina) - EAD',
            7 => 'Guia-Intérprete',
            8 => 'Profissional de apoio escolar para aluno(a)s com deficiência (Lei 13.146/2015)',
            9 => 'Instrutor da Educação Profissional'];

        $resources_tipo = [null => 'Selecione',
            1 => 'Concursado/efetivo/estável',
            2 => 'Contrato temporário',
            3 => 'Contrato terceirizado',
            4 => 'Contrato CLT'];

        if ($registro['nm_escola']) {
            $this->addDetalhe(detalhe: ['Escola', $registro['nm_escola']]);
        }

        if ($registro['nm_curso']) {
            $this->addDetalhe(detalhe: ['Curso', $registro['nm_curso']]);
        }

        if ($registro['nm_serie']) {
            $this->addDetalhe(detalhe: ['Série', $registro['nm_serie']]);
        }

        if ($registro['nm_turma']) {
            $this->addDetalhe(detalhe: ['Turma', $registro['nm_turma']]);
        }

        if ($registro['funcao_exercida']) {
            $this->addDetalhe(detalhe: ['Função exercida', $resources_funcao[$registro['funcao_exercida']]]);
        }

        if ($registro['tipo_vinculo']) {
            $this->addDetalhe(detalhe: ['Tipo de vínculo', $resources_tipo[$registro['tipo_vinculo']]]);
        }

        $sql = 'SELECT nome
            FROM modules.professor_turma_disciplina
            INNER JOIN modules.componente_curricular cc ON (cc.id = componente_curricular_id)
            WHERE professor_turma_id = $1
            ORDER BY nome';

        $disciplinas = '';

        $resources = Portabilis_Utils_Database::fetchPreparedQuery(sql: $sql, options: ['params' => [$this->id]]);

        foreach ($resources as $reg) {
            $disciplinas .= '<span style="background-color: #ccdce6; padding: 2px; border-radius: 3px;"><b>'.$reg['nome'].'</b></span> ';
        }

        if ($disciplinas != '') {
            $this->addDetalhe(detalhe: ['Disciplinas', $disciplinas]);
        }

        $obj_permissoes = new clsPermissoes;

        if ($obj_permissoes->permissao_cadastra(int_processo_ap: 635, int_idpes_usuario: $this->pessoa_logada, int_soma_nivel_acesso: 7)) {
            $this->url_novo = sprintf(
                'educar_servidor_vinculo_turma_cad.php?ref_cod_instituicao=%d&ref_cod_servidor=%d',
                $registro['instituicao_id'],
                $registro['servidor_id']
            );

            $this->url_editar = sprintf(
                'educar_servidor_vinculo_turma_cad.php?id=%d&ref_cod_instituicao=%d&ref_cod_servidor=%d',
                $registro['id'],
                $registro['instituicao_id'],
                $registro['servidor_id']
            );

            $this->array_botao[] = 'Copiar vínculo';
            $this->array_botao_url_script[] = sprintf(
                'go("educar_servidor_vinculo_turma_cad.php?id=%d&ref_cod_instituicao=%d&ref_cod_servidor=%d&copia");',
                $registro['id'],
                $registro['instituicao_id'],
                $registro['servidor_id']
            );
        }

        $this->url_cancelar = sprintf(
            'educar_servidor_vinculo_turma_lst.php?ref_cod_servidor=%d&ref_cod_instituicao=%d',
            $registro['servidor_id'],
            $registro['instituicao_id']
        );

        $this->largura = '100%';

        $this->breadcrumb(currentPage: 'Detalhe do vínculo', breadcrumbs: [
            url(path: 'intranet/educar_servidores_index.php') => 'Servidores',
        ]);
    }

    public function Formular()
    {
        $this->title = 'Servidores - Servidor Formação';
        $this->processoAp = 635;
    }
};
