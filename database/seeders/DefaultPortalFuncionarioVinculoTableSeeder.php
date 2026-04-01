<?php

namespace Database\Seeders;

use App\Models\LegacyBondType;
use Illuminate\Database\Seeder;

class DefaultPortalFuncionarioVinculoTableSeeder extends Seeder
{
    public function run()
    {
        $types = [
            'COM' => 'COMISSIONADO',
            'CONT' => 'CONTRATADO',
            'EFET' => 'EFETIVO',
            'EST' => 'ESTAGIÁRIO',
        ];

        foreach ($types as $sg => $type) {
            LegacyBondType::updateOrCreate([
                'abreviatura' => $sg,
            ], [
                'nm_vinculo' => $type,
            ]);
        }
    }
}
