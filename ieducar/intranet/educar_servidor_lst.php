<?php

require_once 'include/clsBase.inc.php';
require_once 'include/clsListagem.inc.php';
require_once 'include/clsBanco.inc.php';
require_once 'include/pmieducar/geral.inc.php';
require_once 'CoreExt/View/Helper/UrlHelper.php';

class clsIndexBase extends clsBase
{
  function Formular()
  {
    $this->SetTitulo($this->_instituicao . ' i-Educar - Servidor');
    $this->processoAp = 635;
    $this->addEstilo("localizacaoSistema");
  }
}

class indice extends clsListagem
{
  var $pessoa_logada;
  var $titulo;
  var $limite;
  var $offset;
  var $cod_servidor;
  var $ref_idesco;
  var $ref_cod_funcao;
  var $carga_horaria;
  var $data_cadastro;
  var $data_exclusao;
  var $ativo;
  var $nome;
  var $matricula_servidor;
  var $ref_cod_escola;
  var $ref_cod_instituicao;
  var $servidor_sem_alocacao;

  function Gerar()
  {
    $this->titulo = 'Servidor - Listagem';

    // passa todos os valores obtidos no GET para atributos do objeto
    foreach ($_GET AS $var => $val) {
      $this->$var = ($val === '') ? NULL : $val;
    }

    $this->addCabecalhos( array(
      'Nome do Servidor',
      'Matrícula',
      'CPF',
      'Instituição'
    ));

    $this->inputsHelper()->dynamic(array('instituicao', 'escola', 'anoLetivo'));

    if ($this->cod_servidor) {
      $objTemp = new clsFuncionario($this->cod_servidor);
      $detalhe = $objTemp->detalhe();
      // $detalhe = $detalhe['idpes']->detalhe();

      $opcoes[$detalhe['idpes']] = $detalhe['nome'];
     $opcoes[$detalhe['ref_cod_pessoa_fj']] = $detalhe['matricula_servidor'];
    }

    $parametros = new clsParametrosPesquisas();
    $parametros->setSubmit(0);
    $this->campoTexto("nome","Nome do servidor", $this->nome,50,255,false);
    $this->campoTexto("matricula_servidor","Matrícula", $this->matricula_servidor,50,255,false);
    $this->campoCheck("servidor_sem_alocacao","Incluir servidores sem alocação", isset($_GET['servidor_sem_alocacao']));

    // Paginador
    $this->limite = 20;
    $this->offset = ($_GET['pagina_' . $this->nome]) ?
      $_GET['pagina_' . $this->nome] * $this->limite - $this->limite : 0;

    $obj_servidor = new clsPmieducarServidor();
    $obj_servidor->setOrderby('carga_horaria ASC');
    $obj_servidor->setLimite($this->limite, $this->offset);

     $lista = $obj_servidor->lista(
      $this->cod_servidor,
      NULL,
      $this->ref_idesco,
      $this->carga_horaria,
      NULL,
      NULL,
      NULL,
      NULL,
      1,
      null,
      NULL,
      NULL,
      NULL,
      $this->nome,
      NULL,
      NULL,
      TRUE,
      TRUE,
      TRUE,
      NULL,
      NULL,
      $this->ref_cod_escola,
      NULL,
      NULL,
      NULL,
      NULL,
      NULL,
      NULL,
      NULL,
      NULL,
      NULL,
      isset($_GET['servidor_sem_alocacao']),
      $this->ano_letivo,
      $this->matricula_servidor
    );
    $total = $obj_servidor->_total;

    // UrlHelper
    $url = CoreExt_View_Helper_UrlHelper::getInstance();

    // Monta a lista
    // echo "<pre>";var_dump($lista);die;
    if (is_array($lista) && count($lista)) {
      foreach ($lista as $registro) {
        // Pega detalhes de foreign_keys
        if (class_exists('clsPmieducarInstituicao')) {
          $obj_ref_cod_instituicao = new clsPmieducarInstituicao($registro['ref_cod_instituicao']);
          $det_ref_cod_instituicao = $obj_ref_cod_instituicao->detalhe();

          $registro['ref_cod_instituicao'] = $det_ref_cod_instituicao['nm_instituicao'];
        }
        else {
          $registro['ref_cod_instituicao'] = 'Erro na geração';
        }

        if (class_exists('clsFuncionario')) {
          $obj_cod_servidor      = new clsFuncionario($registro['cod_servidor']);
          $det_cod_servidor      = $obj_cod_servidor->detalhe();
          // $det_cod_servidor      = $det_cod_servidor['idpes']->detalhe();
          $det_cod_servidor      = $det_cod_servidor;
         // $registro['nome']      = $det_cod_servidor['nome'];
          $registro['cpf']      = $det_cod_servidor['cpf'];
        } else {
          $registro['cod_servidor'] = 'Erro na geracao';
        }

        $path = 'educar_servidor_det.php';
        $options = array(
          'query' => array(
            'cod_servidor'        => $registro['cod_servidor'],
            'ref_cod_instituicao' => $det_ref_cod_instituicao['cod_instituicao'],
        ));
        $this->addLinhas(array(
          $url->l($registro['nome'], $path, $options),
          $url->l($registro['matricula_servidor'], $path, $options),
          $url->l($registro['cpf'], $path, $options),
          $url->l($registro['ref_cod_instituicao'], $path, $options),
        ));
      }
    }

    $this->addPaginador2('educar_servidor_lst.php', $total, $_GET, $this->nome, $this->limite);
    $obj_permissoes = new clsPermissoes();

    if ($obj_permissoes->permissao_cadastra(635, $this->pessoa_logada, 7)) {
      $this->acao      = 'go("educar_servidor_cad.php")';
      $this->nome_acao = 'Novo';
    }

    $this->largura = '100%';

    $localizacao = new LocalizacaoSistema();
    $localizacao->entradaCaminhos( array(
         $_SERVER['SERVER_NAME']."/intranet" => "Início",
         "educar_servidores_index.php"       => "Servidores",
         ""                                  => "Servidores"
    ));
    $this->enviaLocalizacao($localizacao->montar());
  }
}

// Instancia objeto de página
$pagina = new clsIndexBase();

// Instancia objeto de conteúdo
$miolo = new indice();

// Atribui o conteúdo à  página
$pagina->addForm($miolo);

// Gera o código HTML
$pagina->MakeAll();
