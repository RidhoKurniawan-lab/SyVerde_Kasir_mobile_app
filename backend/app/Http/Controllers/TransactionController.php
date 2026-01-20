<?php

namespace App\Http\Controllers;

use App\Models\Transaction;
use Illuminate\Http\Request;

class TransactionController extends Controller
{
    public function getAll() {
        $transaction =Transaction::latest()->get();

        return response()->json($transaction);
    }

    public function getById(Transaction $transaction){
        $transaction->load(['items.product', 'items.product.category', 'items.product.unit']);

        return response()->json($transaction);
    }
}
