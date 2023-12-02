<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Http\Exceptions\HttpResponseException;
use Illuminate\Contracts\Validation\Validator;
use Symfony\Component\HttpFoundation\Response;

class LoginUserRequest extends FormRequest
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
            'username' => ['required','string','regex:/^[A-Za-z_]+$/'],
            'password' => ['required','min:8', 'confirmed']
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
            'message' => "Something went wrong! Please try again",
            'data' => $validator->getMessageBag()
        ], Response::HTTP_UNAUTHORIZED));
    }
}
