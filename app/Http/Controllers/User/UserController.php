<?php

namespace App\Http\Controllers\User;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Symfony\Component\HttpFoundation\Response;

class UserController extends Controller
{
    public function logout()
    {
        Auth::logout();
        return response()->json([
            'success' => true,
            'message' => "Logged out successfully",
            'data' => []
        ], Response::HTTP_OK);
    }

    public function getUser()
    {
        dd(1);
        $user = Auth::user();
        return response()->json([
            'success' => true,
            'message' => "User retrieved successfully",
            'data' => $user
        ], Response::HTTP_OK);
    }

    public function updateUser(Request $request)
    {

    }
}
