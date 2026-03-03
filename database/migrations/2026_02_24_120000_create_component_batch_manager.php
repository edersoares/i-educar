<?php

use App\Menu;
use App\Process;
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('component_batch_operations', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('user_id');
            $table->unsignedSmallInteger('status_id')->default(1);
            $table->jsonb('data');
            $table->text('error_message')->nullable();
            $table->timestamps();
            $table->index(['user_id', 'created_at']);
        });

        Menu::query()->updateOrCreate(['old' => Process::COMPONENT_BATCH_MANAGER], [
            'parent_id' => Menu::query()->where('old', Process::CONFIGURATIONS_TOOLS)->firstOrFail()->getKey(),
            'process' => Process::COMPONENT_BATCH_MANAGER,
            'title' => 'Gerenciamento em Lote de Componentes',
            'order' => 0,
            'parent_old' => Process::CONFIGURATIONS_TOOLS,
            'link' => '/gerenciamento-componentes',
        ]);
    }

    public function down(): void
    {
        Schema::dropIfExists('component_batch_operations');
        Menu::query()->where('old', Process::COMPONENT_BATCH_MANAGER)->delete();
    }
};
