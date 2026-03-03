@extends('layout.default')

@push('styles')
    <link rel="stylesheet" type="text/css" href="{{ Asset::get('css/ieducar.css') }}"/>
@endpush

@section('content')
    @php $data = $operation->data; @endphp

    <form id="formcadastro">
    <table class="tablecadastro" width="100%" border="0" cellpadding="2" cellspacing="0" role="presentation">
        <tbody>
        <tr>
            <td class="formdktd" colspan="2" height="24"><b>Resultado da Operação</b></td>
        </tr>

        <tr>
            <td class="formmdtd" valign="top" style="width: 200px;"><span class="form">Status</span></td>
            <td class="formmdtd" valign="top">
                <span class="label label-{{ $status->color() }}">{{ $status->label() }}</span>
            </td>
        </tr>
        <tr>
            <td class="formlttd" valign="top"><span class="form">Executado por</span></td>
            <td class="formlttd" valign="top">{{ $operation->user?->name ?? 'Usuário #' . $operation->user_id }}</td>
        </tr>
        <tr>
            <td class="formmdtd" valign="top"><span class="form">Data</span></td>
            <td class="formmdtd" valign="top">{{ $operation->created_at->format('d/m/Y H:i') }}</td>
        </tr>
        @if(isset($data['execution_time']))
            @php
                $formatTime = function ($s) {
                    $s = (int) $s;
                    if ($s < 1) return '< 1s';
                    if ($s < 60) return $s . 's';
                    if ($s < 3600) return floor($s / 60) . 'm ' . ($s % 60) . 's';
                    return floor($s / 3600) . 'h ' . floor(($s % 3600) / 60) . 'm ' . ($s % 60) . 's';
                };
                $time = $data['execution_time'];
                $parts = [];
                $parts[] = isset($time['idiario']) ? "i-Diário: " . $formatTime($time['idiario']) : "i-Diário: não executado";
                if (isset($time['ieducar'])) $parts[] = "i-Educar: " . $formatTime($time['ieducar']);
                if (isset($time['verificacao'])) $parts[] = "Verificação: " . $formatTime($time['verificacao']);
                $timeLabel = $formatTime($time['total'] ?? 0) . (count($parts) > 0 ? ' (' . implode(', ', $parts) . ')' : '');
            @endphp
            <tr>
                <td class="formlttd" valign="top"><span class="form">Tempo de execução</span></td>
                <td class="formlttd" valign="top">{{ $timeLabel }}</td>
            </tr>
        @endif
        <tr>
            <td class="{{ isset($data['execution_time']) ? 'formmdtd' : 'formlttd' }}" valign="top"><span class="form">Ano</span></td>
            <td class="{{ isset($data['execution_time']) ? 'formmdtd' : 'formlttd' }}" valign="top">{{ $data['year'] }}</td>
        </tr>
        <tr>
            <td class="formmdtd" valign="top"><span class="form">Cursos</span></td>
            <td class="formmdtd" valign="top">
                @if(empty($courseNames))
                    <em>Todos</em>
                @else
                    {{ implode(', ', $courseNames) }}
                @endif
            </td>
        </tr>
        <tr>
            <td class="formlttd" valign="top"><span class="form">Séries</span></td>
            <td class="formlttd" valign="top">{{ implode(', ', $gradeNames) }}</td>
        </tr>
        <tr>
            <td class="formmdtd" valign="top"><span class="form">Escolas</span></td>
            <td class="formmdtd" valign="top">
                @if(empty($schoolNames))
                    <em>Todas</em>
                @else
                    {{ implode(', ', $schoolNames) }}
                @endif
            </td>
        </tr>
        <tr>
            <td class="formlttd" valign="top"><span class="form">Componentes</span></td>
            <td class="formlttd" valign="top">{{ implode(', ', $disciplineNames) }}</td>
        </tr>

        <tr>
            <td class="formdktd" colspan="2" height="24"><b>Operações executadas</b></td>
        </tr>
        <tr>
            <td class="formmdtd" colspan="2">
                <ul style="margin: 5px 0; padding-left: 20px;">
                    @if($data['remove_records'] ?? false)
                        <li>Remover lançamentos</li>
                    @endif
                    @if($data['remove_exemptions'] ?? false)
                        <li>Remover dispensas</li>
                    @endif
                    @if($data['unlink_class_components'] ?? false)
                        <li>Remover componentes da turma</li>
                    @endif
                    @if($data['unlink_teacher_disciplines'] ?? false)
                        <li>Remover vínculos professor/turma e professor/disciplina</li>
                    @endif
                    @if($data['unlink_school_grade_disciplines'] ?? false)
                        <li>Remover componentes da série da escola</li>
                    @endif
                    @if($data['unlink_grade_components'] ?? false)
                        <li>Remover componentes da série</li>
                    @endif
                </ul>
            </td>
        </tr>

        @if(!empty($previewCounts))
            <tr>
                <td class="formdktd" colspan="2" height="24"><b>Registros encontrados</b></td>
            </tr>
        @endif

        </tbody>
    </table>
    </form>

    @if(!empty($previewCounts))
        @if(($data['remove_records'] ?? false) && isset($previewCounts['idiario']))
            @include('component-batch-manager.idiario-table', [
                'idiarioData' => $previewCounts['idiario'],
                'idiarioErrorMessage' => 'Não foi possível consultar o i-Diário.',
            ])
        @endif

        @include('component-batch-manager.ieducar-table', [
            'counts' => $previewCounts,
            'data' => $data,
            'totalIeducar' => $totalIeducar,
            'title' => 'Registros encontrados no i-Educar',
        ])
    @endif

    <form id="formcadastro">
    <table class="tablecadastro" width="100%" border="0" cellpadding="2" cellspacing="0" role="presentation">
        <tbody>

        @if($status === \App\Models\Enums\ComponentBatchStatus::WAITING || $status === \App\Models\Enums\ComponentBatchStatus::RUNNING)
            @php $isStale = $operation->created_at < now()->subMinutes(20); @endphp
            <tr>
                <td class="formmdtd" colspan="2">
                    @if($isStale)
                        <div style="background-color: #f8d7da; border: 1px solid #f5c6cb; color: #721c24; padding: 15px; border-radius: 4px; text-align: center;">
                            <strong>A operação não pôde ser concluída.</strong>
                            <p style="margin: 5px 0 0 0;">O tempo limite foi excedido. Verifique se o worker está ativo e tente novamente.</p>
                        </div>
                    @else
                        <div style="background-color: #d9edf7; border: 1px solid #bce8f1; color: #31708f; padding: 15px; border-radius: 4px; text-align: center;">
                            <strong>Processamento em andamento...</strong>
                            <p style="margin: 5px 0 0 0;">Você receberá uma notificação quando o processo for concluído.</p>
                            <p style="margin: 5px 0 0 0;">Você pode acompanhar o status na <a href="{{ route('component-batch-manager.index') }}">listagem de operações</a>.</p>
                        </div>
                    @endif
                </td>
            </tr>
        @endif

        @if($status === \App\Models\Enums\ComponentBatchStatus::FAILED)
            <tr>
                <td class="formdktd" colspan="2" height="24"><b>Erro</b></td>
            </tr>
            <tr>
                <td class="formmdtd" colspan="2">
                    <div style="background-color: #f8d7da; border: 1px solid #f5c6cb; color: #721c24; padding: 15px; border-radius: 4px;">
                        <strong>A operação falhou.</strong>
                        @if($operation->error_message)
                            <p style="margin: 10px 0 0 0;">{{ $operation->error_message }}</p>
                        @endif
                    </div>
                </td>
            </tr>
        @endif

        </tbody>
    </table>
    </form>

    @if($showVerification)
        @if($status === \App\Models\Enums\ComponentBatchStatus::COMPLETED && !empty($verificationWarnings))
            <div style="background-color: #fcf8e3; border: 1px solid #faebcc; color: #8a6d3b; padding: 10px; border-radius: 4px; margin-bottom: 10px;">
                <strong>Observações:</strong>
                <ul style="margin: 5px 0 0 0; padding-left: 20px;">
                    @foreach($verificationWarnings as $warning)
                        <li>{{ $warning }}</li>
                    @endforeach
                </ul>
            </div>
        @endif

        @if($postIdiario && ($data['remove_records'] ?? false))
            @include('component-batch-manager.idiario-table', [
                'idiarioData' => $postIdiario,
                'idiarioErrorMessage' => 'Não foi possível verificar o i-Diário após a execução.',
            ])
        @endif

        @if($postCounts)
            @include('component-batch-manager.ieducar-table', [
                'counts' => $postCounts,
                'data' => $data,
                'totalIeducar' => $totalPostIeducar,
                'title' => 'Registros remanescentes no i-Educar',
                'emptyMessage' => 'Nenhum registro remanescente.',
            ])
        @endif
    @endif

    @if(session('warning'))
        <div style="background-color: #fcf8e3; border: 1px solid #faebcc; color: #8a6d3b; padding: 10px; margin: 10px 0; border-radius: 4px; text-align: center;">
            {{ session('warning') }}
        </div>
    @endif

    <div style="text-align: center; margin-top: 20px; margin-bottom: 20px;">
        <a href="{{ route('component-batch-manager.index') }}" class="btn" style="margin-right: 10px; text-decoration: none;">Voltar</a>
        <a href="{{ route('component-batch-manager.create') }}" class="btn-green" style="text-decoration: none;">Nova Operação</a>
    </div>
@endsection
