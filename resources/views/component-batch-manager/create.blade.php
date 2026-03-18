@extends('layout.default')

@section('head')
    <meta name="csrf-token" content="{{ csrf_token() }}">
@endsection

@push('styles')
    <link rel="stylesheet" href="{{ Asset::get('css/ieducar.css') }}"/>
@endpush

@section('content')
    <form id="formcadastro" action="{{ route('component-batch-manager.preview') }}" method="post">
        @csrf

        <table class="tablecadastro" width="100%" border="0" cellpadding="2" cellspacing="0">
            <tbody>
            <tr>
                <td class="formdktd" colspan="2" height="24"><b>Nova Operação em Lote</b></td>
            </tr>

            <tr>
                <td class="formmdtd" valign="top">
                    <label for="ano" class="form">Ano <span class="campo_obrigatorio">*</span></label>
                    <br><sub>Somente números</sub>
                </td>
                <td class="formmdtd" valign="top">
                    <input type="text" class="geral obrigatorio" name="ano" id="ano" maxlength="4" value="{{ old('ano', date('Y')) }}" size="4">
                </td>
            </tr>

            <tr>
                <td class="formlttd" valign="top">
                    <label for="ref_cod_instituicao" class="form">Instituição <span class="campo_obrigatorio">*</span></label>
                </td>
                <td class="formlttd" valign="top">
                    @include('form.select-institution', ['obrigatorio' => true])
                </td>
            </tr>

            <tr>
                <td class="formmdtd" valign="top">
                    <label for="escola" class="form">Escolas <span class="campo_obrigatorio">*</span></label>
                </td>
                <td class="formmdtd" valign="top">
                    @include('form.select-school-multiple')
                    <a href="javascript:void(0)" id="link-select-all-schools" style="margin-left: 10px; color: #47728f; text-decoration: none;">
                        Selecionar todas
                    </a>
                </td>
            </tr>

            <tr>
                <td class="formlttd" valign="top">
                    <label for="cursos" class="form">Cursos <span class="campo_obrigatorio">*</span></label>
                </td>
                <td class="formlttd" valign="top">
                    <select name="curso[]" id="cursos" multiple style="width: 308px;">
                    </select>
                    <a href="javascript:void(0)" id="link-select-all-courses" style="margin-left: 10px; color: #47728f; text-decoration: none;">
                        Selecionar todos
                    </a>
                </td>
            </tr>

            <tr>
                <td class="formmdtd" valign="top">
                    <label for="ref_cod_serie" class="form">Séries <span class="campo_obrigatorio">*</span></label>
                </td>
                <td class="formmdtd" valign="top">
                    <select name="ref_cod_serie[]" id="ref_cod_serie" multiple="multiple" style="width: 308px;">
                    </select>
                    <a href="javascript:void(0)" id="link-select-all-grades" style="margin-left: 10px; color: #47728f; text-decoration: none;">
                        Selecionar todas
                    </a>
                </td>
            </tr>

            <tr>
                <td class="formlttd" valign="top">
                    <label for="discipline_ids" class="form">Componentes Curriculares <span class="campo_obrigatorio">*</span></label>
                </td>
                <td class="formlttd" valign="top">
                    <select name="discipline_ids[]" id="discipline_ids" multiple="multiple" style="width: 308px;">
                    </select>
                    <a href="javascript:void(0)" id="link-select-all-disciplines" style="margin-left: 10px; color: #47728f; text-decoration: none;">
                        Selecionar todos
                    </a>
                </td>
            </tr>

            <tr>
                <td class="formdktd" colspan="2" height="24"><b>Operações a executar</b></td>
            </tr>

            <tr>
                <td class="formmdtd" valign="top">
                    <span class="form">Remover lançamentos</span>
                </td>
                <td class="formmdtd" valign="top">
                    <input type="checkbox" name="remove_records" id="remove_records" value="1" {{ old('remove_records', '1') ? 'checked' : '' }} class="operation-checkbox">
                </td>
            </tr>

            <tr>
                <td class="formlttd" valign="top">
                    <span class="form">Remover dispensas</span>
                </td>
                <td class="formlttd" valign="top">
                    <input type="checkbox" name="remove_exemptions" id="remove_exemptions" value="1" {{ old('remove_exemptions') ? 'checked' : '' }} class="operation-checkbox">
                </td>
            </tr>

            <tr>
                <td class="formmdtd" valign="top">
                    <span class="form">Remover componentes da turma</span>
                </td>
                <td class="formmdtd" valign="top">
                    <input type="checkbox" name="unlink_class_components" id="unlink_class_components" value="1" {{ old('unlink_class_components', '1') ? 'checked' : '' }} class="operation-checkbox">
                </td>
            </tr>

            <tr>
                <td class="formlttd" valign="top">
                    <span class="form">Remover disciplinas do vínculo professor/turma</span>
                </td>
                <td class="formlttd" valign="top">
                    <input type="checkbox" name="unlink_teacher_disciplines" id="unlink_teacher_disciplines" value="1" {{ old('unlink_teacher_disciplines', '1') ? 'checked' : '' }} class="operation-checkbox">
                </td>
            </tr>

            <tr>
                <td class="formmdtd" valign="top">
                    <span class="form">Remover componentes da série da escola</span>
                </td>
                <td class="formmdtd" valign="top">
                    <input type="checkbox" name="unlink_school_grade_disciplines" id="unlink_school_grade_disciplines" value="1" {{ old('unlink_school_grade_disciplines', '1') ? 'checked' : '' }} class="operation-checkbox">
                </td>
            </tr>

            <tr>
                <td class="formlttd" valign="top">
                    <span class="form">Remover componentes da série</span>
                </td>
                <td class="formlttd" valign="top">
                    <input type="checkbox" name="unlink_grade_components" id="unlink_grade_components" value="1" {{ old('unlink_grade_components', '1') ? 'checked' : '' }} class="operation-checkbox">
                </td>
            </tr>

            </tbody>
        </table>

        <div style="text-align: center; margin-top: 10px; margin-bottom: 20px;">
            <a href="{{ route('component-batch-manager.index') }}" class="btn" style="margin-right: 10px; text-decoration: none;">Voltar</a>
            <button class="btn-green" type="submit">Continuar</button>
        </div>
    </form>
