<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Http\Exceptions\HttpResponseException;
use Illuminate\Contracts\Validation\Validator;
use Symfony\Component\HttpFoundation\Response;

class CreateUserRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        return [
            'username' => ['required','string','regex:/^[A-Za-z_]+$/','unique:users,username'],
            'first_name' => ['required','max:255'],
            'last_name' => ['required','max:255'],
            'email' => ['required','max:255', 'unique:users,email','email:filter'],
            'password' => ['required','min:8'],
            'phone' => ['sometimes', 'unique:users,phone','digits_between:10,20'], // sometimes means if that field is present then required
            'gender' => ['required','in:male,female,others'],
            'dob' => ['required','max:255']
        ];
    }

    public function messages(): array
    {
        return [
            'username.regex' => 'Username should contain only letters and underscore'
        ];
    }

    public function failedValidation(Validator $validator) : Response {
        throw new HttpResponseException(response()->json([
            'success' => false,
            'message' => $validator->getMessageBag()
        ], Response::HTTP_BAD_REQUEST));
    }
}
