<?php

namespace Database\Seeders;

use Carbon\Carbon;
use App\Models\Product;
use App\Models\Transaction;
use Illuminate\Database\Seeder;
use App\Models\TransactionItems;
use App\Services\InvoiceGeneratorService;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;

class TransactionSeeders extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        //Get all data on table product
        $products  = Product::all();

        // set range 2 months
        $startDate = Carbon::now()->subMonths(2)->startOfDay();
        $endDate = Carbon::now()->endOfDay();

        //if start date <= or lte (les then or Equal) then add day
        for ($date = $startDate; $date->lte($endDate); $date->addDay()) {

            // set random perDay 5-20 transaction
            $dialyTransactionCount = rand(5, 20);

            // for looping transaction perday if rand 5 make 5 transaction
            for ($i = 0; $i < $dialyTransactionCount; $i++) {

                $invoiceService = app(InvoiceGeneratorService::class);
                $paymentMethod = collect(['cash', 'qris'])->random();
                $createAt = $date->copy()->addMinutes(rand(0, 1440));
                $userId = rand(2, 3);

                $transaction = Transaction::create([
                    'invoice_number' => $invoiceService->generateInvoice($createAt),
                    'user_id' => $userId,
                    'total' => 0,
                    'discount_total' => 0,
                    'grand_total' => 0,
                    'payment_method' => $paymentMethod,
                    'paid_amount' => 0,
                    'change_amount' => 0,
                    'created_at' => $date->copy()->addMinutes(rand(0, 1440))
                ]);

                $total = 0;

                $itemCount = rand(1, 6);
                $selectedProducts = $products->random($itemCount);

                foreach ($selectedProducts as $product) {
                    $qty = rand(1, 4);
                    $subTotal = $qty * $product->price;

                    TransactionItems::create([
                        'transaction_id' => $transaction->id,
                        'product_id' => $product->id,
                        'price' => $product->price,
                        'qty' => $qty,
                        'discount' => 0,
                        'subtotal' => $subTotal,
                    ]);

                    $total += $subTotal;
                }

                $paid = $total + rand(0, 50000);

                $transaction->update([
                    'total' => $total,
                    'grand_total' => $total,
                    'paid_amount' => $paid,
                    'change_amount' => $paid - $total
                ]);

                $transaction->entries()->create([
                    'user_id' => $userId,
                    'description' => 'Add new Transaction',
                    'action' => 'create',
                    'created_at' => $date->copy()->addMinutes(rand(0, 1440))
                ]);
            }
        }
    }
}
