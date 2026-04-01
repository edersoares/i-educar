<?php

namespace Database\Seeders;

use App\Models\LegacyUser;
use App\Models\WithdrawalReason;
use Illuminate\Database\Seeder;

class DefaultPmieducarMotivoAfastamentoTableSeeder extends Seeder
{
    public function run()
    {
        $user = LegacyUser::query()
            ->orderBy('cod_usuario')
            ->first();

        $reasons = [
            'LICENÇA SAÚDE',
            'LICENÇA MATERNIDADE',
            'LICENÇA PATERNIDADE',
            'LICENÇA POR ACIDENTE DE TRABALHO',
            'LICENÇA PRÊMIO',
            'LICENÇA PARA ATIVIDADE POLÍTICA',
            'LICENÇA NÃO REMUNERADA',
        ];

        foreach ($reasons as $reason) {
            WithdrawalReason::updateOrCreate([
                'nm_motivo' => $reason,
            ], [
                'ativo' => 1,
                'ref_usuario_cad' => $user?->getKey(),
                'ref_cod_instituicao' => 1,
            ]);
        }
    }
}
