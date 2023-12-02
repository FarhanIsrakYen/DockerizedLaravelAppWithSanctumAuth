<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Http\Requests\CreateUserRequest;
use App\Models\User;
use Hash;
use Symfony\Component\HttpFoundation\Response;

class RegisterController extends Controller
{
    private const ROLE_USER = "ROLE_USER";
    private const STATUS_ONLINE = "online";
    public function register(CreateUserRequest $request){
        $user = User::create([
            'username' => $request->username,
            'first_name' => $request->first_name,
            'last_name' => $request->last_name,
            'email' => $request->email,
            'password'=> Hash::make($request->password),
            'phone' => $request->phone,
            'gender' => $request->gender,
            'dob' => $request->dob,
            'role' => self::ROLE_USER,
            'status' => self::STATUS_ONLINE,
            'is_active' => true
        ]);
        $success['token'] = $user->createToken('user',['app:all'])->plainTextToken;
        $success['username'] = $user->username;
        $success['success'] = true;
        return response()->json([
            'success' => true,
            'message' => "Signed up successfully",
            'user' => $success
        ], Response::HTTP_ACCEPTED);
    }
}