@endsection

@push('scripts')
    <script src="{{ Asset::get('/vendor/legacy/Portabilis/Assets/Javascripts/ClientApi.js') }}"></script>
    <script src="{{ Asset::get('/vendor/legacy/DynamicInput/Assets/Javascripts/DynamicInput.js') }}"></script>
    <script>
        (function($) {
        $(document).ready(function() {
            var oldCursos = @json(old('curso', []));
            var oldSeries = @json(old('ref_cod_serie', []));
            var oldDisciplinas = @json(old('discipline_ids', []));

            function restoreOld($select, oldValues) {
                if (oldValues.length === 0) return;
                var stringValues = oldValues.map(String);
                $select.val(stringValues);
                $select.trigger('chosen:updated');
            }

            multipleSearchHelper.setup('cursos', '', 'multiple', 'multiple', { placeholder: 'Selecione os cursos' });
            $j('#cursos').trigger('chosen:updated');

            multipleSearchHelper.setup('ref_cod_serie', '', 'multiple', 'multiple', { placeholder: 'Selecione as séries' });
            $j('#ref_cod_serie').trigger('chosen:updated');

            multipleSearchHelper.setup('discipline_ids', '', 'multiple', 'multiple', { placeholder: 'Selecione os componentes' });
            $j('#discipline_ids').trigger('chosen:updated');

            $j('#link-select-all-schools').on('click', function() {
                var $select = $j('#escola');
                $select.find('option').prop('selected', true);
                $select.trigger('chosen:updated');
                loadCourses();
            });

            $j('#link-select-all-courses').on('click', function() {
                var $select = $j('#cursos');
                $select.find('option').prop('selected', true);
                $select.trigger('chosen:updated');
                loadGrades();
            });

            $j('#link-select-all-grades').on('click', function() {
                var $select = $j('#ref_cod_serie');
                $select.find('option').prop('selected', true);
                $select.trigger('chosen:updated');
                loadDisciplines();
            });

            $j('#link-select-all-disciplines').on('click', function() {
                var $select = $j('#discipline_ids');
                $select.find('option').prop('selected', true);
                $select.trigger('chosen:updated');
            });

            // Cascata dinâmica: Escola → Curso → Série → Componentes
            var initialLoad = oldCursos.length > 0 || oldSeries.length > 0 || oldDisciplinas.length > 0;

            function loadCourses() {
                var schoolIds = $j('#escola').val();
                var year = $j('#ano').val();

                if (!schoolIds || schoolIds.length === 0) {
                    $j('#cursos').empty().trigger('chosen:updated');
                    loadGrades();
                    return;
                }

                $j.ajax({
                    url: '{{ route("component-batch-manager.api.courses") }}',
                    data: { school_ids: schoolIds, year: year },
                    dataType: 'json',
                    success: function(response) {
                        $j('#cursos').empty();
                        $j.each(response, function(id, name) {
                            $j('#cursos').append($j('<option>', { value: id, text: name }));
                        });
                        if (initialLoad) {
                            restoreOld($j('#cursos'), oldCursos);
                        }
                        $j('#cursos').trigger('chosen:updated');
                        loadGrades();
                    }
                });
            }

            function loadGrades() {
                var courseIds = $j('#cursos').val();

                if (!courseIds || courseIds.length === 0) {
                    $j('#ref_cod_serie').empty().trigger('chosen:updated');
                    loadDisciplines();
                    return;
                }

                var schoolIds = $j('#escola').val();
                var year = $j('#ano').val();

                $j.ajax({
                    url: '{{ route("component-batch-manager.api.grades") }}',
                    data: { school_ids: schoolIds, course_ids: courseIds, year: year },
                    dataType: 'json',
                    success: function(response) {
                        $j('#ref_cod_serie').empty();
                        $j.each(response, function(id, name) {
                            $j('#ref_cod_serie').append($j('<option>', { value: id, text: name }));
                        });
                        if (initialLoad) {
                            restoreOld($j('#ref_cod_serie'), oldSeries);
                        }
                        $j('#ref_cod_serie').trigger('chosen:updated');
                        loadDisciplines();
                    }
                });
            }

            function loadDisciplines() {
                var gradeIds = $j('#ref_cod_serie').val();

                if (!gradeIds || gradeIds.length === 0) {
                    $j('#discipline_ids').empty().trigger('chosen:updated');
                    return;
                }

                var schoolIds = $j('#escola').val();
                var year = $j('#ano').val();

                $j.ajax({
                    url: '{{ route("component-batch-manager.api.disciplines") }}',
                    data: { school_ids: schoolIds, grade_ids: gradeIds, year: year },
                    dataType: 'json',
                    success: function(response) {
                        $j('#discipline_ids').empty();
                        $j.each(response, function(id, name) {
                            $j('#discipline_ids').append($j('<option>', { value: id, text: name }));
                        });
                        if (initialLoad) {
                            restoreOld($j('#discipline_ids'), oldDisciplinas);
                            initialLoad = false;
                        }
                        $j('#discipline_ids').trigger('chosen:updated');
                    }
                });
            }

            $j('#escola').on('change', loadCourses);
            $j('#cursos').on('change', loadGrades);
            $j('#ref_cod_serie').on('change', loadDisciplines);
            $j('#ano').on('change blur', loadCourses);

            // Hierarquia de operações: desmarcar pai desmarca filhos, marcar filho marca pais
            var deps = {
                'remove_records': [],
                'remove_exemptions': [],
                'unlink_class_components': ['remove_records'],
                'unlink_teacher_disciplines': [],
                'unlink_school_grade_disciplines': ['unlink_class_components', 'remove_records'],
                'unlink_grade_components': ['unlink_school_grade_disciplines', 'unlink_class_components', 'remove_records']
            };

            var children = {
                'remove_records': ['unlink_class_components', 'unlink_school_grade_disciplines', 'unlink_grade_components'],
                'remove_exemptions': [],
                'unlink_class_components': ['unlink_school_grade_disciplines', 'unlink_grade_components'],
                'unlink_school_grade_disciplines': ['unlink_grade_components'],
                'unlink_teacher_disciplines': [],
                'unlink_grade_components': []
            };

            $j('.operation-checkbox').on('change', function() {
                var id = $j(this).attr('id');
                if ($j(this).is(':checked')) {
                    $j.each(deps[id] || [], function(_, dep) {
                        $j('#' + dep).prop('checked', true);
                    });
                } else {
                    $j.each(children[id] || [], function(_, child) {
                        $j('#' + child).prop('checked', false);
                    });
                }
            });

            $j('#formcadastro').on('submit', function(e) {
                if ($j('.operation-checkbox:checked').length === 0) {
                    e.preventDefault();
                    messageUtils.error('Selecione ao menos uma operação.');
                }
            });
        });
        })(jQuery);
    </script>
@endpush
