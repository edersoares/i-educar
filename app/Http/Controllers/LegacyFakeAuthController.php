<?php

namespace App\Http\Controllers;

class LegacyFakeAuthController
{
    /**
     * Do a fake login when running functional tests.
     *
     * @return void
     */
    public function doFakeLogin()
    {
        session([
            'itj_controle' => 'logado',
            'id_pessoa' => '1',
            'pessoa_setor' => null,
            'menu_opt' => false,
            'tipo_menu' => '1',
            'nivel' => '1',
        ]);
    }

    /**
     * Do a fake logout when running functional tests.
     *
     * @return void
     */
    public function doFakeLogout()
    {
        return; // TODO remover
    }
}
