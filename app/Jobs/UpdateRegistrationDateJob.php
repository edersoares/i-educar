<?php

namespace App\Jobs;

use App\Jobs\Concerns\ShouldNotificate;
use App\Models\LegacyRegistration;
use App\Services\RegistrationService;
use App\User;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
use Illuminate\Support\Facades\DB;
use Throwable;

class UpdateRegistrationDateJob implements ShouldQueue
{
    use Dispatchable;
    use InteractsWithQueue;
    use Queueable;
    use SerializesModels;
    use ShouldNotificate;

    private array $registrationIds;

    private string $newDateRegistration;

    private ?string $newDateEnrollment;

    private bool $ignoreRelocation;

    private string $databaseConnection;

    private User $user;

    public int $timeout = 600;

    public function __construct(
        array $registrationIds,
        string $newDateRegistration,
        ?string $newDateEnrollment,
        bool $ignoreRelocation,
        string $databaseConnection,
        User $user
    ) {
        $this->registrationIds = $registrationIds;
        $this->newDateRegistration = $newDateRegistration;
        $this->newDateEnrollment = $newDateEnrollment;
        $this->ignoreRelocation = $ignoreRelocation;
        $this->databaseConnection = $databaseConnection;
        $this->user = $user;
    }

    /**
     * @return void
     *
     * @throws Throwable
     */
    public function handle()
    {
        DB::setDefaultConnection($this->databaseConnection);
        DB::beginTransaction();

        try {
            $registrations = LegacyRegistration::whereIn('cod_matricula', $this->registrationIds)->get();
            $registrationService = new RegistrationService($this->user);

            $newDateRegistration = \DateTime::createFromFormat('Y-m-d', $this->newDateRegistration);
            $newDateEnrollment = $this->newDateEnrollment
                ? \DateTime::createFromFormat('Y-m-d', $this->newDateEnrollment)
                : null;

            foreach ($registrations as $registration) {
                $registrationService->updateRegistrationDate($registration, $newDateRegistration);

                if ($newDateEnrollment) {
                    $registrationService->updateEnrollmentsDate($registration, $newDateEnrollment, $this->ignoreRelocation);
                }
            }
        } catch (Throwable $exception) {
            DB::rollBack();

            $this->notificateError();

            throw $exception;
        }

        $this->notificateSuccess();
        DB::commit();
    }

    public function tags()
    {
        return [
            $this->databaseConnection,
            'update-registration-date',
        ];
    }

    public function getSuccessMessage()
    {
        return 'Atualização de datas de matrícula concluída. ' . count($this->registrationIds) . ' matrículas atualizadas.';
    }

    public function getErrorMessage()
    {
        return 'Erro ao atualizar datas de matrícula em lote.';
    }

    public function getNotificationUrl()
    {
        return '/atualiza-data-entrada';
    }

    public function getUser()
    {
        return $this->user;
    }
}
