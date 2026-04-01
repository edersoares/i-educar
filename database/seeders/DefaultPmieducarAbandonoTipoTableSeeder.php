<?php

namespace Database\Seeders;

use App\Models\LegacyAbandonmentType;
use Illuminate\Database\Seeder;

class DefaultPmieducarAbandonoTipoTableSeeder extends Seeder
{
    public function run()
    {
        $types = [
            'EVASÃO ESCOLAR',
            'VULNERABILIDADE SOCIAL EXTREMA',
            'VIOLÊNCIA NO TRAJETO OU NA ESCOLA',
            'CONFLITO FAMILIAR',
            'GRAVIDEZ NA ADOLESCÊNCIA',
            'MUDANÇA DE RESIDÊNCIA SEM COMUNICAÇÃO PRÉVIA',
            'INSERÇÃO NO MERCADO DE TRABALHO',
            'DOENÇA / TRATAMENTO DE SAÚDE',
            'OUTRO(A)',
        ];

        foreach ($types as $type) {
            LegacyAbandonmentType::updateOrCreate([
                'nome' => $type,
            ], [
                'ref_cod_instituicao' => 1,
                'ativo' => 1,
            ]);
        }
    }
}
