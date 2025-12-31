<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\UnitController;
use App\Http\Controllers\ProductController;
use App\Http\Controllers\CategoryController;
use App\Models\Product;

Route::post('/login', [AuthController::class, 'login']);

Route::middleware('auth:sanctum')->group(function () {

    Route::get('/category/get', [CategoryController::class, 'getAll']);

    Route::get('/product/get', [ProductController::class, 'getAll']);

    Route::get('/unit/get', [UnitController::class, 'getAll']);

    Route::post('/product/insert', [ProductController::class, 'insert']);
});

