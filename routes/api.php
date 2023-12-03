<?php

use App\Http\Controllers\Auth\RegisterController;
use App\Http\Controllers\User\UserController;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/
Route::post('/register', [RegisterController::class, 'register']);
Route::post('/auth/login', [RegisterController::class, 'login'])
    ->middleware('throttle:loginAttempts');

Route::middleware(['auth', 'sanctum'])->group(function () {
    Route::controller(UserController::class)->prefix('/users')
        ->group(function () {
            Route::get('/', 'getUser');
            Route::post('/logout', 'logout');
            Route::put('/update', 'updateUser');
    });
});
