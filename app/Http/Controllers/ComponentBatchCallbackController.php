<?php

namespace App\Http\Controllers;

use App\Models\ComponentBatchOperation;
use App\Models\Enums\ComponentBatchStatus;
use App\Models\NotificationType;
use App\Services\ComponentBatchManagerService;
use App\Services\NotificationService;
use Illuminate\Http\Request;

class ComponentBatchCallbackController extends Controller
{
    public function __invoke(Request $request, int $id)
    {
        $operation = ComponentBatchOperation::query()->findOrFail($id);

        if ($operation->status_id !== ComponentBatchStatus::RUNNING->value) {
            return response()->json([
                'message' => 'Operação não está em execução. Status atual: ' . ComponentBatchStatus::from($operation->status_id)->label(),
            ]);
        }

        $idiarioResult = $request->json()->all();
        $failed = false;

        try {
            app(ComponentBatchManagerService::class)->handleIdiarioCallback($operation, $idiarioResult);
        } catch (\Throwable $e) {
            app(ComponentBatchManagerService::class)->failed($operation, $e->getMessage());
            $failed = true;
        }

        $this->notifyUser($operation, $failed);

        return response()->json([
            'message' => 'Callback processado com sucesso.',
        ]);
    }

    private function notifyUser(ComponentBatchOperation $operation, bool $failed): void
    {
        $text = $failed
            ? 'Erro na remoção de componentes. Clique para ver detalhes.'
            : 'Remoção de componentes concluída com sucesso.';

        (new NotificationService)->createByUser(
            userId: $operation->user_id,
            text: $text,
            link: route('component-batch-manager.show', $operation),
            type: NotificationType::OTHER
        );
    }
}
