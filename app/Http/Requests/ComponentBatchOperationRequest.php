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

        $this->enforceCheckboxHierarchy();
    }

    public function rules(): array
    {
        return [
            'year' => ['required', 'integer', 'min:2000'],
            'institution_id' => ['required', 'integer'],
            'course_ids' => ['required', 'array'],
            'course_ids.*' => ['integer'],
            'grade_ids' => ['required', 'array'],
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
            $hasOperation = $this->input('remove_records')
                || $this->input('unlink_class_components')
                || $this->input('unlink_teacher_disciplines')
                || $this->input('unlink_school_grade_disciplines')
                || $this->input('unlink_grade_components')
                || $this->input('remove_exemptions');

            if (!$hasOperation) {
                $validator->errors()->add('operations', 'Selecione ao menos uma operação.');
            }
        });
    }

    private function enforceCheckboxHierarchy(): void
    {
        // Propagar para cima: operação filha implica pais
        // (ex: desvinc. componentes da série → força desvinc. escola/série → força desvinc. turma → força remover lançamentos)
        if ($this->input('unlink_grade_components')) {
            $this->merge(['unlink_school_grade_disciplines' => true]);
        }
        if ($this->input('unlink_school_grade_disciplines')) {
            $this->merge(['unlink_class_components' => true]);
        }
        if ($this->input('unlink_class_components') || $this->input('unlink_teacher_disciplines')) {
            $this->merge(['remove_records' => true]);
        }

        // Propagar para baixo: pai desmarcado desativa filhos
        if (!$this->input('remove_records')) {
            $this->merge([
                'unlink_class_components' => false,
                'unlink_teacher_disciplines' => false,
            ]);
        }
        if (!$this->input('unlink_class_components')) {
            $this->merge(['unlink_school_grade_disciplines' => false]);
        }
        if (!$this->input('unlink_school_grade_disciplines')) {
            $this->merge(['unlink_grade_components' => false]);
        }
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
