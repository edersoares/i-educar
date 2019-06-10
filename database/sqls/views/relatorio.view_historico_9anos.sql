CREATE OR REPLACE VIEW relatorio.view_historico_9anos AS
SELECT historico.cod_aluno,
       historico.disciplina,
       historico.nota_1serie,
       historico.nota_2serie,
       historico.nota_3serie,
       historico.nota_4serie,
       historico.nota_5serie,
       historico.nota_6serie,
       historico.nota_7serie,
       historico.nota_8serie,
       historico.nota_9serie,
       historico.ano_1serie,
       historico.escola_1serie,
       historico.escola_cidade_1serie,
       historico.escola_uf_1serie,
       historico.ano_2serie,
       historico.escola_2serie,
       historico.escola_cidade_2serie,
       historico.escola_uf_2serie,
       historico.ano_3serie,
       historico.escola_3serie,
       historico.escola_cidade_3serie,
       historico.escola_uf_3serie,
       historico.ano_4serie,
       historico.escola_4serie,
       historico.escola_cidade_4serie,
       historico.escola_uf_4serie,
       historico.ano_5serie,
       historico.escola_5serie,
       historico.escola_cidade_5serie,
       historico.escola_uf_5serie,
       historico.ano_6serie,
       historico.escola_6serie,
       historico.escola_cidade_6serie,
       historico.escola_uf_6serie,
       historico.ano_7serie,
       historico.escola_7serie,
       historico.escola_cidade_7serie,
       historico.escola_uf_7serie,
       historico.ano_8serie,
       historico.escola_8serie,
       historico.escola_cidade_8serie,
       historico.escola_uf_8serie,
       historico.ano_9serie,
       historico.escola_9serie,
       historico.escola_cidade_9serie,
       historico.escola_uf_9serie,
       historico.transferido1,
       historico.transferido2,
       historico.transferido3,
       historico.transferido4,
       historico.transferido5,
       historico.transferido6,
       historico.transferido7,
       historico.transferido8,
       historico.transferido9,
       historico.carga_horaria1,
       historico.carga_horaria2,
       historico.carga_horaria3,
       historico.carga_horaria4,
       historico.carga_horaria5,
       historico.carga_horaria6,
       historico.carga_horaria7,
       historico.carga_horaria8,
       historico.carga_horaria9,
       historico.observacao_all,
       historico.matricula_transferido,
       historico.carga_horaria_disciplina1,
       historico.carga_horaria_disciplina2,
       historico.carga_horaria_disciplina3,
       historico.carga_horaria_disciplina4,
       historico.carga_horaria_disciplina5,
       historico.carga_horaria_disciplina6,
       historico.carga_horaria_disciplina7,
       historico.carga_horaria_disciplina8,
       historico.carga_horaria_disciplina9,
       historico.disciplina_dependencia1,
       historico.disciplina_dependencia2,
       historico.disciplina_dependencia3,
       historico.disciplina_dependencia4,
       historico.disciplina_dependencia5,
       historico.disciplina_dependencia6,
       historico.disciplina_dependencia7,
       historico.disciplina_dependencia8,
       historico.disciplina_dependencia9,
       historico.ch_componente_1,
       historico.ch_componente_2,
       historico.ch_componente_3,
       historico.ch_componente_4,
       historico.ch_componente_5,
       historico.ch_componente_6,
       historico.ch_componente_7,
       historico.ch_componente_8,
       historico.ch_componente_9,
       historico.frequencia1,
       historico.frequencia2,
       historico.frequencia3,
       historico.frequencia4,
       historico.frequencia5,
       historico.frequencia6,
       historico.frequencia7,
       historico.frequencia8,
       historico.frequencia9,
       max(historico.status_serie1) AS status_serie1,
       max(historico.status_serie2) AS status_serie2,
       max(historico.status_serie3) AS status_serie3,
       max(historico.status_serie4) AS status_serie4,
       max(historico.status_serie5) AS status_serie5,
       max(historico.status_serie6) AS status_serie6,
       max(historico.status_serie7) AS status_serie7,
       max(historico.status_serie8) AS status_serie8,
       max(historico.status_serie9) AS status_serie9
