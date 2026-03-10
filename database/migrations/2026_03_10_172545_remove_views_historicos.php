<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        DB::unprepared(
            'DROP VIEW IF EXISTS relatorio.view_dados_historico_posicionamento;'
        );
        DB::unprepared(
            'DROP VIEW IF EXISTS relatorio.view_historico_series_anos_extra_curricular;'
        );
        DB::unprepared(
            'DROP VIEW IF EXISTS relatorio.view_historico_series_anos;'
        );
        DB::unprepared(
            'DROP VIEW IF EXISTS relatorio.view_historico_eja_extra_curricular'
        );
        DB::unprepared(
            'DROP VIEW IF EXISTS relatorio.view_historico_eja'
        );
        DB::unprepared(
            'DROP VIEW IF EXISTS relatorio.view_historico_9anos'
        );
    }
};
