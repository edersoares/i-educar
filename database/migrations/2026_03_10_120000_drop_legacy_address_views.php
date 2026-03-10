<?php

use App\Support\Database\AsView;
use Illuminate\Database\Migrations\Migration;

return new class extends Migration
{
    use AsView;

    public function up(): void
    {
        $this->dropView('cadastro.endereco_pessoa');
        $this->dropView('public.bairro');
        $this->dropView('public.distrito');
        $this->dropView('public.municipio');
        $this->dropView('public.pais');
        $this->dropView('public.uf');
    }

    public function down(): void
    {
        $this->createView('public.uf');
        $this->createView('public.pais');
        $this->createView('public.municipio');
        $this->createView('public.distrito');
        $this->createView('public.bairro');
        $this->createView('cadastro.endereco_pessoa');
    }
};
