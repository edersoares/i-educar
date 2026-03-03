<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Support\Arr;
use Illuminate\Validation\Validator;

class ComponentBatchOperationRequest extends FormRequest
{
    protected function prepareForValidation(): void
    {
        $this->merge([
            'year' => $this->input('ano'),
            'institution_id' => $this->input('ref_cod_instituicao'),
            'course_ids' => $this->inputToIntArray('curso'),
            'grade_ids' => $this->inputToIntArray('ref_cod_serie'),
            'school_ids' => $this->inputToIntArray('escola'),
            'discipline_ids' => $this->inputToIntArray('discipline_ids'),
            'remove_records' => $this->has('remove_records'),
            'unlink_class_components' => $this->has('unlink_class_components'),
            'unlink_teacher_disciplines' => $this->has('unlink_teacher_disciplines'),
            'unlink_school_grade_disciplines' => $this->has('unlink_school_grade_disciplines'),
            'unlink_grade_components' => $this->has('unlink_grade_components'),
            'remove_exemptions' => $this->has('remove_exemptions'),
        ]);
    }

    public function rules(): array
    {
        return [
            'year' => ['required', 'integer', 'min:2000'],
            'institution_id' => ['required', 'integer'],
            'course_ids' => ['required', 'array'],
            'course_ids.*' => ['integer'],
            'grade_ids' => ['nullable', 'array'],
            'grade_ids.*' => ['integer'],
            'school_ids' => ['required', 'array'],
            'school_ids.*' => ['integer'],
            'discipline_ids' => ['required', 'array'],
            'discipline_ids.*' => ['integer'],
            'remove_records' => ['nullable', 'boolean'],
            'unlink_class_components' => ['nullable', 'boolean'],
            'unlink_teacher_disciplines' => ['nullable', 'boolean'],
            'unlink_school_grade_disciplines' => ['nullable', 'boolean'],
            'unlink_grade_components' => ['nullable', 'boolean'],
            'remove_exemptions' => ['nullable', 'boolean'],
        ];
    }

    public function withValidator(Validator $validator): void
    {
        $validator->after(function (Validator $validator) {
            // Ao menos uma operação deve ser marcada
            $hasPhase = $this->input('remove_records')
                || $this->input('unlink_class_components')
                || $this->input('unlink_teacher_disciplines')
                || $this->input('unlink_school_grade_disciplines')
                || $this->input('unlink_grade_components')
                || $this->input('remove_exemptions');

            if (!$hasPhase) {
                $validator->errors()->add('operations', 'Selecione ao menos uma operação.');
            }

            // Hierarquia: remove_records ← unlink_class_components ← unlink_school_grade_disciplines ← unlink_grade_components
            //            remove_records ← unlink_teacher_disciplines
            $removeRecords = $this->input('remove_records');
            $unlinkClass = $this->input('unlink_class_components');

            $needsRecords = [];
            if ($unlinkClass && !$removeRecords) {
                $needsRecords[] = 'Remover componentes da turma';
            }
            if ($this->input('unlink_teacher_disciplines') && !$removeRecords) {
                $needsRecords[] = 'Remover vínculos professor/turma e professor/disciplina';
            }
            if ($this->input('unlink_school_grade_disciplines') && !$removeRecords) {
                $needsRecords[] = 'Remover componentes da série da escola';
            }
            if ($this->input('unlink_grade_components') && !$removeRecords) {
                $needsRecords[] = 'Remover componentes da série';
            }
            if (!empty($needsRecords)) {
                $validator->errors()->add('remove_records', 'Para executar "' . implode('", "', $needsRecords) . '" é necessário marcar "Remover lançamentos".');
            }

            if ($this->input('unlink_school_grade_disciplines') && !$unlinkClass) {
                $validator->errors()->add('unlink_class_components', '"Remover componentes da série da escola" exige "Remover componentes da turma".');
            }
            if ($this->input('unlink_grade_components') && !$this->input('unlink_school_grade_disciplines')) {
                $validator->errors()->add('unlink_school_grade_disciplines', '"Remover componentes da série" exige "Remover componentes da série da escola".');
            }
        });
    }

    private function inputToIntArray(string $field): array
    {
        return array_map('intval', array_filter(Arr::flatten((array) $this->input($field, []))));
    }

    public function attributes(): array
    {
        return [
            'year' => 'ano',
            'institution_id' => 'instituição',
            'school_ids' => 'escolas',
            'course_ids' => 'cursos',
            'grade_ids' => 'séries',
            'discipline_ids' => 'componentes curriculares',
        ];
    }
}
