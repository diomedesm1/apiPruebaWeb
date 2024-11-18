<?php

use App\Http\Controllers\MovieController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

Route::get('/movies', [MovieController::class, 'index']);
Route::post('/movies', [MovieController::class, 'store']);
Route::put('/movies/{id}', [MovieController::class, 'update']);
Route::delete('/movies/{id}', [MovieController::class, 'destroy']);

