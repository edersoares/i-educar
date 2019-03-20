<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class BatchEnrollmentRequest extends FormRequest
{
    /**
     * Get the validation rules that apply to the request.
     *
     * @return array
     */
    public function rules()
    {
        return [
            'date' => [
                'required',
                'date_format:d/m/Y',
            ],
            'registrations' => [
                'required',
                'max:' . $this->schoolClass->vacancies
            ]
        ];
    }

    /**
     * @return array
     */
    public function messages()
    {
        return [
            'date.required' => 'A data de enturmação é obrigatória.',
            'date.date_format' => 'A data de enturmação deve ser uma data válida.',
            'registrations.required' => 'Ao menos uma matrícula deve ser selecionada.',
            'registrations.max' => 'Há somente :max vagas na turma, você tentou enturmar ' . count($this->registrations ?? []) . ' alunos.',
        ];
    }
}
