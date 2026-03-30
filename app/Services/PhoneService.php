<?php

namespace App\Services;

use App\Models\LegacyPhone;
use Illuminate\Support\Facades\Auth;

class PhoneService
{
    public function save(int $idpes, int $tipo, ?string $ddd, ?string $fone, ?int $userId = null): void
    {
        $ddd = onlyDigits($ddd);
        $fone = onlyDigits($fone);
        $userId = $userId ?? Auth::id();

        if (empty($ddd) && empty($fone)) {
            $this->delete($idpes, $tipo);

            return;
        }

        if (empty($ddd) || empty($fone)) {
            return;
        }

        $this->upsert($idpes, $tipo, $ddd, $fone, $userId);
    }

    public function delete(int $idpes, int $tipo): void
    {
        LegacyPhone::query()
            ->where('idpes', $idpes)
            ->where('tipo', $tipo)
            ->delete();
    }

    public function deleteAll(int $idpes): void
    {
        LegacyPhone::query()
            ->where('idpes', $idpes)
            ->delete();
    }

    private function upsert(int $idpes, int $tipo, string $ddd, string $fone, ?int $userId): void
    {
        $exists = LegacyPhone::query()
            ->where('idpes', $idpes)
            ->where('tipo', $tipo)
            ->exists();

        if ($exists) {
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
