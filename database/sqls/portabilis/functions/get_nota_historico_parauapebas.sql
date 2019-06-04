
--
-- Name: get_nota_historico_parauapebas(integer, integer, integer); Type: FUNCTION; Schema: relatorio; Owner: postgres
--

CREATE OR REPLACE FUNCTION get_nota_historico_parauapebas(integer, integer, integer) RETURNS character varying
    LANGUAGE sql
AS $_$
SELECT nota
FROM pmieducar.historico_disciplinas
WHERE ref_ref_cod_aluno = $1
  AND ref_sequencial = $2
  AND relatorio.get_texto_sem_caracter_especial(nm_disciplina) = relatorio.get_texto_sem_caracter_especial(relatorio.get_disciplina_historico_parauapebas($3))
$_$;
