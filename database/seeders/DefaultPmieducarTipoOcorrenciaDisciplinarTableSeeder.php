<?php

namespace Database\Seeders;

use App\Models\LegacyDisciplinaryOccurrenceType;
use App\Models\LegacyUser;
use Illuminate\Database\Seeder;

class DefaultPmieducarTipoOcorrenciaDisciplinarTableSeeder extends Seeder
{
    public function run()
    {
        $user = LegacyUser::query()
            ->orderBy('cod_usuario')
            ->first();

        $types = [
            'INDISCIPLINA EM SALA DE AULA',
            'DESRESPEITO',
            'AGRESSÃO FÍSICA OU VERBAL',
            'DANO AO PATRIMÔNIO PÚBLICO',
            'BULLYING OU PRÁTICA DISCRIMINATÓRIA',
            'USO INDEVIDO DE CELULAR',
            'EVASÃO DE SALA DE AULA (SAÍDA SEM AUTORIZAÇÃO)',
            'OUTRO(A)',
        ];

        foreach ($types as $type) {
            LegacyDisciplinaryOccurrenceType::updateOrCreate([
                'nm_tipo' => $type,
            ], [
                'ativo' => 1,
                'ref_usuario_cad' => $user?->getKey(),
                'ref_cod_instituicao' => 1,
            ]);
        }
    }
}
