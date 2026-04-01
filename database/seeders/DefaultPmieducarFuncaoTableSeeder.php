<?php

namespace Database\Seeders;

use App\Models\LegacyRole;
use App\Models\LegacyUser;
use Illuminate\Database\Seeder;

class DefaultPmieducarFuncaoTableSeeder extends Seeder
{
    public function run()
    {
        $user = LegacyUser::query()
            ->orderBy('cod_usuario')
            ->first();

        $roles = [
            'CP' => 'COORDENADOR(A) PEDAGÓGICO',
            'DIR' => 'DIRETOR(A) ESCOLAR',
            'SEC' => 'SECRETÁRIO(A) ESCOLAR',
            'SERV' => 'SERVENTE ESCOLAR',
            'ZEL' => 'ZELADOR(A)',
            'OE' => 'ORIENTADOR(A) EDUCACIONAL',
            'AUX' => 'AUXILIAR ADMINISTRATIVO',
            'BIB' => 'BIBLIOTECÁRIO(A)',
            'TEC-INF' => 'TÉCNICO DE INFORMÁTICA / MONITOR DE LABORATÓRIO',
            'ASG' => 'AUXILIAR DE SERVIÇOS GERAIS',
        ];

        foreach ($roles as $sg => $role) {
            LegacyRole::updateOrCreate([
                'abreviatura' => $sg,
            ], [
                'nm_funcao' => $role,
                'professor' => 0,
                'ativo' => 1,
                'ref_usuario_cad' => $user?->getKey(),
                'ref_cod_instituicao' => 1,
            ]);
        }

        $teachers = [
            'PROF' => 'PROFESSOR(A)',
            'PROF-AEE' => 'PROFESSOR(A) DE AEE',
        ];

        foreach ($teachers as $sg => $teacher) {
            LegacyRole::updateOrCreate([
                'abreviatura' => $sg,
            ], [
                'nm_funcao' => $role,
                'professor' => 1,
                'ativo' => 1,
                'ref_usuario_cad' => $user?->getKey(),
                'ref_cod_instituicao' => 1,
            ]);
        }
    }
}
