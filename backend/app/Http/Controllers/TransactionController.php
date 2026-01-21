<?php

namespace App\Http\Controllers;

use App\Models\Transaction;
use Illuminate\Http\Request;

class TransactionController extends Controller
{
    public function getAll() {
        $transaction =Transaction::select([
            'id',
            'invoice_number',
            'created_at'
        ])->latest()->simplePaginate(20);

        return response()->json($transaction);
    }

    public function getById(Transaction $transaction){
        $transaction->load(['items.product', 'items.product.category', 'items.product.unit']);

        return response()->json($transaction);
    }
}
