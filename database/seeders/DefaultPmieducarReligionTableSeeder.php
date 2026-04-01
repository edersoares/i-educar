<?php

namespace Database\Seeders;

use App\Models\Religion;
use Illuminate\Database\Seeder;

class DefaultPmieducarReligionTableSeeder extends Seeder
{
    public function run()
    {
        $religions = [
            'ADVENTISTA',
            'ATEÍSMO',
            'BUDISTA',
            'CANDOMBLÉ',
            'CATÓLICA',
            'ESPÍRITA',
            'EVANGÉLICA',
            'HINDUÍSTA',
            'JUDAICA',
            'MESSIÂNICA',
            'MORMON',
            'MUÇULMANO',
            'NENHUMA',
            'OUTRAS(OS)',
            'SEICHO-NO-IE',
            'TESTEMUNHA DE JEOVÁ',
            'TRADIÇÕES INDÍGENAS',
            'UMBANDA',
        ];

        foreach ($religions as $religion) {
            Religion::updateOrCreate([
                'name' => $religion,
            ]);
        }
    }
}
