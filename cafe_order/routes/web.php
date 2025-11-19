<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Auth\AuthRegisterController;
use App\Http\Controllers\Auth\AuthLoginController;
use App\Http\Controllers\Auth\AuthLogoutController;
use App\Http\Middleware\ApiTokenMiddleware;




Route::get('/', function () {
    return view('welcome');
});

Route::post('/register', [AuthRegisterController::class, 'register']);
Route::post('/login', [AuthLoginController::class, 'login']);

Route::middleware(ApiTokenMiddleware::class)->group(function () {
    Route::post('/logout', [AuthLogoutController::class, 'logout']);

    // Contoh: route yang butuh login
    Route::get('/profile', function (\Illuminate\Http\Request $request) {
        return $request->user();
    });
});



