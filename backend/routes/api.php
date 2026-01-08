<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\UnitController;
use App\Http\Controllers\ProductController;
use App\Http\Controllers\CategoryController;
use App\Models\Product;

Route::post('/login', [AuthController::class, 'login']);

Route::middleware('auth:sanctum')->group(function () {

    Route::get('/product/get', [ProductController::class, 'getAll']);

    Route::get('/unit/get', [UnitController::class, 'getAll']);

    Route::get('/product/{id}/get', [ProductController::class, 'getById']);

    Route::delete('/product/{id}/delete', [ProductController::class, 'delete']);

    Route::post('/product/insert', [ProductController::class, 'insert']);

    Route::post('/product/{product}/update', [ProductController::class, 'update']);

    // Category CRUD
    Route::get('/category/get', [CategoryController::class, 'getAll']);

    Route::get('/category/{category}/get', [CategoryController::class, 'getByid']);

    Route::post('/category/insert', [CategoryController::class, 'insert']);

    Route::put('/category/{category}/update',[CategoryController::class, 'update']);

    Route::delete('/category/{category}/delete', [CategoryController::class, 'delete']);

    Route::post('/product/update-stock', [ProductController::class, 'updateBulkStock']);
});

