@extends('layout.default')

@push('styles')
    <link rel="stylesheet" type="text/css" href="{{ Asset::get('css/ieducar.css') }}"/>
@endpush

@section('content')
    <table class="table-default">
        <thead>
        <tr>
            <th>Ano</th>
            <th>Status</th>
            <th>Tempo</th>
            <th>Usuário</th>
            <th>Data</th>
        </tr>
        </thead>
        <tbody>
        @forelse($operations as $operation)
            @php
                $status = $operation->status();
                $opData = $operation->data;
                $isStale = in_array($status, [
                    \App\Models\Enums\ComponentBatchStatus::WAITING,
                    \App\Models\Enums\ComponentBatchStatus::RUNNING,
                ]) && $operation->created_at < now()->subMinutes(20);
                $totalSecs = $opData['execution_time']['total'] ?? null;
                if ($totalSecs === null) {
                    $totalTime = null;
                } else {
                    $s = (int) $totalSecs;
                    if ($s < 1) $totalTime = '< 1s';
                    elseif ($s < 60) $totalTime = $s . 's';
                    elseif ($s < 3600) $totalTime = floor($s / 60) . 'm ' . ($s % 60) . 's';
                    else $totalTime = floor($s / 3600) . 'h ' . floor(($s % 3600) / 60) . 'm ' . ($s % 60) . 's';
                }
            @endphp
            <tr>
                <td><a href="{{ route('component-batch-manager.show', $operation) }}">{{ $opData['year'] ?? '-' }}</a></td>
                <td>
                    @if($isStale)
                        A operação não pôde ser concluída
                    @else
                        <span class="label label-{{ $status->color() }}">{{ $status->label() }}</span>
                    @endif
                </td>
                <td>{{ $totalTime ?? '-' }}</td>
                <td>{{ $operation->user?->name ?? 'Usuário #' . $operation->user_id }}</td>
                <td>{{ $operation->created_at->format('d/m/Y H:i') }}</td>
            </tr>
        @empty
            <tr>
                <td colspan="5">Nenhuma operação realizada</td>
            </tr>
        @endforelse
        </tbody>
    </table>

    <div class="separator"></div>

    <div style="text-align: center">
        {{ $operations->links() }}
    </div>

    <div style="text-align: center; margin-top: 30px; margin-bottom: 30px;">
        <a href="{{ route('component-batch-manager.create') }}" class="btn-green" style="text-decoration: none;">Nova Operação</a>
    </div>
@endsection