FROM ( SELECT historico_disciplinas.ref_ref_cod_aluno AS cod_aluno,
              get_texto_sem_caracter_especial((upper(btrim(historico_disciplinas.nm_disciplina)))::character varying) AS disciplina,
              ( SELECT
                    CASE
                        WHEN (("substring"(btrim((hd.nota)::text), 1, 1) <> (0)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (1)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (2)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (3)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (4)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (5)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (6)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (7)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (8)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (9)::text)) THEN replace((hd.nota)::text, '.'::text, ','::text)
                        WHEN ((to_number(btrim((hd.nota)::text), '999'::text) > (10)::numeric) AND (to_number(btrim((hd.nota)::text), '999'::text) <= (20)::numeric)) THEN replace(btrim((hd.nota)::text), '.'::text, ','::text)
                        ELSE replace("substring"(btrim((hd.nota)::text), 1, 4), '.'::text, ','::text)
                        END AS replace
                FROM (pmieducar.historico_disciplinas hd
                         JOIN pmieducar.historico_escolar historico_escolar_1 ON (((historico_escolar_1.ref_cod_aluno = hd.ref_ref_cod_aluno) AND (historico_escolar_1.sequencial = hd.ref_sequencial))))
                WHERE ((hd.ref_ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND ((get_texto_sem_caracter_especial((upper(btrim((hd.nm_disciplina)::text)))::character varying))::text = (get_texto_sem_caracter_especial((upper(btrim(historico_disciplinas.nm_disciplina)))::character varying))::text) AND (historico_escolar_1.ativo = 1) AND (historico_escolar_1.extra_curricular = 0) AND ("substring"((historico_escolar_1.nm_serie)::text, 1, 1) = (1)::text) AND (historico_escolar_1.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          FROM pmieducar.historico_escolar hee
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          WHERE ((hee.ref_cod_aluno = historico_escolar_1.ref_cod_aluno) AND ("substring"((historico_escolar_1.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0) AND (COALESCE(hee.dependencia, false) = false)))))
                LIMIT 1) AS nota_1serie,
              ( SELECT
                    CASE
                        WHEN (("substring"(btrim((hd.nota)::text), 1, 1) <> (0)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (1)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (2)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (3)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (4)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (5)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (6)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (7)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (8)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (9)::text)) THEN replace((hd.nota)::text, '.'::text, ','::text)
                        WHEN ((to_number(btrim((hd.nota)::text), '999'::text) > (10)::numeric) AND (to_number(btrim((hd.nota)::text), '999'::text) <= (20)::numeric)) THEN replace(btrim((hd.nota)::text), '.'::text, ','::text)
                        ELSE replace("substring"(btrim((hd.nota)::text), 1, 4), '.'::text, ','::text)
                        END AS replace
                FROM (pmieducar.historico_disciplinas hd
                         JOIN pmieducar.historico_escolar historico_escolar_1 ON (((historico_escolar_1.ref_cod_aluno = hd.ref_ref_cod_aluno) AND (historico_escolar_1.sequencial = hd.ref_sequencial))))
                WHERE ((hd.ref_ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND ((get_texto_sem_caracter_especial((upper(btrim((hd.nm_disciplina)::text)))::character varying))::text = (get_texto_sem_caracter_especial((upper(btrim(historico_disciplinas.nm_disciplina)))::character varying))::text) AND (historico_escolar_1.ativo = 1) AND (historico_escolar_1.extra_curricular = 0) AND ("substring"((historico_escolar_1.nm_serie)::text, 1, 1) = (2)::text) AND (historico_escolar_1.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          FROM pmieducar.historico_escolar hee
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          WHERE ((hee.ref_cod_aluno = historico_escolar_1.ref_cod_aluno) AND ("substring"((historico_escolar_1.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0) AND (COALESCE(hee.dependencia, false) = false)))))
                LIMIT 1) AS nota_2serie,
              ( SELECT
                    CASE
                        WHEN (("substring"(btrim((hd.nota)::text), 1, 1) <> (0)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (1)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (2)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (3)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (4)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (5)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (6)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (7)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (8)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (9)::text)) THEN replace((hd.nota)::text, '.'::text, ','::text)
                        WHEN ((to_number(btrim((hd.nota)::text), '999'::text) > (10)::numeric) AND (to_number(btrim((hd.nota)::text), '999'::text) <= (20)::numeric)) THEN replace(btrim((hd.nota)::text), '.'::text, ','::text)
                        ELSE replace("substring"(btrim((hd.nota)::text), 1, 4), '.'::text, ','::text)
                        END AS replace
                FROM (pmieducar.historico_disciplinas hd
                         JOIN pmieducar.historico_escolar historico_escolar_1 ON (((historico_escolar_1.ref_cod_aluno = hd.ref_ref_cod_aluno) AND (historico_escolar_1.sequencial = hd.ref_sequencial))))
                WHERE ((hd.ref_ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND ((get_texto_sem_caracter_especial((upper(btrim((hd.nm_disciplina)::text)))::character varying))::text = (get_texto_sem_caracter_especial((upper(btrim(historico_disciplinas.nm_disciplina)))::character varying))::text) AND (historico_escolar_1.ativo = 1) AND (historico_escolar_1.extra_curricular = 0) AND ("substring"((historico_escolar_1.nm_serie)::text, 1, 1) = (3)::text) AND (historico_escolar_1.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          FROM pmieducar.historico_escolar hee
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          WHERE ((hee.ref_cod_aluno = historico_escolar_1.ref_cod_aluno) AND ("substring"((historico_escolar_1.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0) AND (COALESCE(hee.dependencia, false) = false)))))
                LIMIT 1) AS nota_3serie,
              ( SELECT
                    CASE
                        WHEN (("substring"(btrim((hd.nota)::text), 1, 1) <> (0)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (1)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (2)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (3)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (4)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (5)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (6)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (7)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (8)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (9)::text)) THEN replace((hd.nota)::text, '.'::text, ','::text)
                        WHEN ((to_number(btrim((hd.nota)::text), '999'::text) > (10)::numeric) AND (to_number(btrim((hd.nota)::text), '999'::text) <= (20)::numeric)) THEN replace(btrim((hd.nota)::text), '.'::text, ','::text)
                        ELSE replace("substring"(btrim((hd.nota)::text), 1, 4), '.'::text, ','::text)
                        END AS replace
                FROM (pmieducar.historico_disciplinas hd
                         JOIN pmieducar.historico_escolar historico_escolar_1 ON (((historico_escolar_1.ref_cod_aluno = hd.ref_ref_cod_aluno) AND (historico_escolar_1.sequencial = hd.ref_sequencial))))
                WHERE ((hd.ref_ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND ((get_texto_sem_caracter_especial((upper(btrim((hd.nm_disciplina)::text)))::character varying))::text = (get_texto_sem_caracter_especial((upper(btrim(historico_disciplinas.nm_disciplina)))::character varying))::text) AND (historico_escolar_1.ativo = 1) AND (historico_escolar_1.extra_curricular = 0) AND ("substring"((historico_escolar_1.nm_serie)::text, 1, 1) = (4)::text) AND (historico_escolar_1.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          FROM pmieducar.historico_escolar hee
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          WHERE ((hee.ref_cod_aluno = historico_escolar_1.ref_cod_aluno) AND ("substring"((historico_escolar_1.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0) AND (COALESCE(hee.dependencia, false) = false)))))
                LIMIT 1) AS nota_4serie,
              ( SELECT
                    CASE
                        WHEN (("substring"(btrim((hd.nota)::text), 1, 1) <> (0)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (1)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (2)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (3)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (4)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (5)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (6)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (7)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (8)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (9)::text)) THEN replace((hd.nota)::text, '.'::text, ','::text)
                        WHEN ((to_number(btrim((hd.nota)::text), '999'::text) > (10)::numeric) AND (to_number(btrim((hd.nota)::text), '999'::text) <= (20)::numeric)) THEN replace(btrim((hd.nota)::text), '.'::text, ','::text)
                        ELSE replace("substring"(btrim((hd.nota)::text), 1, 4), '.'::text, ','::text)
                        END AS replace
                FROM (pmieducar.historico_disciplinas hd
                         JOIN pmieducar.historico_escolar historico_escolar_1 ON (((historico_escolar_1.ref_cod_aluno = hd.ref_ref_cod_aluno) AND (historico_escolar_1.sequencial = hd.ref_sequencial))))
                WHERE ((hd.ref_ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND ((get_texto_sem_caracter_especial((upper(btrim((hd.nm_disciplina)::text)))::character varying))::text = (get_texto_sem_caracter_especial((upper(btrim(historico_disciplinas.nm_disciplina)))::character varying))::text) AND (historico_escolar_1.ativo = 1) AND (historico_escolar_1.extra_curricular = 0) AND ("substring"((historico_escolar_1.nm_serie)::text, 1, 1) = (5)::text) AND (historico_escolar_1.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          FROM pmieducar.historico_escolar hee
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          WHERE ((hee.ref_cod_aluno = historico_escolar_1.ref_cod_aluno) AND ("substring"((historico_escolar_1.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0) AND (COALESCE(hee.dependencia, false) = false)))))
                LIMIT 1) AS nota_5serie,
              ( SELECT
                    CASE
                        WHEN (("substring"(btrim((hd.nota)::text), 1, 1) <> (0)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (1)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (2)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (3)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (4)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (5)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (6)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (7)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (8)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (9)::text)) THEN replace((hd.nota)::text, '.'::text, ','::text)
                        WHEN ((to_number(btrim((hd.nota)::text), '999'::text) > (10)::numeric) AND (to_number(btrim((hd.nota)::text), '999'::text) <= (20)::numeric)) THEN replace(btrim((hd.nota)::text), '.'::text, ','::text)
                        ELSE replace("substring"(btrim((hd.nota)::text), 1, 4), '.'::text, ','::text)
                        END AS replace
                FROM (pmieducar.historico_disciplinas hd
                         JOIN pmieducar.historico_escolar historico_escolar_1 ON (((historico_escolar_1.ref_cod_aluno = hd.ref_ref_cod_aluno) AND (historico_escolar_1.sequencial = hd.ref_sequencial))))
                WHERE ((hd.ref_ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND ((get_texto_sem_caracter_especial((upper(btrim((hd.nm_disciplina)::text)))::character varying))::text = (get_texto_sem_caracter_especial((upper(btrim(historico_disciplinas.nm_disciplina)))::character varying))::text) AND (historico_escolar_1.ativo = 1) AND (historico_escolar_1.extra_curricular = 0) AND ("substring"((historico_escolar_1.nm_serie)::text, 1, 1) = (6)::text) AND (historico_escolar_1.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          FROM pmieducar.historico_escolar hee
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          WHERE ((hee.ref_cod_aluno = historico_escolar_1.ref_cod_aluno) AND ("substring"((historico_escolar_1.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0) AND (COALESCE(hee.dependencia, false) = false)))))
                LIMIT 1) AS nota_6serie,
              ( SELECT
                    CASE
                        WHEN (("substring"(btrim((hd.nota)::text), 1, 1) <> (0)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (1)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (2)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (3)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (4)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (5)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (6)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (7)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (8)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (9)::text)) THEN replace((hd.nota)::text, '.'::text, ','::text)
                        WHEN ((to_number(btrim((hd.nota)::text), '999'::text) > (10)::numeric) AND (to_number(btrim((hd.nota)::text), '999'::text) <= (20)::numeric)) THEN replace(btrim((hd.nota)::text), '.'::text, ','::text)
                        ELSE replace("substring"(btrim((hd.nota)::text), 1, 4), '.'::text, ','::text)
                        END AS replace
                FROM (pmieducar.historico_disciplinas hd
                         JOIN pmieducar.historico_escolar historico_escolar_1 ON (((historico_escolar_1.ref_cod_aluno = hd.ref_ref_cod_aluno) AND (historico_escolar_1.sequencial = hd.ref_sequencial))))
                WHERE ((hd.ref_ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND ((get_texto_sem_caracter_especial((upper(btrim((hd.nm_disciplina)::text)))::character varying))::text = (get_texto_sem_caracter_especial((upper(btrim(historico_disciplinas.nm_disciplina)))::character varying))::text) AND (historico_escolar_1.ativo = 1) AND (historico_escolar_1.extra_curricular = 0) AND ("substring"((historico_escolar_1.nm_serie)::text, 1, 1) = (7)::text) AND (historico_escolar_1.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          FROM pmieducar.historico_escolar hee
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          WHERE ((hee.ref_cod_aluno = historico_escolar_1.ref_cod_aluno) AND ("substring"((historico_escolar_1.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0) AND (COALESCE(hee.dependencia, false) = false)))))
                LIMIT 1) AS nota_7serie,
              ( SELECT
                    CASE
                        WHEN (("substring"(btrim((hd.nota)::text), 1, 1) <> (0)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (1)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (2)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (3)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (4)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (5)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (6)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (7)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (8)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (9)::text)) THEN replace((hd.nota)::text, '.'::text, ','::text)
                        WHEN ((to_number(btrim((hd.nota)::text), '999'::text) > (10)::numeric) AND (to_number(btrim((hd.nota)::text), '999'::text) <= (20)::numeric)) THEN replace(btrim((hd.nota)::text), '.'::text, ','::text)
                        ELSE replace("substring"(btrim((hd.nota)::text), 1, 4), '.'::text, ','::text)
                        END AS replace
                FROM (pmieducar.historico_disciplinas hd
                         JOIN pmieducar.historico_escolar historico_escolar_1 ON (((historico_escolar_1.ref_cod_aluno = hd.ref_ref_cod_aluno) AND (historico_escolar_1.sequencial = hd.ref_sequencial))))
                WHERE ((hd.ref_ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND ((get_texto_sem_caracter_especial((upper(btrim((hd.nm_disciplina)::text)))::character varying))::text = (get_texto_sem_caracter_especial((upper(btrim(historico_disciplinas.nm_disciplina)))::character varying))::text) AND (historico_escolar_1.ativo = 1) AND (historico_escolar_1.extra_curricular = 0) AND ("substring"((historico_escolar_1.nm_serie)::text, 1, 1) = (8)::text) AND (historico_escolar_1.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          FROM pmieducar.historico_escolar hee
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          WHERE ((hee.ref_cod_aluno = historico_escolar_1.ref_cod_aluno) AND ("substring"((historico_escolar_1.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0) AND (COALESCE(hee.dependencia, false) = false)))))
                LIMIT 1) AS nota_8serie,
              ( SELECT
                    CASE
                        WHEN (("substring"(btrim((hd.nota)::text), 1, 1) <> (0)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (1)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (2)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (3)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (4)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (5)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (6)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (7)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (8)::text) AND ("substring"(btrim((hd.nota)::text), 1, 1) <> (9)::text)) THEN replace((hd.nota)::text, '.'::text, ','::text)
                        WHEN ((to_number(btrim((hd.nota)::text), '999'::text) > (10)::numeric) AND (to_number(btrim((hd.nota)::text), '999'::text) <= (20)::numeric)) THEN replace(btrim((hd.nota)::text), '.'::text, ','::text)
                        ELSE replace("substring"(btrim((hd.nota)::text), 1, 4), '.'::text, ','::text)
                        END AS replace
                FROM (pmieducar.historico_disciplinas hd
                         JOIN pmieducar.historico_escolar historico_escolar_1 ON (((historico_escolar_1.ref_cod_aluno = hd.ref_ref_cod_aluno) AND (historico_escolar_1.sequencial = hd.ref_sequencial))))
                WHERE ((hd.ref_ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND ((get_texto_sem_caracter_especial((upper(btrim((hd.nm_disciplina)::text)))::character varying))::text = (get_texto_sem_caracter_especial((upper(btrim(historico_disciplinas.nm_disciplina)))::character varying))::text) AND (historico_escolar_1.ativo = 1) AND (historico_escolar_1.extra_curricular = 0) AND ("substring"((historico_escolar_1.nm_serie)::text, 1, 1) = (9)::text) AND (historico_escolar_1.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          FROM pmieducar.historico_escolar hee
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          WHERE ((hee.ref_cod_aluno = historico_escolar_1.ref_cod_aluno) AND ("substring"((historico_escolar_1.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0) AND (COALESCE(hee.dependencia, false) = false)))))
                LIMIT 1) AS nota_9serie,
              ( SELECT he.ano
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0)))) AND ("substring"((he.nm_serie)::text, 1, 1) = (1)::text))
                LIMIT 1) AS ano_1serie,
              ( SELECT he.escola
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0)))) AND ("substring"((he.nm_serie)::text, 1, 1) = (1)::text))
                LIMIT 1) AS escola_1serie,
              ( SELECT he.escola_cidade
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0)))) AND ("substring"((he.nm_serie)::text, 1, 1) = (1)::text))
                LIMIT 1) AS escola_cidade_1serie,
              ( SELECT he.escola_uf
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0)))) AND ("substring"((he.nm_serie)::text, 1, 1) = (1)::text))
                LIMIT 1) AS escola_uf_1serie,
              ( SELECT he.ano
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0)))) AND ("substring"((he.nm_serie)::text, 1, 1) = (2)::text))
                LIMIT 1) AS ano_2serie,
              ( SELECT he.escola
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0)))) AND ("substring"((he.nm_serie)::text, 1, 1) = (2)::text))
                LIMIT 1) AS escola_2serie,
              ( SELECT he.escola_cidade
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0)))) AND ("substring"((he.nm_serie)::text, 1, 1) = (2)::text))
                LIMIT 1) AS escola_cidade_2serie,
              ( SELECT he.escola_uf
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0)))) AND ("substring"((he.nm_serie)::text, 1, 1) = (2)::text))
                LIMIT 1) AS escola_uf_2serie,
              ( SELECT he.ano
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0)))) AND ("substring"((he.nm_serie)::text, 1, 1) = (3)::text))
                LIMIT 1) AS ano_3serie,
              ( SELECT he.escola
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0)))) AND ("substring"((he.nm_serie)::text, 1, 1) = (3)::text))
                LIMIT 1) AS escola_3serie,
              ( SELECT he.escola_cidade
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0)))) AND ("substring"((he.nm_serie)::text, 1, 1) = (3)::text))
                LIMIT 1) AS escola_cidade_3serie,
              ( SELECT he.escola_uf
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0)))) AND ("substring"((he.nm_serie)::text, 1, 1) = (3)::text))
                LIMIT 1) AS escola_uf_3serie,
              ( SELECT he.ano
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0)))) AND ("substring"((he.nm_serie)::text, 1, 1) = (4)::text))
                LIMIT 1) AS ano_4serie,
              ( SELECT he.escola
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0)))) AND ("substring"((he.nm_serie)::text, 1, 1) = (4)::text))
                LIMIT 1) AS escola_4serie,
              ( SELECT he.escola_cidade
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0)))) AND ("substring"((he.nm_serie)::text, 1, 1) = (4)::text))
                LIMIT 1) AS escola_cidade_4serie,
              ( SELECT he.escola_uf
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0)))) AND ("substring"((he.nm_serie)::text, 1, 1) = (4)::text))
                LIMIT 1) AS escola_uf_4serie,
              ( SELECT he.ano
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0)))) AND ("substring"((he.nm_serie)::text, 1, 1) = (5)::text))
                LIMIT 1) AS ano_5serie,
              ( SELECT he.escola
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0)))) AND ("substring"((he.nm_serie)::text, 1, 1) = (5)::text))
                LIMIT 1) AS escola_5serie,
              ( SELECT he.escola_cidade
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0)))) AND ("substring"((he.nm_serie)::text, 1, 1) = (5)::text))
                LIMIT 1) AS escola_cidade_5serie,
              ( SELECT he.escola_uf
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0)))) AND ("substring"((he.nm_serie)::text, 1, 1) = (5)::text))
                LIMIT 1) AS escola_uf_5serie,
              ( SELECT he.ano
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0)))) AND ("substring"((he.nm_serie)::text, 1, 1) = (6)::text))
                LIMIT 1) AS ano_6serie,
              ( SELECT he.escola
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0)))) AND ("substring"((he.nm_serie)::text, 1, 1) = (6)::text))
                LIMIT 1) AS escola_6serie,
              ( SELECT he.escola_cidade
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0)))) AND ("substring"((he.nm_serie)::text, 1, 1) = (6)::text))
                LIMIT 1) AS escola_cidade_6serie,
              ( SELECT he.escola_uf
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0)))) AND ("substring"((he.nm_serie)::text, 1, 1) = (6)::text))
                LIMIT 1) AS escola_uf_6serie,
              ( SELECT he.ano
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0)))) AND ("substring"((he.nm_serie)::text, 1, 1) = (7)::text))
                LIMIT 1) AS ano_7serie,
              ( SELECT he.escola
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0)))) AND ("substring"((he.nm_serie)::text, 1, 1) = (7)::text))
                LIMIT 1) AS escola_7serie,
              ( SELECT he.escola_cidade
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0)))) AND ("substring"((he.nm_serie)::text, 1, 1) = (7)::text))
                LIMIT 1) AS escola_cidade_7serie,
              ( SELECT he.escola_uf
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0)))) AND ("substring"((he.nm_serie)::text, 1, 1) = (7)::text))
                LIMIT 1) AS escola_uf_7serie,
              ( SELECT he.ano
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0)))) AND ("substring"((he.nm_serie)::text, 1, 1) = (8)::text))
                LIMIT 1) AS ano_8serie,
              ( SELECT he.escola
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0)))) AND ("substring"((he.nm_serie)::text, 1, 1) = (8)::text))
                LIMIT 1) AS escola_8serie,
              ( SELECT he.escola_cidade
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0)))) AND ("substring"((he.nm_serie)::text, 1, 1) = (8)::text))
                LIMIT 1) AS escola_cidade_8serie,
              ( SELECT he.escola_uf
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0)))) AND ("substring"((he.nm_serie)::text, 1, 1) = (8)::text))
                LIMIT 1) AS escola_uf_8serie,
              ( SELECT he.ano
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0)))) AND ("substring"((he.nm_serie)::text, 1, 1) = (9)::text))
                LIMIT 1) AS ano_9serie,
              ( SELECT he.escola
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0)))) AND ("substring"((he.nm_serie)::text, 1, 1) = (9)::text))
                LIMIT 1) AS escola_9serie,
              ( SELECT he.escola_cidade
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0)))) AND ("substring"((he.nm_serie)::text, 1, 1) = (9)::text))
                LIMIT 1) AS escola_cidade_9serie,
              ( SELECT he.escola_uf
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0)))) AND ("substring"((he.nm_serie)::text, 1, 1) = (9)::text))
                LIMIT 1) AS escola_uf_9serie,
              ( SELECT DISTINCT (he.aprovado = 4)
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0)))) AND ("substring"((he.nm_serie)::text, 1, 1) = (1)::text))
                ORDER BY (he.aprovado = 4)
                LIMIT 1) AS transferido1,
              ( SELECT DISTINCT (he.aprovado = 4)
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0)))) AND ("substring"((he.nm_serie)::text, 1, 1) = (2)::text))
                ORDER BY (he.aprovado = 4)
                LIMIT 1) AS transferido2,
              ( SELECT DISTINCT (he.aprovado = 4)
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0)))) AND ("substring"((he.nm_serie)::text, 1, 1) = (3)::text))
                ORDER BY (he.aprovado = 4)
                LIMIT 1) AS transferido3,
              ( SELECT DISTINCT (he.aprovado = 4)
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0)))) AND ("substring"((he.nm_serie)::text, 1, 1) = (4)::text))
                ORDER BY (he.aprovado = 4)
                LIMIT 1) AS transferido4,
              ( SELECT DISTINCT (he.aprovado = 4)
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0)))) AND ("substring"((he.nm_serie)::text, 1, 1) = (5)::text))
                ORDER BY (he.aprovado = 4)
                LIMIT 1) AS transferido5,
              ( SELECT DISTINCT (he.aprovado = 4)
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0)))) AND ("substring"((he.nm_serie)::text, 1, 1) = (6)::text))
                ORDER BY (he.aprovado = 4)
                LIMIT 1) AS transferido6,
              ( SELECT DISTINCT (he.aprovado = 4)
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 11) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                               FROM pmieducar.historico_escolar hee
                                                                                                                               WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0)))) AND ("substring"((he.nm_serie)::text, 1, 1) = (7)::text))
                ORDER BY (he.aprovado = 4)
                LIMIT 1) AS transferido7,
              ( SELECT DISTINCT (he.aprovado = 4)
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0)))) AND ("substring"((he.nm_serie)::text, 1, 1) = (8)::text))
                ORDER BY (he.aprovado = 4)
                LIMIT 1) AS transferido8,
              ( SELECT DISTINCT (he.aprovado = 4)
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0)))) AND ("substring"((he.nm_serie)::text, 1, 1) = (9)::text))
                ORDER BY (he.aprovado = 4)
                LIMIT 1) AS transferido9,
              ( SELECT hd.dependencia
                FROM pmieducar.historico_disciplinas hd
                WHERE ((hd.ref_ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (hd.ref_sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                   FROM pmieducar.historico_escolar hee
                                                                                                                   WHERE ((hee.ref_cod_aluno = hd.ref_ref_cod_aluno) AND ((get_texto_sem_caracter_especial((upper(btrim((hd.nm_disciplina)::text)))::character varying))::text = (get_texto_sem_caracter_especial((upper(btrim(historico_disciplinas.nm_disciplina)))::character varying))::text) AND ("substring"((hee.nm_serie)::text, 1, 1) = (1)::text) AND (hee.ativo = 1) AND (hee.extra_curricular = 0) AND (COALESCE(hee.dependencia, false) = false)))))
                LIMIT 1) AS disciplina_dependencia1,
              ( SELECT hd.dependencia
                FROM pmieducar.historico_disciplinas hd
                WHERE ((hd.ref_ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (hd.ref_sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                   FROM pmieducar.historico_escolar hee
                                                                                                                   WHERE ((hee.ref_cod_aluno = hd.ref_ref_cod_aluno) AND ((get_texto_sem_caracter_especial((upper(btrim((hd.nm_disciplina)::text)))::character varying))::text = (get_texto_sem_caracter_especial((upper(btrim(historico_disciplinas.nm_disciplina)))::character varying))::text) AND ("substring"((hee.nm_serie)::text, 1, 1) = (2)::text) AND (hee.ativo = 1) AND (hee.extra_curricular = 0) AND (COALESCE(hee.dependencia, false) = false)))))
                LIMIT 1) AS disciplina_dependencia2,
              ( SELECT hd.dependencia
                FROM pmieducar.historico_disciplinas hd
                WHERE ((hd.ref_ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (hd.ref_sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                   FROM pmieducar.historico_escolar hee
                                                                                                                   WHERE ((hee.ref_cod_aluno = hd.ref_ref_cod_aluno) AND ((get_texto_sem_caracter_especial((upper(btrim((hd.nm_disciplina)::text)))::character varying))::text = (get_texto_sem_caracter_especial((upper(btrim(historico_disciplinas.nm_disciplina)))::character varying))::text) AND ("substring"((hee.nm_serie)::text, 1, 1) = (3)::text) AND (hee.ativo = 1) AND (hee.extra_curricular = 0) AND (COALESCE(hee.dependencia, false) = false)))))
                LIMIT 1) AS disciplina_dependencia3,
              ( SELECT hd.dependencia
                FROM pmieducar.historico_disciplinas hd
                WHERE ((hd.ref_ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (hd.ref_sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                   FROM pmieducar.historico_escolar hee
                                                                                                                   WHERE ((hee.ref_cod_aluno = hd.ref_ref_cod_aluno) AND ((get_texto_sem_caracter_especial((upper(btrim((hd.nm_disciplina)::text)))::character varying))::text = (get_texto_sem_caracter_especial((upper(btrim(historico_disciplinas.nm_disciplina)))::character varying))::text) AND ("substring"((hee.nm_serie)::text, 1, 1) = (4)::text) AND (hee.ativo = 1) AND (hee.extra_curricular = 0) AND (COALESCE(hee.dependencia, false) = false)))))
                LIMIT 1) AS disciplina_dependencia4,
              ( SELECT hd.dependencia
                FROM pmieducar.historico_disciplinas hd
                WHERE ((hd.ref_ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (hd.ref_sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                   FROM pmieducar.historico_escolar hee
                                                                                                                   WHERE ((hee.ref_cod_aluno = hd.ref_ref_cod_aluno) AND ((get_texto_sem_caracter_especial((upper(btrim((hd.nm_disciplina)::text)))::character varying))::text = (get_texto_sem_caracter_especial((upper(btrim(historico_disciplinas.nm_disciplina)))::character varying))::text) AND ("substring"((hee.nm_serie)::text, 1, 1) = (5)::text) AND (hee.ativo = 1) AND (hee.extra_curricular = 0) AND (COALESCE(hee.dependencia, false) = false)))))
                LIMIT 1) AS disciplina_dependencia5,
              ( SELECT hd.dependencia
                FROM pmieducar.historico_disciplinas hd
                WHERE ((hd.ref_ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (hd.ref_sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                   FROM pmieducar.historico_escolar hee
                                                                                                                   WHERE ((hee.ref_cod_aluno = hd.ref_ref_cod_aluno) AND ((get_texto_sem_caracter_especial((upper(btrim((hd.nm_disciplina)::text)))::character varying))::text = (get_texto_sem_caracter_especial((upper(btrim(historico_disciplinas.nm_disciplina)))::character varying))::text) AND ("substring"((hee.nm_serie)::text, 1, 1) = (6)::text) AND (hee.ativo = 1) AND (hee.extra_curricular = 0) AND (COALESCE(hee.dependencia, false) = false)))))
                LIMIT 1) AS disciplina_dependencia6,
              ( SELECT hd.dependencia
                FROM pmieducar.historico_disciplinas hd
                WHERE ((hd.ref_ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (hd.ref_sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                   FROM pmieducar.historico_escolar hee
                                                                                                                   WHERE ((hee.ref_cod_aluno = hd.ref_ref_cod_aluno) AND ((get_texto_sem_caracter_especial((upper(btrim((hd.nm_disciplina)::text)))::character varying))::text = (get_texto_sem_caracter_especial((upper(btrim(historico_disciplinas.nm_disciplina)))::character varying))::text) AND ("substring"((hee.nm_serie)::text, 1, 1) = (7)::text) AND (hee.ativo = 1) AND (hee.extra_curricular = 0) AND (COALESCE(hee.dependencia, false) = false)))))
                LIMIT 1) AS disciplina_dependencia7,
              ( SELECT hd.dependencia
                FROM pmieducar.historico_disciplinas hd
                WHERE ((hd.ref_ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (hd.ref_sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                   FROM pmieducar.historico_escolar hee
                                                                                                                   WHERE ((hee.ref_cod_aluno = hd.ref_ref_cod_aluno) AND ((get_texto_sem_caracter_especial((upper(btrim((hd.nm_disciplina)::text)))::character varying))::text = (get_texto_sem_caracter_especial((upper(btrim(historico_disciplinas.nm_disciplina)))::character varying))::text) AND ("substring"((hee.nm_serie)::text, 1, 1) = (8)::text) AND (hee.ativo = 1) AND (hee.extra_curricular = 0) AND (COALESCE(hee.dependencia, false) = false)))))
                LIMIT 1) AS disciplina_dependencia8,
              ( SELECT hd.dependencia
                FROM pmieducar.historico_disciplinas hd
                WHERE ((hd.ref_ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (hd.ref_sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                   FROM pmieducar.historico_escolar hee
                                                                                                                   WHERE ((hee.ref_cod_aluno = hd.ref_ref_cod_aluno) AND ((get_texto_sem_caracter_especial((upper(btrim((hd.nm_disciplina)::text)))::character varying))::text = (get_texto_sem_caracter_especial((upper(btrim(historico_disciplinas.nm_disciplina)))::character varying))::text) AND ("substring"((hee.nm_serie)::text, 1, 1) = (9)::text) AND (hee.ativo = 1) AND (hee.extra_curricular = 0) AND (COALESCE(hee.dependencia, false) = false)))))
                LIMIT 1) AS disciplina_dependencia9,
              ( SELECT hd.carga_horaria_disciplina
                FROM pmieducar.historico_disciplinas hd
                WHERE ((hd.ref_ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (hd.ref_sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                   FROM pmieducar.historico_escolar hee
                                                                                                                   WHERE ((hee.ref_cod_aluno = hd.ref_ref_cod_aluno) AND (public.fcn_upper((hd.nm_disciplina)::text) = public.fcn_upper(historico_disciplinas.nm_disciplina)) AND ("substring"((hee.nm_serie)::text, 1, 1) = (1)::text)))))
                LIMIT 1) AS carga_horaria_disciplina1,
              ( SELECT hd.carga_horaria_disciplina
                FROM pmieducar.historico_disciplinas hd
                WHERE ((hd.ref_ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (hd.ref_sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                   FROM pmieducar.historico_escolar hee
                                                                                                                   WHERE ((hee.ref_cod_aluno = hd.ref_ref_cod_aluno) AND (public.fcn_upper((hd.nm_disciplina)::text) = public.fcn_upper(historico_disciplinas.nm_disciplina)) AND ("substring"((hee.nm_serie)::text, 1, 1) = (2)::text)))))
                LIMIT 1) AS carga_horaria_disciplina2,
              ( SELECT hd.carga_horaria_disciplina
                FROM pmieducar.historico_disciplinas hd
                WHERE ((hd.ref_ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (hd.ref_sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                   FROM pmieducar.historico_escolar hee
                                                                                                                   WHERE ((hee.ref_cod_aluno = hd.ref_ref_cod_aluno) AND (public.fcn_upper((hd.nm_disciplina)::text) = public.fcn_upper(historico_disciplinas.nm_disciplina)) AND ("substring"((hee.nm_serie)::text, 1, 1) = (3)::text)))))
                LIMIT 1) AS carga_horaria_disciplina3,
              ( SELECT hd.carga_horaria_disciplina
                FROM pmieducar.historico_disciplinas hd
                WHERE ((hd.ref_ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (hd.ref_sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                   FROM pmieducar.historico_escolar hee
                                                                                                                   WHERE ((hee.ref_cod_aluno = hd.ref_ref_cod_aluno) AND (public.fcn_upper((hd.nm_disciplina)::text) = public.fcn_upper(historico_disciplinas.nm_disciplina)) AND ("substring"((hee.nm_serie)::text, 1, 1) = (4)::text)))))
                LIMIT 1) AS carga_horaria_disciplina4,
              ( SELECT hd.carga_horaria_disciplina
                FROM pmieducar.historico_disciplinas hd
                WHERE ((hd.ref_ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (hd.ref_sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                   FROM pmieducar.historico_escolar hee
                                                                                                                   WHERE ((hee.ref_cod_aluno = hd.ref_ref_cod_aluno) AND (public.fcn_upper((hd.nm_disciplina)::text) = public.fcn_upper(historico_disciplinas.nm_disciplina)) AND ("substring"((hee.nm_serie)::text, 1, 1) = (5)::text)))))
                LIMIT 1) AS carga_horaria_disciplina5,
              ( SELECT hd.carga_horaria_disciplina
                FROM pmieducar.historico_disciplinas hd
                WHERE ((hd.ref_ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (hd.ref_sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                   FROM pmieducar.historico_escolar hee
                                                                                                                   WHERE ((hee.ref_cod_aluno = hd.ref_ref_cod_aluno) AND (public.fcn_upper((hd.nm_disciplina)::text) = public.fcn_upper(historico_disciplinas.nm_disciplina)) AND ("substring"((hee.nm_serie)::text, 1, 1) = (6)::text)))))
                LIMIT 1) AS carga_horaria_disciplina6,
              ( SELECT hd.carga_horaria_disciplina
                FROM pmieducar.historico_disciplinas hd
                WHERE ((hd.ref_ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (hd.ref_sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                   FROM pmieducar.historico_escolar hee
                                                                                                                   WHERE ((hee.ref_cod_aluno = hd.ref_ref_cod_aluno) AND (public.fcn_upper((hd.nm_disciplina)::text) = public.fcn_upper(historico_disciplinas.nm_disciplina)) AND ("substring"((hee.nm_serie)::text, 1, 1) = (7)::text)))))
                LIMIT 1) AS carga_horaria_disciplina7,
              ( SELECT hd.carga_horaria_disciplina
                FROM pmieducar.historico_disciplinas hd
                WHERE ((hd.ref_ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (hd.ref_sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                   FROM pmieducar.historico_escolar hee
                                                                                                                   WHERE ((hee.ref_cod_aluno = hd.ref_ref_cod_aluno) AND (public.fcn_upper((hd.nm_disciplina)::text) = public.fcn_upper(historico_disciplinas.nm_disciplina)) AND ("substring"((hee.nm_serie)::text, 1, 1) = (8)::text)))))
                LIMIT 1) AS carga_horaria_disciplina8,
              ( SELECT hd.carga_horaria_disciplina
                FROM pmieducar.historico_disciplinas hd
                WHERE ((hd.ref_ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (hd.ref_sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                   FROM pmieducar.historico_escolar hee
                                                                                                                   WHERE ((hee.ref_cod_aluno = hd.ref_ref_cod_aluno) AND (public.fcn_upper((hd.nm_disciplina)::text) = public.fcn_upper(historico_disciplinas.nm_disciplina)) AND ("substring"((hee.nm_serie)::text, 1, 1) = (9)::text)))))
                LIMIT 1) AS carga_horaria_disciplina9,
              ( SELECT he.carga_horaria
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0)))) AND ("substring"((he.nm_serie)::text, 1, 1) = (1)::text))
                LIMIT 1) AS carga_horaria1,
              ( SELECT he.carga_horaria
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0)))) AND ("substring"((he.nm_serie)::text, 1, 1) = (2)::text))
                LIMIT 1) AS carga_horaria2,
              ( SELECT he.carga_horaria
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0)))) AND ("substring"((he.nm_serie)::text, 1, 1) = (3)::text))
                LIMIT 1) AS carga_horaria3,
              ( SELECT he.carga_horaria
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0)))) AND ("substring"((he.nm_serie)::text, 1, 1) = (4)::text))
                LIMIT 1) AS carga_horaria4,
              ( SELECT he.carga_horaria
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0)))) AND ("substring"((he.nm_serie)::text, 1, 1) = (5)::text))
                LIMIT 1) AS carga_horaria5,
              ( SELECT he.carga_horaria
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0)))) AND ("substring"((he.nm_serie)::text, 1, 1) = (6)::text))
                LIMIT 1) AS carga_horaria6,
              ( SELECT he.carga_horaria
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0)))) AND ("substring"((he.nm_serie)::text, 1, 1) = (7)::text))
                LIMIT 1) AS carga_horaria7,
              ( SELECT he.carga_horaria
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0)))) AND ("substring"((he.nm_serie)::text, 1, 1) = (8)::text))
                LIMIT 1) AS carga_horaria8,
              ( SELECT he.carga_horaria
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0)))) AND ("substring"((he.nm_serie)::text, 1, 1) = (9)::text))
                LIMIT 1) AS carga_horaria9,
              ( SELECT public.textcat_all(phe.observacao) AS textcat_all
                FROM pmieducar.historico_escolar phe
                WHERE ((phe.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (phe.ativo = 1) AND (phe.extra_curricular = 0) AND (phe.sequencial = ( SELECT max(he.sequencial) AS max
                                                                                                                                                                FROM pmieducar.historico_escolar he
                                                                                                                                                                WHERE ((he.ref_cod_instituicao = phe.ref_cod_instituicao) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((phe.nm_serie)::text, 1, 1)) AND (he.ref_cod_aluno = phe.ref_cod_aluno) AND (he.ativo = 1)))))) AS observacao_all,
              ( SELECT m.cod_matricula
                FROM pmieducar.matricula m
                WHERE ((m.ano = ( SELECT historico_escolar_1.ano
                                  FROM pmieducar.historico_escolar historico_escolar_1
                                  WHERE ((historico_escolar_1.aprovado = 4) AND (historico_escolar_1.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (historico_escolar_1.ativo = 1) AND (historico_escolar_1.extra_curricular = 0))
                                  ORDER BY historico_escolar_1.ano DESC, historico_escolar_1.sequencial DESC
                                  LIMIT 1)) AND (( SELECT historico_escolar_1.sequencial
                                                   FROM pmieducar.historico_escolar historico_escolar_1
                                                   WHERE ((historico_escolar_1.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (historico_escolar_1.ativo = 1) AND (historico_escolar_1.extra_curricular = 0))
                                                   ORDER BY historico_escolar_1.ano DESC, historico_escolar_1.sequencial DESC
                                                   LIMIT 1) = ( SELECT historico_escolar_1.sequencial
                                                                FROM pmieducar.historico_escolar historico_escolar_1
                                                                WHERE ((historico_escolar_1.aprovado = 4) AND (historico_escolar_1.ativo = 1) AND (historico_escolar_1.extra_curricular = 0) AND (historico_escolar_1.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno))
                                                                ORDER BY historico_escolar_1.ano DESC, historico_escolar_1.sequencial DESC
                                                                LIMIT 1)) AND (m.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (m.ativo = 1) AND (m.aprovado = 4))
                ORDER BY m.cod_matricula DESC
                LIMIT 1) AS matricula_transferido,
              ( SELECT historico_carga_horaria_componente((historico_disciplinas.nm_disciplina)::character varying, he.nm_serie, he.ref_cod_escola) AS historico_carga_horaria_componente
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0)))) AND ("substring"((he.nm_serie)::text, 1, 1) = (1)::text))
                LIMIT 1) AS ch_componente_1,
              ( SELECT historico_carga_horaria_componente((historico_disciplinas.nm_disciplina)::character varying, he.nm_serie, he.ref_cod_escola) AS historico_carga_horaria_componente
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0)))) AND ("substring"((he.nm_serie)::text, 1, 1) = (2)::text))
                LIMIT 1) AS ch_componente_2,
              ( SELECT historico_carga_horaria_componente((historico_disciplinas.nm_disciplina)::character varying, he.nm_serie, he.ref_cod_escola) AS historico_carga_horaria_componente
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0)))) AND ("substring"((he.nm_serie)::text, 1, 1) = (3)::text))
                LIMIT 1) AS ch_componente_3,
              ( SELECT historico_carga_horaria_componente((historico_disciplinas.nm_disciplina)::character varying, he.nm_serie, he.ref_cod_escola) AS historico_carga_horaria_componente
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0)))) AND ("substring"((he.nm_serie)::text, 1, 1) = (4)::text))
                LIMIT 1) AS ch_componente_4,
              ( SELECT historico_carga_horaria_componente((historico_disciplinas.nm_disciplina)::character varying, he.nm_serie, he.ref_cod_escola) AS historico_carga_horaria_componente
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0)))) AND ("substring"((he.nm_serie)::text, 1, 1) = (5)::text))
                LIMIT 1) AS ch_componente_5,
              ( SELECT historico_carga_horaria_componente((historico_disciplinas.nm_disciplina)::character varying, he.nm_serie, he.ref_cod_escola) AS historico_carga_horaria_componente
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0)))) AND ("substring"((he.nm_serie)::text, 1, 1) = (6)::text))
                LIMIT 1) AS ch_componente_6,
              ( SELECT historico_carga_horaria_componente((historico_disciplinas.nm_disciplina)::character varying, he.nm_serie, he.ref_cod_escola) AS historico_carga_horaria_componente
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0)))) AND ("substring"((he.nm_serie)::text, 1, 1) = (7)::text))
                LIMIT 1) AS ch_componente_7,
              ( SELECT historico_carga_horaria_componente((historico_disciplinas.nm_disciplina)::character varying, he.nm_serie, he.ref_cod_escola) AS historico_carga_horaria_componente
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0)))) AND ("substring"((he.nm_serie)::text, 1, 1) = (8)::text))
                LIMIT 1) AS ch_componente_8,
              ( SELECT historico_carga_horaria_componente((historico_disciplinas.nm_disciplina)::character varying, he.nm_serie, he.ref_cod_escola) AS historico_carga_horaria_componente
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0)))) AND ("substring"((he.nm_serie)::text, 1, 1) = (9)::text))
                LIMIT 1) AS ch_componente_9,
              ( SELECT he.frequencia
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0)))) AND ("substring"((he.nm_serie)::text, 1, 1) = (1)::text))
                LIMIT 1) AS frequencia1,
              ( SELECT he.frequencia
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0)))) AND ("substring"((he.nm_serie)::text, 1, 1) = (2)::text))
                LIMIT 1) AS frequencia2,
              ( SELECT he.frequencia
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0)))) AND ("substring"((he.nm_serie)::text, 1, 1) = (3)::text))
                LIMIT 1) AS frequencia3,
              ( SELECT he.frequencia
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0)))) AND ("substring"((he.nm_serie)::text, 1, 1) = (4)::text))
                LIMIT 1) AS frequencia4,
              ( SELECT he.frequencia
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0)))) AND ("substring"((he.nm_serie)::text, 1, 1) = (5)::text))
                LIMIT 1) AS frequencia5,
              ( SELECT he.frequencia
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0)))) AND ("substring"((he.nm_serie)::text, 1, 1) = (6)::text))
                LIMIT 1) AS frequencia6,
              ( SELECT he.frequencia
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0)))) AND ("substring"((he.nm_serie)::text, 1, 1) = (7)::text))
                LIMIT 1) AS frequencia7,
              ( SELECT he.frequencia
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0)))) AND ("substring"((he.nm_serie)::text, 1, 1) = (8)::text))
                LIMIT 1) AS frequencia8,
              ( SELECT he.frequencia
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1) AND (hee.extra_curricular = 0)))) AND ("substring"((he.nm_serie)::text, 1, 1) = (9)::text))
                LIMIT 1) AS frequencia9,
              ( SELECT DISTINCT
                    CASE
                        WHEN (he.aceleracao = 1) THEN (
                                CASE
                                    WHEN (he.aprovado = 1) THEN 'Apro'::text
                                    WHEN (he.aprovado = 12) THEN 'AprDep'::text
                                    WHEN (he.aprovado = 13) THEN 'AprCo'::text
                                    WHEN (he.aprovado = 2) THEN 'Repr'::text
                                    WHEN (he.aprovado = 3) THEN 'Curs'::text
                                    WHEN (he.aprovado = 4) THEN 'Tran'::text
                                    WHEN (he.aprovado = 5) THEN 'Recl'::text
                                    WHEN (he.aprovado = 6) THEN 'Aban'::text
                                    WHEN (he.aprovado = 14) THEN 'RpFt'::text
                                    WHEN (he.aprovado = 15) THEN 'Fal'::text
                                    ELSE ''::text
                                    END || ' AC'::text)
                        ELSE
                            CASE
                                WHEN (he.aprovado = 1) THEN 'Apro'::text
                                WHEN (he.aprovado = 12) THEN 'AprDep'::text
                                WHEN (he.aprovado = 13) THEN 'AprCo'::text
                                WHEN (he.aprovado = 2) THEN 'Repr'::text
                                WHEN (he.aprovado = 3) THEN 'Curs'::text
                                WHEN (he.aprovado = 4) THEN 'Tran'::text
                                WHEN (he.aprovado = 5) THEN 'Recl'::text
                                WHEN (he.aprovado = 6) THEN 'Aban'::text
                                WHEN (he.aprovado = 14) THEN 'RpFt'::text
                                WHEN (he.aprovado = 15) THEN 'Fal'::text
                                ELSE ''::text
                                END
                        END AS "case"
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1)))) AND ("substring"((he.nm_serie)::text, 1, 1) = '1'::text))) AS status_serie1,
              ( SELECT DISTINCT
                    CASE
                        WHEN (he.aceleracao = 1) THEN (
                                CASE
                                    WHEN (he.aprovado = 1) THEN 'Apro'::text
                                    WHEN (he.aprovado = 12) THEN 'AprDep'::text
                                    WHEN (he.aprovado = 13) THEN 'AprCo'::text
                                    WHEN (he.aprovado = 2) THEN 'Repr'::text
                                    WHEN (he.aprovado = 3) THEN 'Curs'::text
                                    WHEN (he.aprovado = 4) THEN 'Tran'::text
                                    WHEN (he.aprovado = 5) THEN 'Recl'::text
                                    WHEN (he.aprovado = 6) THEN 'Aban'::text
                                    WHEN (he.aprovado = 14) THEN 'RpFt'::text
                                    WHEN (he.aprovado = 15) THEN 'Fal'::text
                                    ELSE ''::text
                                    END || ' AC'::text)
                        ELSE
                            CASE
                                WHEN (he.aprovado = 1) THEN 'Apro'::text
                                WHEN (he.aprovado = 12) THEN 'AprDep'::text
                                WHEN (he.aprovado = 13) THEN 'AprCo'::text
                                WHEN (he.aprovado = 2) THEN 'Repr'::text
                                WHEN (he.aprovado = 3) THEN 'Curs'::text
                                WHEN (he.aprovado = 4) THEN 'Tran'::text
                                WHEN (he.aprovado = 5) THEN 'Recl'::text
                                WHEN (he.aprovado = 6) THEN 'Aban'::text
                                WHEN (he.aprovado = 14) THEN 'RpFt'::text
                                WHEN (he.aprovado = 15) THEN 'Fal'::text
                                ELSE ''::text
                                END
                        END AS "case"
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1)))) AND ("substring"((he.nm_serie)::text, 1, 1) = '2'::text))) AS status_serie2,
              ( SELECT DISTINCT
                    CASE
                        WHEN (he.aceleracao = 1) THEN (
                                CASE
                                    WHEN (he.aprovado = 1) THEN 'Apro'::text
                                    WHEN (he.aprovado = 12) THEN 'AprDep'::text
                                    WHEN (he.aprovado = 13) THEN 'AprCo'::text
                                    WHEN (he.aprovado = 2) THEN 'Repr'::text
                                    WHEN (he.aprovado = 3) THEN 'Curs'::text
                                    WHEN (he.aprovado = 4) THEN 'Tran'::text
                                    WHEN (he.aprovado = 5) THEN 'Recl'::text
                                    WHEN (he.aprovado = 6) THEN 'Aban'::text
                                    WHEN (he.aprovado = 14) THEN 'RpFt'::text
                                    WHEN (he.aprovado = 15) THEN 'Fal'::text
                                    ELSE ''::text
                                    END || ' AC'::text)
                        ELSE
                            CASE
                                WHEN (he.aprovado = 1) THEN 'Apro'::text
                                WHEN (he.aprovado = 12) THEN 'AprDep'::text
                                WHEN (he.aprovado = 13) THEN 'AprCo'::text
                                WHEN (he.aprovado = 2) THEN 'Repr'::text
                                WHEN (he.aprovado = 3) THEN 'Curs'::text
                                WHEN (he.aprovado = 4) THEN 'Tran'::text
                                WHEN (he.aprovado = 5) THEN 'Recl'::text
                                WHEN (he.aprovado = 6) THEN 'Aban'::text
                                WHEN (he.aprovado = 14) THEN 'RpFt'::text
                                WHEN (he.aprovado = 15) THEN 'Fal'::text
                                ELSE ''::text
                                END
                        END AS "case"
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1)))) AND ("substring"((he.nm_serie)::text, 1, 1) = '3'::text))) AS status_serie3,
              ( SELECT DISTINCT
                    CASE
                        WHEN (he.aceleracao = 1) THEN (
                                CASE
                                    WHEN (he.aprovado = 1) THEN 'Apro'::text
                                    WHEN (he.aprovado = 12) THEN 'AprDep'::text
                                    WHEN (he.aprovado = 13) THEN 'AprCo'::text
                                    WHEN (he.aprovado = 2) THEN 'Repr'::text
                                    WHEN (he.aprovado = 3) THEN 'Curs'::text
                                    WHEN (he.aprovado = 4) THEN 'Tran'::text
                                    WHEN (he.aprovado = 5) THEN 'Recl'::text
                                    WHEN (he.aprovado = 6) THEN 'Aban'::text
                                    WHEN (he.aprovado = 14) THEN 'RpFt'::text
                                    WHEN (he.aprovado = 15) THEN 'Fal'::text
                                    ELSE ''::text
                                    END || ' AC'::text)
                        ELSE
                            CASE
                                WHEN (he.aprovado = 1) THEN 'Apro'::text
                                WHEN (he.aprovado = 12) THEN 'AprDep'::text
                                WHEN (he.aprovado = 13) THEN 'AprCo'::text
                                WHEN (he.aprovado = 2) THEN 'Repr'::text
                                WHEN (he.aprovado = 3) THEN 'Curs'::text
                                WHEN (he.aprovado = 4) THEN 'Tran'::text
                                WHEN (he.aprovado = 5) THEN 'Recl'::text
                                WHEN (he.aprovado = 6) THEN 'Aban'::text
                                WHEN (he.aprovado = 14) THEN 'RpFt'::text
                                WHEN (he.aprovado = 15) THEN 'Fal'::text
                                ELSE ''::text
                                END
                        END AS "case"
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1)))) AND ("substring"((he.nm_serie)::text, 1, 1) = '4'::text))) AS status_serie4,
              ( SELECT DISTINCT
                    CASE
                        WHEN (he.aceleracao = 1) THEN (
                                CASE
                                    WHEN (he.aprovado = 1) THEN 'Apro'::text
                                    WHEN (he.aprovado = 12) THEN 'AprDep'::text
                                    WHEN (he.aprovado = 13) THEN 'AprCo'::text
                                    WHEN (he.aprovado = 2) THEN 'Repr'::text
                                    WHEN (he.aprovado = 3) THEN 'Curs'::text
                                    WHEN (he.aprovado = 4) THEN 'Tran'::text
                                    WHEN (he.aprovado = 5) THEN 'Recl'::text
                                    WHEN (he.aprovado = 6) THEN 'Aban'::text
                                    WHEN (he.aprovado = 14) THEN 'RpFt'::text
                                    WHEN (he.aprovado = 15) THEN 'Fal'::text
                                    ELSE ''::text
                                    END || ' AC'::text)
                        ELSE
                            CASE
                                WHEN (he.aprovado = 1) THEN 'Apro'::text
                                WHEN (he.aprovado = 12) THEN 'AprDep'::text
                                WHEN (he.aprovado = 13) THEN 'AprCo'::text
                                WHEN (he.aprovado = 2) THEN 'Repr'::text
                                WHEN (he.aprovado = 3) THEN 'Curs'::text
                                WHEN (he.aprovado = 4) THEN 'Tran'::text
                                WHEN (he.aprovado = 5) THEN 'Recl'::text
                                WHEN (he.aprovado = 6) THEN 'Aban'::text
                                WHEN (he.aprovado = 14) THEN 'RpFt'::text
                                WHEN (he.aprovado = 15) THEN 'Fal'::text
                                ELSE ''::text
                                END
                        END AS "case"
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1)))) AND ("substring"((he.nm_serie)::text, 1, 1) = '5'::text))) AS status_serie5,
              ( SELECT DISTINCT
                    CASE
                        WHEN (he.aceleracao = 1) THEN (
                                CASE
                                    WHEN (he.aprovado = 1) THEN 'Apro'::text
                                    WHEN (he.aprovado = 12) THEN 'AprDep'::text
                                    WHEN (he.aprovado = 13) THEN 'AprCo'::text
                                    WHEN (he.aprovado = 2) THEN 'Repr'::text
                                    WHEN (he.aprovado = 3) THEN 'Curs'::text
                                    WHEN (he.aprovado = 4) THEN 'Tran'::text
                                    WHEN (he.aprovado = 5) THEN 'Recl'::text
                                    WHEN (he.aprovado = 6) THEN 'Aban'::text
                                    WHEN (he.aprovado = 14) THEN 'RpFt'::text
                                    WHEN (he.aprovado = 15) THEN 'Fal'::text
                                    ELSE ''::text
                                    END || ' AC'::text)
                        ELSE
                            CASE
                                WHEN (he.aprovado = 1) THEN 'Apro'::text
                                WHEN (he.aprovado = 12) THEN 'AprDep'::text
                                WHEN (he.aprovado = 13) THEN 'AprCo'::text
                                WHEN (he.aprovado = 2) THEN 'Repr'::text
                                WHEN (he.aprovado = 3) THEN 'Curs'::text
                                WHEN (he.aprovado = 4) THEN 'Tran'::text
                                WHEN (he.aprovado = 5) THEN 'Recl'::text
                                WHEN (he.aprovado = 6) THEN 'Aban'::text
                                WHEN (he.aprovado = 14) THEN 'RpFt'::text
                                WHEN (he.aprovado = 15) THEN 'Fal'::text
                                ELSE ''::text
                                END
                        END AS "case"
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1)))) AND ("substring"((he.nm_serie)::text, 1, 1) = '6'::text))) AS status_serie6,
              ( SELECT DISTINCT
                    CASE
                        WHEN (he.aceleracao = 1) THEN (
                                CASE
                                    WHEN (he.aprovado = 1) THEN 'Apro'::text
                                    WHEN (he.aprovado = 12) THEN 'AprDep'::text
                                    WHEN (he.aprovado = 13) THEN 'AprCo'::text
                                    WHEN (he.aprovado = 2) THEN 'Repr'::text
                                    WHEN (he.aprovado = 3) THEN 'Curs'::text
                                    WHEN (he.aprovado = 4) THEN 'Tran'::text
                                    WHEN (he.aprovado = 5) THEN 'Recl'::text
                                    WHEN (he.aprovado = 6) THEN 'Aban'::text
                                    WHEN (he.aprovado = 14) THEN 'RpFt'::text
                                    WHEN (he.aprovado = 15) THEN 'Fal'::text
                                    ELSE ''::text
                                    END || ' AC'::text)
                        ELSE
                            CASE
                                WHEN (he.aprovado = 1) THEN 'Apro'::text
                                WHEN (he.aprovado = 12) THEN 'AprDep'::text
                                WHEN (he.aprovado = 13) THEN 'AprCo'::text
                                WHEN (he.aprovado = 2) THEN 'Repr'::text
                                WHEN (he.aprovado = 3) THEN 'Curs'::text
                                WHEN (he.aprovado = 4) THEN 'Tran'::text
                                WHEN (he.aprovado = 5) THEN 'Recl'::text
                                WHEN (he.aprovado = 6) THEN 'Aban'::text
                                WHEN (he.aprovado = 14) THEN 'RpFt'::text
                                WHEN (he.aprovado = 15) THEN 'Fal'::text
                                ELSE ''::text
                                END
                        END AS "case"
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1)))) AND ("substring"((he.nm_serie)::text, 1, 1) = '7'::text))) AS status_serie7,
              ( SELECT DISTINCT
                    CASE
                        WHEN (he.aceleracao = 1) THEN (
                                CASE
                                    WHEN (he.aprovado = 1) THEN 'Apro'::text
                                    WHEN (he.aprovado = 12) THEN 'AprDep'::text
                                    WHEN (he.aprovado = 13) THEN 'AprCo'::text
                                    WHEN (he.aprovado = 2) THEN 'Repr'::text
                                    WHEN (he.aprovado = 3) THEN 'Curs'::text
                                    WHEN (he.aprovado = 4) THEN 'Tran'::text
                                    WHEN (he.aprovado = 5) THEN 'Recl'::text
                                    WHEN (he.aprovado = 6) THEN 'Aban'::text
                                    WHEN (he.aprovado = 14) THEN 'RpFt'::text
                                    WHEN (he.aprovado = 15) THEN 'Fal'::text
                                    ELSE ''::text
                                    END || ' AC'::text)
                        ELSE
                            CASE
                                WHEN (he.aprovado = 1) THEN 'Apro'::text
                                WHEN (he.aprovado = 12) THEN 'AprDep'::text
                                WHEN (he.aprovado = 13) THEN 'AprCo'::text
                                WHEN (he.aprovado = 2) THEN 'Repr'::text
                                WHEN (he.aprovado = 3) THEN 'Curs'::text
                                WHEN (he.aprovado = 4) THEN 'Tran'::text
                                WHEN (he.aprovado = 5) THEN 'Recl'::text
                                WHEN (he.aprovado = 6) THEN 'Aban'::text
                                WHEN (he.aprovado = 14) THEN 'RpFt'::text
                                WHEN (he.aprovado = 15) THEN 'Fal'::text
                                ELSE ''::text
                                END
                        END AS "case"
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1)))) AND ("substring"((he.nm_serie)::text, 1, 1) = '8'::text))) AS status_serie8,
              ( SELECT DISTINCT
                    CASE
                        WHEN (he.aceleracao = 1) THEN (
                                CASE
                                    WHEN (he.aprovado = 1) THEN 'Apro'::text
                                    WHEN (he.aprovado = 12) THEN 'AprDep'::text
                                    WHEN (he.aprovado = 13) THEN 'AprCo'::text
                                    WHEN (he.aprovado = 2) THEN 'Repr'::text
                                    WHEN (he.aprovado = 3) THEN 'Curs'::text
                                    WHEN (he.aprovado = 4) THEN 'Tran'::text
                                    WHEN (he.aprovado = 5) THEN 'Recl'::text
                                    WHEN (he.aprovado = 6) THEN 'Aban'::text
                                    WHEN (he.aprovado = 14) THEN 'RpFt'::text
                                    WHEN (he.aprovado = 15) THEN 'Fal'::text
                                    ELSE ''::text
                                    END || ' AC'::text)
                        ELSE
                            CASE
                                WHEN (he.aprovado = 1) THEN 'Apro'::text
                                WHEN (he.aprovado = 12) THEN 'AprDep'::text
                                WHEN (he.aprovado = 13) THEN 'AprCo'::text
                                WHEN (he.aprovado = 2) THEN 'Repr'::text
                                WHEN (he.aprovado = 3) THEN 'Curs'::text
                                WHEN (he.aprovado = 4) THEN 'Tran'::text
                                WHEN (he.aprovado = 5) THEN 'Recl'::text
                                WHEN (he.aprovado = 6) THEN 'Aban'::text
                                WHEN (he.aprovado = 14) THEN 'RpFt'::text
                                WHEN (he.aprovado = 15) THEN 'Fal'::text
                                ELSE ''::text
                                END
                        END AS "case"
                FROM pmieducar.historico_escolar he
                WHERE ((he.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (he.ativo = 1) AND (he.sequencial = ( SELECT max(hee.sequencial) AS max
                                                                                                                              FROM pmieducar.historico_escolar hee
                                                                                                                              WHERE ((hee.ref_cod_aluno = he.ref_cod_aluno) AND ("substring"((he.nm_serie)::text, 1, 1) = "substring"((hee.nm_serie)::text, 1, 1)) AND (hee.ativo = 1)))) AND ("substring"((he.nm_serie)::text, 1, 1) = '9'::text))) AS status_serie9
       FROM (( SELECT historico_disciplinas_1.sequencial,
                      historico_disciplinas_1.ref_ref_cod_aluno,
                      historico_disciplinas_1.ref_sequencial,
                      btrim((get_texto_sem_caracter_especial(historico_disciplinas_1.nm_disciplina))::text) AS nm_disciplina,
                      historico_disciplinas_1.nota,
                      historico_disciplinas_1.faltas,
                      historico_disciplinas_1.import
               FROM pmieducar.historico_disciplinas historico_disciplinas_1) historico_disciplinas
                JOIN pmieducar.historico_escolar ON (((historico_escolar.ref_cod_aluno = historico_disciplinas.ref_ref_cod_aluno) AND (historico_escolar.sequencial = historico_disciplinas.ref_sequencial))))
       WHERE ((historico_escolar.extra_curricular = 0) AND (historico_escolar.ativo = 1))
       GROUP BY historico_disciplinas.nm_disciplina, historico_disciplinas.ref_ref_cod_aluno, historico_escolar.ref_cod_aluno, historico_escolar.sequencial
       ORDER BY historico_disciplinas.nm_disciplina) historico
