<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        DB::statement('
            UPDATE pmieducar.historico_disciplinas hd
            SET historico_escolar_id = he.id
            FROM pmieducar.historico_escolar he
            WHERE hd.ref_ref_cod_aluno = he.ref_cod_aluno
              AND hd.ref_sequencial = he.sequencial
        ');
    }

    public function down(): void
    {
        DB::statement('
            UPDATE pmieducar.historico_disciplinas
            SET historico_escolar_id = NULL
        ');
    }
};
