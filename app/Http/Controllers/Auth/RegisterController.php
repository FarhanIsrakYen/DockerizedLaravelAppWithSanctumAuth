<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Http\Requests\CreateUserRequest;
use App\Http\Requests\LoginUserRequest;
use App\Models\User;
use Illuminate\Support\Facades\Auth;
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
        ], Response::HTTP_OK);
    }

    public function login(LoginUserRequest $request){
        try {
            if(!Auth::attempt($request->only(['username', 'password']))){
                return response()->json([
                    'status' => false,
                    'message' => 'Invalid username or password! Please try again',
                ], Response::HTTP_UNAUTHORIZED);
            }

            $user = User::where('username', $request->username)->first();

            return response()->json([
                'status' => true,
                'message' => 'Logged in successfully!',
                'token' => $user->createToken("API TOKEN")->plainTextToken
            ], Response::HTTP_OK);

        } catch (\Throwable $th) {
            return response()->json([
                'status' => false,
                'message' => $th->getMessage()
            ], Response::HTTP_INTERNAL_SERVER_ERROR);
        }
    }
}
