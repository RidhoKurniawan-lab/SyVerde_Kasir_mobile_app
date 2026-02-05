<?php

namespace App\Http\Controllers;

use Carbon\Carbon;
use App\Models\Transaction;
use App\Models\TransactionItems;
use Illuminate\Http\Request;

class TransactionController extends Controller
{
    public function getAll(Request $request)
    {
        $limit     = $request->query('limit', 20);
        $startDate = $request->query('start_date');
        $endDate   = $request->query('end_date');
        $userId    = $request->query('user_id');

        $transaction = Transaction::select([
            'transactions.id',
            'transactions.invoice_number',
            'transactions.created_at',
            'transactions.total',
            'users.name as user_name'
        ])
            ->join('users', 'users.id', '=', 'transactions.user_id')

            // filter by user_id
            ->when(
                !is_null($userId) && !in_array((int) $userId, [0, 1]),
                function ($query) use ($userId) {
                    $query->where('transactions.user_id', $userId);
                }
            )

            // filter by start_date & end_date
            ->when($startDate && $endDate, function ($query) use ($startDate, $endDate) {
                $query->whereBetween('transactions.created_at', [
                    $startDate . ' 00:00:00',
                    $endDate . ' 23:59:59'
                ]);
            })

            ->latest('transactions.created_at')
            ->simplePaginate($limit);

        return response()->json($transaction);
    }


    public function getById(Transaction $transaction)
    {
        $transaction->load(['items.product', 'items.product.category', 'items.product.unit']);

        return response()->json($transaction);
    }

    public function summeryToday()
    {
        $today = Carbon::today();
        $yesterday = Carbon::yesterday();

        // Ambil total pembayaran hari ini per metode
        $paymentTotalsToday = Transaction::selectRaw('payment_method, SUM(total) as total')
            ->whereDate('created_at', $today)
            ->groupBy('payment_method')
            ->get();

        $cashToday = $paymentTotalsToday->firstWhere('payment_method', 'cash')->total ?? 0;
        $nonCashToday = $paymentTotalsToday->firstWhere('payment_method', 'qris')->total ?? 0;

        // Ambil total pembayaran kemarin per metode
        $paymentTotalsYesterday = Transaction::selectRaw('payment_method, SUM(total) as total')
            ->whereDate('created_at', $yesterday)
            ->groupBy('payment_method')
            ->get();

        $cashYesterday = $paymentTotalsYesterday->firstWhere('payment_method', 'cash')->total ?? 0;
        $nonCashYesterday = $paymentTotalsYesterday->firstWhere('payment_method', 'qris')->total ?? 0;

        // Total item hari ini
        $totalItemToday = TransactionItems::whereHas('transaction', function ($q) use ($today) {
            $q->whereDate('created_at', $today);
        })->sum('qty');

        $totalItemYesterday = TransactionItems::whereHas('transaction', function ($q) use ($yesterday) {
            $q->whereDate('created_at', $yesterday);
        })->sum('qty');

        // Hitung persentase perubahan
        $itemPercentageChange = $totalItemYesterday == 0
            ? ($totalItemToday > 0 ? 100 : 0)
            : (($totalItemToday - $totalItemYesterday) / $totalItemYesterday) * 100;

        return response()->json([
            'cash' => $cashToday,
            'cash_change_percent' => $cashYesterday == 0 ? ($cashToday > 0 ? 100 : 0) : (($cashToday - $cashYesterday) / $cashYesterday) * 100,
            'non_cash' => $nonCashToday,
            'non_cash_change_percent' => $nonCashYesterday == 0 ? ($nonCashToday > 0 ? 100 : 0) : (($nonCashToday - $nonCashYesterday) / $nonCashYesterday) * 100,
            'total_item' => $totalItemToday,
            'total_item_change_percent' => $itemPercentageChange
        ]);
    }
}
