<?php
namespace App\Services;

use App\Models\Product;
use App\Models\Transaction;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Services\InvoiceGeneratorService;

class TransactionService
{
    public function createTransaction(Request $request, InvoiceGeneratorService $invoiceService)
    {
        return DB::transaction(function () use ($request, $invoiceService) {
            $transaction = Transaction::create([
                'invoice_number' => $invoiceService->generateInvoice(),
                'user_id' => $request->user()->id,
                'payment_method' => $request->payment_method,
                'paid_amount' => $request->paid_amount,
                'total' => $request->total,
                'grand_total' => $request->grand_total,
                'discount_total' => $request->discount_total,
                'change_amount' => $request->change_amount,
            ]);

            foreach($request->items as $item) {
                $product = Product::lockForUpdate()->find($item['product_id']);

                if(!$product){
                    throw new \Exception("Produk ID {$item['product_id']} not found");
                }

                if($product->stock < $item['qty']) {
                    throw new \Exception("Stock {$product->name} not enough");
                }

                $transaction->items()->create($item);

                $product->decrement('stock', $item['qty']);
            }

            return $transaction;
        });
    }
}
