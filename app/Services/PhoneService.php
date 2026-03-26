<?php

namespace App\Services;

use App\Models\LegacyPhone;
use Illuminate\Support\Facades\Auth;

class PhoneService
{
    public function salvar(int $idpes, int $tipo, ?string $ddd, ?string $fone, ?int $userId = null): void
    {
        $ddd = apenasDigitos($ddd);
        $fone = apenasDigitos($fone);
        $userId = $userId ?? Auth::id();

        if (empty($ddd) && empty($fone)) {
            $this->deletar($idpes, $tipo);

            return;
        }

        if (empty($ddd) || empty($fone)) {
            return;
        }

        $this->upsert($idpes, $tipo, $ddd, $fone, $userId);
    }

    public function deletar(int $idpes, int $tipo): void
    {
        LegacyPhone::query()
            ->where('idpes', $idpes)
            ->where('tipo', $tipo)
            ->delete();
    }

    public function deletarTodos(int $idpes): void
    {
        LegacyPhone::query()
            ->where('idpes', $idpes)
            ->delete();
    }

    private function upsert(int $idpes, int $tipo, string $ddd, string $fone, ?int $userId): void
    {
        $existe = LegacyPhone::query()
            ->where('idpes', $idpes)
            ->where('tipo', $tipo)
            ->exists();

        if ($existe) {
            LegacyPhone::query()
                ->where('idpes', $idpes)
                ->where('tipo', $tipo)
                ->update([
                    'ddd' => $ddd,
                    'fone' => $fone,
                    'idpes_rev' => $userId,
                ]);
        } else {
            LegacyPhone::create([
                'idpes' => $idpes,
                'tipo' => $tipo,
                'ddd' => $ddd,
                'fone' => $fone,
                'idpes_cad' => $userId,
            ]);
        }
    }
}
