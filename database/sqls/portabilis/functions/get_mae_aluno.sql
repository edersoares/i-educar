--
-- Name: get_mae_aluno(integer); Type: FUNCTION; Schema: relatorio; Owner: postgres
--

CREATE OR REPLACE FUNCTION get_mae_aluno(integer) RETURNS character varying
    LANGUAGE sql
AS $_$
SELECT coalesce(
           (SELECT nome
            FROM cadastro.pessoa
            WHERE idpes = fisica.idpes_mae), (aluno.nm_mae))
FROM pmieducar.aluno
         INNER JOIN cadastro.fisica ON fisica.idpes = aluno.ref_idpes
WHERE aluno.ativo = 1
  AND aluno.cod_aluno = $1; $_$;
