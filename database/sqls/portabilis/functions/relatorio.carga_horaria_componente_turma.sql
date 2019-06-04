


CREATE OR REPLACE FUNCTION relatorio.carga_horaria_componente_turma(
    codigo_turma integer,
    codigo_componente integer)
    RETURNS integer AS
$BODY$
DECLARE
    codigo_escola integer;
    codigo_serie integer;
    carga_horaria_serie integer;
    carga_horaria_escola_serie integer;
    carga_horaria_turma integer;
BEGIN

    codigo_escola := (
        SELECT ref_ref_cod_escola
        FROM pmieducar.turma
        WHERE cod_turma = codigo_turma
    );

    codigo_serie := (
        SELECT ref_ref_cod_serie
        FROM pmieducar.turma
        WHERE cod_turma = codigo_turma
    );

    carga_horaria_serie := (
        SELECT carga_horaria::int
        FROM modules.componente_curricular_ano_escolar
        WHERE ano_escolar_id = codigo_serie
          AND componente_curricular_id = codigo_componente
    );

    carga_horaria_escola_serie := (
        SELECT carga_horaria::int
        FROM pmieducar.escola_serie_disciplina
        WHERE ref_ref_cod_escola = codigo_escola
          AND ref_ref_cod_serie = codigo_serie
          AND ref_cod_disciplina = codigo_componente
    );

    carga_horaria_turma := (
        SELECT carga_horaria::int
        FROM modules.componente_curricular_turma
        WHERE turma_id = codigo_turma
          AND componente_curricular_id = codigo_componente
    );

    RETURN COALESCE(carga_horaria_turma, carga_horaria_escola_serie, carga_horaria_serie);
END; $BODY$
    LANGUAGE plpgsql VOLATILE
                     COST 100;
