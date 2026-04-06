<?php

namespace Database\Seeders;

use App\Models\DeficiencyType;
use App\Models\LegacyDeficiency;
use iEducar\Modules\Educacenso\Model\Deficiencias;
use iEducar\Modules\Educacenso\Model\Transtornos;
use Illuminate\Database\Seeder;
use Illuminate\Support\Str;

class DefaultCadastroDeficienciaTableSeeder extends Seeder
{
    public function run()
    {
        $deficiencies = [
            Deficiencias::CEGUEIRA => 'CEGUEIRA',
            Deficiencias::ALTAS_HABILIDADES_SUPERDOTACAO => 'ALTAS HABILIDADES / SUPERDOTAÇÃO',
            Deficiencias::TRANSTORNO_ESPECTRO_AUTISTA => 'TRANSTORNO DO ESPECTRO AUTISTA',
            Deficiencias::BAIXA_VISAO => 'BAIXA VISÃO',
            Deficiencias::DEFICIENCIA_AUDITIVA => 'DEFICIÊNCIA AUDITIVA',
            Deficiencias::DEFICIENCIA_FISICA => 'DEFICIÊNCIA FÍSICA',
            Deficiencias::DEFICIENCIA_INTELECTUAL => 'DEFICIÊNCIA INTELECTUAL',
            Deficiencias::SURDEZ => 'SURDEZ',
            Deficiencias::SURDOCEGUEIRA => 'SURDOCEGUEIRA',
            Deficiencias::VISAO_MONOCULAR => 'DEFICIÊNCIA VISUAL',
            Deficiencias::OUTRAS => 'OUTRAS',
        ];

        foreach ($deficiencies as $id => $name) {
            LegacyDeficiency::updateOrCreate([
                'deficiencia_educacenso' => $id,
            ], [
                'nm_deficiencia' => Str::upper($name),
                'deficiency_type_id' => DeficiencyType::DEFICIENCY,
            ]);
        }

        $disorders = [
            Transtornos::DISCALCULIA => 'DISCALCULIA',
            Transtornos::DISGRAFIA => 'DISGRAFIA / DISORTOGRAFIA',
            Transtornos::DISLALIA => 'DISLALIA',
            Transtornos::DISLEXIA => 'DISLEXIA',
            Transtornos::TDAH => 'TDAH',
            Transtornos::TPAC => 'TPAC',
            Transtornos::OUTROS => 'OUTROS',
        ];

        foreach ($disorders as $id => $name) {
            LegacyDeficiency::updateOrCreate([
                'transtorno_educacenso' => $id,
            ], [
                'nm_deficiencia' => Str::upper($name),
                'deficiency_type_id' => DeficiencyType::DISORDER,
            ]);
        }
    }
}
