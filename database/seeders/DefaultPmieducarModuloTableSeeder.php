<?php

namespace Database\Seeders;

use App\Models\LegacyStageType;
use App\Models\LegacyUser;
use Illuminate\Database\Seeder;

class DefaultPmieducarModuloTableSeeder extends Seeder
{
    public function run()
    {
        $user = LegacyUser::query()
            ->orderBy('cod_usuario')
            ->first();

        $modules = [
            1 => 'ANO',
            2 => 'SEMESTRE',
            3 => 'TRIMESTRE',
            4 => 'BIMESTRE',
        ];

        foreach ($modules as $stage => $name) {
            LegacyStageType::updateOrCreate([
                'num_etapas' => $stage,
                'nm_tipo' => $name,
            ], [
                'ativo' => 1,
                'ref_usuario_cad' => $user?->getKey(),
                'ref_cod_instituicao' => 1,
            ]);
        }
    }
}
