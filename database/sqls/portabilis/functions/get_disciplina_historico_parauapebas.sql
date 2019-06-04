--
-- Name: get_disciplina_historico_parauapebas(integer); Type: FUNCTION; Schema: relatorio; Owner: postgres
--

CREATE OR REPLACE FUNCTION get_disciplina_historico_parauapebas(integer) RETURNS character varying
    LANGUAGE plpgsql
AS $_$ BEGIN RETURN
    (SELECT upper(cc.nome) AS disciplina
     FROM modules.componente_curricular cc
     WHERE cc.id = $1);
END; $_$;
