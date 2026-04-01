<?php

namespace Database\Seeders;

use App\Models\LegacyBenefit;
use App\Models\LegacyUser;
use Illuminate\Database\Seeder;

class DefaultPmieducarAlunoBeneficioTableSeeder extends Seeder
{
    public function run()
    {
        $user = LegacyUser::query()
            ->orderBy('cod_usuario')
            ->first();

        $benefits = [
            'BOLSA FAMÍLIA',
            'AUXÍLIO MUNICIPAL',
            'BOLSA ESTUDANTIL',
            'PASSE/ VALE TRANSPORTE',
            'AUXÍLIO UNIFORME ESCOLAR',
            'AUXÍLIO MATERIAL ESCOLAR',
            'OUTRO(A)',
        ];

        foreach ($benefits as $benefit) {
            LegacyBenefit::updateOrCreate([
                'nm_beneficio' => $benefit,
                'ref_usuario_cad' => $user?->getKey(),
            ]);
        }
    }
}