GROUP BY historico.disciplina, historico.cod_aluno, historico.nota_1serie, historico.nota_2serie, historico.nota_3serie, historico.nota_4serie, historico.nota_5serie, historico.nota_6serie, historico.nota_7serie, historico.nota_8serie, historico.nota_9serie, historico.ano_1serie, historico.ano_2serie, historico.ano_3serie, historico.ano_4serie, historico.ano_5serie, historico.ano_6serie, historico.ano_7serie, historico.ano_8serie, historico.ano_9serie, historico.escola_1serie, historico.escola_2serie, historico.escola_3serie, historico.escola_4serie, historico.escola_5serie, historico.escola_6serie, historico.escola_7serie, historico.escola_8serie, historico.escola_9serie, historico.escola_cidade_1serie, historico.escola_cidade_2serie, historico.escola_cidade_3serie, historico.escola_cidade_4serie, historico.escola_cidade_5serie, historico.escola_cidade_6serie, historico.escola_cidade_7serie, historico.escola_cidade_8serie, historico.escola_cidade_9serie, historico.escola_uf_1serie, historico.escola_uf_2serie, historico.escola_uf_3serie, historico.escola_uf_4serie, historico.escola_uf_5serie, historico.escola_uf_6serie, historico.escola_uf_7serie, historico.escola_uf_8serie, historico.escola_uf_9serie, historico.transferido1, historico.transferido2, historico.transferido3, historico.transferido4, historico.transferido5, historico.transferido6, historico.transferido7, historico.transferido8, historico.transferido9, historico.carga_horaria_disciplina1, historico.carga_horaria_disciplina2, historico.carga_horaria_disciplina3, historico.carga_horaria_disciplina4, historico.carga_horaria_disciplina5, historico.carga_horaria_disciplina6, historico.carga_horaria_disciplina7, historico.carga_horaria_disciplina8, historico.carga_horaria_disciplina9, historico.carga_horaria1, historico.carga_horaria2, historico.carga_horaria3, historico.carga_horaria4, historico.carga_horaria5, historico.carga_horaria6, historico.carga_horaria7, historico.carga_horaria8, historico.carga_horaria9, historico.disciplina_dependencia1, historico.disciplina_dependencia2, historico.disciplina_dependencia3, historico.disciplina_dependencia4, historico.disciplina_dependencia5, historico.disciplina_dependencia6, historico.disciplina_dependencia7, historico.disciplina_dependencia8, historico.disciplina_dependencia9, historico.ch_componente_1, historico.ch_componente_2, historico.ch_componente_3, historico.ch_componente_4, historico.ch_componente_5, historico.ch_componente_6, historico.ch_componente_7, historico.ch_componente_8, historico.ch_componente_9, historico.observacao_all, historico.matricula_transferido, historico.frequencia1, historico.frequencia2, historico.frequencia3, historico.frequencia4, historico.frequencia5, historico.frequencia6, historico.frequencia7, historico.frequencia8, historico.frequencia9;
