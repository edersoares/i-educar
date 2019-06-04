CREATE OR REPLACE FUNCTION relatorio.get_nacionalidade(nacionalidade_id numeric) RETURNS character varying
    LANGUAGE plpgsql
AS $$ BEGIN RETURN
    (SELECT CASE
                WHEN nacionalidade_id = 1 THEN 'Brasileira'
                WHEN nacionalidade_id = 2 THEN 'Naturalizado Brasileiro'
                ELSE 'Estrangeiro'
                END); END; $$;

