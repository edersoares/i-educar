<?php

use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Migrations\Migration;

class CreatePublicLogradouroTable extends Migration
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
                
                CREATE TABLE public.logradouro (
                    idlog numeric(6,0) DEFAULT nextval((\'public.seq_logradouro\'::text)::regclass) NOT NULL,
                    idtlog character varying(5) NOT NULL,
                    nome character varying(150) NOT NULL,
                    idmun numeric(6,0) NOT NULL,
                    geom character varying,
                    ident_oficial character(1),
                    idpes_rev numeric,
                    data_rev timestamp without time zone,
                    origem_gravacao character(1) NOT NULL,
                    idpes_cad numeric,
                    data_cad timestamp without time zone NOT NULL,
                    operacao character(1) NOT NULL,
                    idsis_rev integer,
                    idsis_cad integer NOT NULL,
                    CONSTRAINT ck_logradouro_ident_oficial CHECK (((ident_oficial = \'S\'::bpchar) OR (ident_oficial = \'N\'::bpchar))),
                    CONSTRAINT ck_logradouro_operacao CHECK (((operacao = \'I\'::bpchar) OR (operacao = \'A\'::bpchar) OR (operacao = \'E\'::bpchar))),
                    CONSTRAINT ck_logradouro_origem_gravacao CHECK (((origem_gravacao = \'M\'::bpchar) OR (origem_gravacao = \'U\'::bpchar) OR (origem_gravacao = \'C\'::bpchar) OR (origem_gravacao = \'O\'::bpchar)))
                );
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
        Schema::dropIfExists('public.logradouro');
    }
}
