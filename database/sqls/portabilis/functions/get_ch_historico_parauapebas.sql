--
-- Name: get_ch_historico_parauapebas(integer, integer, integer); Type: FUNCTION; Schema: relatorio; Owner: postgres
--

CREATE OR REPLACE FUNCTION get_ch_historico_parauapebas(integer, integer, integer) RETURNS integer
    LANGUAGE sql
AS $_$

SELECT ccae.carga_horaria::integer
FROM pmieducar.historico_escolar he
         INNER JOIN modules.componente_curricular cc ON (UPPER(relatorio.get_texto_sem_caracter_especial(cc.nome)) = UPPER(relatorio.get_disciplina_historico_parauapebas($3)))
         INNER JOIN modules.componente_curricular_ano_escolar ccae ON (ccae.componente_curricular_id = cc.id)
WHERE he.ref_cod_aluno = $1
  AND he.sequencial = $2
  AND ccae.ano_escolar_id =
      (SELECT s.cod_serie
       FROM pmieducar.serie s
       WHERE s.ativo = 1
         AND relatorio.get_texto_sem_espaco(s.nm_serie) = relatorio.get_texto_sem_espaco(he.nm_serie)
         AND s.ref_cod_curso =
             (SELECT c.cod_curso
              FROM pmieducar.curso c
              WHERE c.ativo = 1
                AND relatorio.get_texto_sem_espaco(c.nm_curso) = relatorio.get_texto_sem_espaco(he.nm_curso) LIMIT 1) LIMIT 1) LIMIT 1;
$_$;
