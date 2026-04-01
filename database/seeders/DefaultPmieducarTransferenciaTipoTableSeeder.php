<?php

namespace Database\Seeders;

use App\Models\LegacyTransferType;
use App\Models\LegacyUser;
use Illuminate\Database\Seeder;

class DefaultPmieducarTransferenciaTipoTableSeeder extends Seeder
{
    public function run()
    {
        $user = LegacyUser::query()
            ->orderBy('cod_usuario')
            ->first();

        $types = [
            'MUDANÇA DE ENDEREÇO',
            'INTERESSE DA FAMÍLIA',
            'ADAPTAÇÃO ESCOLAR',
            'TRANSPORTE ESCOLAR',
            'DECISÃO JUDICIAL / CONSELHO TUTELAR',
            'OCORRÊNCIA DISCIPLINAR GRAVE',
            'OUTRO(A)',
        ];

        foreach ($types as $type) {
            LegacyTransferType::updateOrCreate([
                'nm_tipo' => $type,
            ], [
                'ativo' => 1,
                'ref_usuario_cad' => $user?->getKey(),
                'ref_cod_instituicao' => 1,
            ]);
        }
    }
}
