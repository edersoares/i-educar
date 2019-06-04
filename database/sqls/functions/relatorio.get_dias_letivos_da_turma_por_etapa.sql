CREATE OR REPLACE FUNCTION relatorio.get_dias_letivos_da_turma_por_etapa(
    v_turma integer,
    v_etapa integer
) RETURNS integer AS
$$
DECLARE
    v_escola integer;
    v_curso integer;
    v_ano integer;
    v_padrao_ano_escolar integer;
BEGIN
    v_escola := (
        SELECT ref_ref_cod_escola
        FROM pmieducar.turma
        WHERE turma.cod_turma = v_turma
    );

    v_curso := (
        SELECT ref_cod_curso
        FROM pmieducar.turma
        WHERE turma.cod_turma = v_turma
    );

    v_ano := (
        SELECT ano
        FROM pmieducar.turma
        WHERE turma.cod_turma = v_turma
    );

    v_padrao_ano_escolar := (
        SELECT padrao_ano_escolar
        FROM pmieducar.curso
        WHERE curso.cod_curso = v_curso
    );

    IF v_padrao_ano_escolar = 0 THEN
        RETURN (
            SELECT dias_letivos
            FROM pmieducar.turma_modulo
            WHERE ref_cod_turma = v_turma
              AND sequencial = v_etapa
        );
    END IF;

    RETURN (
        SELECT dias_letivos
        FROM pmieducar.ano_letivo_modulo
        WHERE ref_ref_cod_escola = v_escola
          AND ref_ano = v_ano
          AND sequencial = v_etapa
    );
END;
$$
    LANGUAGE plpgsql VOLATILE
                     COST 100;
