<?php

use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Migrations\Migration;

class CreatePmicontrolesisServicosTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        DB::unprepared(
            '
                SET default_with_oids = true;
                
                CREATE SEQUENCE pmicontrolesis.servicos_cod_servicos_seq
                    START WITH 1
                    INCREMENT BY 1
                    MINVALUE 0
                    NO MAXVALUE
                    CACHE 1;

                CREATE TABLE pmicontrolesis.servicos (
                    cod_servicos integer DEFAULT nextval(\'pmicontrolesis.servicos_cod_servicos_seq\'::regclass) NOT NULL,
                    ref_cod_funcionario_cad integer NOT NULL,
                    ref_cod_funcionario_exc integer,
                    url character varying(255),
                    caminho character varying(255),
                    data_cadastro timestamp without time zone NOT NULL,
                    data_exclusao timestamp without time zone,
                    ativo smallint DEFAULT (1)::smallint,
                    title character varying(255),
                    descricao text
                );
                
                ALTER TABLE ONLY pmicontrolesis.servicos
                    ADD CONSTRAINT servicos_pkey PRIMARY KEY (cod_servicos);

                SELECT pg_catalog.setval(\'pmicontrolesis.servicos_cod_servicos_seq\', 1, false);
            '
        );
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('pmicontrolesis.servicos');

        DB::unprepared('DROP SEQUENCE pmicontrolesis.servicos_cod_servicos_seq;');
    }
}