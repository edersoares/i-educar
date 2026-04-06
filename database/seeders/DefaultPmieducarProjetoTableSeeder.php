<?php

namespace Database\Seeders;

use App\Models\LegacyProject;
use Illuminate\Database\Seeder;

class DefaultPmieducarProjetoTableSeeder extends Seeder
{
    public function run()
    {
        $projects = [
            'REFORÇO ESCOLAR',
            'ALFABETIZAÇÃO E LETRAMENTO',
            'PREPARATÓRIO (SAEB)',
            'FANFARRA',
            'TEATRO',
            'XADREZ',
            'ESCOLINHA DE ESPORTES',
            'DANÇA',
            'ARTES MARCIAIS',
        ];

        foreach ($projects as $project) {
            LegacyProject::updateOrCreate([
                'nome' => $project,
            ], [
                'observacao' => '',
            ]);
        }
    }
}
