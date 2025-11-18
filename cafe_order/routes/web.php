<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\MenuController;
use App\Http\Controllers\OrderController;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "web" middleware group. Make something great!
|
*/

Route::get('/', function () {
    return view('welcome');
});

// -------- RUTE API UNTUK FLUTTER --------
Route::prefix('api')->group(function () {
    // Rute untuk Menu
    Route::get('/menu', [MenuController::class, 'index']); // Mengambil daftar menu
    // Route::get('/menu/{id}', [MenuController::class, 'show']); // Untuk detail menu jika perlu

    // Rute untuk Order
    // POST untuk membuat order baru (singular '/order' seperti yang Anda inginkan)
    Route::post('/order', [OrderController::class, 'store']);

    // Rute untuk melihat semua order (disarankan plural '/orders' untuk koleksi)
    Route::get('/orders', [OrderController::class, 'index']); // GET untuk melihat semua order
    // Rute untuk melihat detail satu order (singular '/order/{id}')
    Route::get('/order/{id}', [OrderController::class, 'show']);
});
