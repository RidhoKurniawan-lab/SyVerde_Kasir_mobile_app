<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\UnitController;
use App\Http\Controllers\ProductController;
use App\Http\Controllers\CategoryController;
use App\Http\Controllers\TransactionController;
use App\Models\Product;
use App\Models\Transaction;

Route::post('/login', [AuthController::class, 'login']);

Route::middleware('auth:sanctum')->group(function () {

    Route::get('/user/get', [AuthController::class, 'getAll']);


    Route::get('/product/get', [ProductController::class, 'getAll']);

    Route::get('/unit/get', [UnitController::class, 'getAll']);

    Route::get('/product/{id}/get', [ProductController::class, 'getById']);

    Route::delete('/product/{id}/delete', [ProductController::class, 'delete']);

    Route::post('/product/insert', [ProductController::class, 'insert']);

    Route::post('/product/{product}/update', [ProductController::class, 'update']);

    Route::get('/product/get/paginate', [ProductController::class, 'getAllPaginate']);

    Route::get('/audit/get/paginate', [ProductController::class, 'getAllLog']);

    // Category CRUD
    Route::get('/category/get', [CategoryController::class, 'getAll']);

    Route::get('/category/{category}/get', [CategoryController::class, 'getByid']);

    Route::post('/category/insert', [CategoryController::class, 'insert']);

    Route::put('/category/{category}/update',[CategoryController::class, 'update']);

    Route::delete('/category/{category}/delete', [CategoryController::class, 'delete']);

    Route::post('/product/update-stock', [ProductController::class, 'updateBulkStock']);


    //Transaction 
    Route::post('/transaction/insert', [ProductController::class, 'store']);

    Route::get('/transaction/get', [TransactionController::class, 'getAll']);

    Route::get('/transaction/{transaction}/get', [TransactionController::class, 'getById']);

    Route::get('/transaction/get/summery', [TransactionController::class, 'summeryToday']);

    Route::get('/transaction/monthly-summary', [TransactionController::class, 'monthlySummary']);

    Route::get('/transaction/get/summery-by-cashier', [TransactionController::class, 'summeryByCashier']);

    Route::get('/product/best-seller', [ProductController::class, 'bestSeller']);
    Route::get('/product/search', [\App\Http\Controllers\ProductSearchController::class, 'search']);


});

