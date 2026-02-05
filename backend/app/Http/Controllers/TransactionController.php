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
        $querySearch = $request->query('query');

        $transaction = Transaction::select([
            'transactions.id',
            'transactions.invoice_number',
            'transactions.created_at',
            'transactions.total',
            'users.name as user_name'
        ])
            ->join('users', 'users.id', '=', 'transactions.user_id')

            // filter by invoice number
            ->when($querySearch, function ($query) use ($querySearch) {
                $query->where('transactions.invoice_number', 'like', "%$querySearch%");
            })

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

    public function summeryToday(Request $request)
    {
        $period = $request->query('period', 'today');
        return response()->json($this->getSummaryData(null, $period));
    }

    public function summeryByCashier(Request $request)
    {
        $cashierId = $request->query('cashier_id');
        $period    = $request->query('period', 'today');

        if (!$cashierId) {
            return response()->json([
                'cash' => 0,
                'cash_change_percent' => 0,
                'non_cash' => 0,
                'non_cash_change_percent' => 0,
                'total_item' => 0,
                'total_item_change_percent' => 0
            ]);
        }

        return response()->json($this->getSummaryData($cashierId, $period));
    }

    private function getSummaryData($cashierId = null, $period = 'today')
    {
        $today = Carbon::today();
        $yesterday = Carbon::yesterday();

        $startDate = $today;
        $endDate = $today;
        $compareStartDate = $yesterday;
        $compareEndDate = $yesterday;

        if ($period === 'this_month') {
            $startDate = Carbon::now()->startOfMonth();
            $endDate = Carbon::now()->endOfMonth();
            $compareStartDate = Carbon::now()->subMonth()->startOfMonth();
            $compareEndDate = Carbon::now()->subMonth()->endOfMonth();
        } elseif ($period === 'last_month') {
            $startDate = Carbon::now()->subMonth()->startOfMonth();
            $endDate = Carbon::now()->subMonth()->endOfMonth();
            $compareStartDate = Carbon::now()->subMonths(2)->startOfMonth();
            $compareEndDate = Carbon::now()->subMonths(2)->endOfMonth();
        }

        $queryCurrent = Transaction::whereBetween('created_at', [$startDate->format('Y-m-d') . ' 00:00:00', $endDate->format('Y-m-d') . ' 23:59:59']);
        $queryCompare = Transaction::whereBetween('created_at', [$compareStartDate->format('Y-m-d') . ' 00:00:00', $compareEndDate->format('Y-m-d') . ' 23:59:59']);

        if ($cashierId) {
            $queryCurrent->where('user_id', $cashierId);
            $queryCompare->where('user_id', $cashierId);
        }

        // Ambil total pembayaran periode ini per metode
        $paymentTotalsCurrent = (clone $queryCurrent)->selectRaw('payment_method, SUM(total) as total')
            ->groupBy('payment_method')
            ->get();

        $cashCurrent = $paymentTotalsCurrent->firstWhere('payment_method', 'cash')->total ?? 0;
        $nonCashCurrent = $paymentTotalsCurrent->firstWhere('payment_method', 'qris')->total ?? 0;

        // Ambil total pembayaran periode pembanding per metode
        $paymentTotalsCompare = (clone $queryCompare)->selectRaw('payment_method, SUM(total) as total')
            ->groupBy('payment_method')
            ->get();

        $cashCompare = $paymentTotalsCompare->firstWhere('payment_method', 'cash')->total ?? 0;
        $nonCashCompare = $paymentTotalsCompare->firstWhere('payment_method', 'qris')->total ?? 0;

        // Total item periode ini
        $totalItemCurrent = TransactionItems::whereHas('transaction', function ($q) use ($startDate, $endDate, $cashierId) {
            $q->whereBetween('created_at', [$startDate->format('Y-m-d') . ' 00:00:00', $endDate->format('Y-m-d') . ' 23:59:59']);
            if ($cashierId) $q->where('user_id', $cashierId);
        })->sum('qty');

        $totalItemCompare = TransactionItems::whereHas('transaction', function ($q) use ($compareStartDate, $compareEndDate, $cashierId) {
            $q->whereBetween('created_at', [$compareStartDate->format('Y-m-d') . ' 00:00:00', $compareEndDate->format('Y-m-d') . ' 23:59:59']);
            if ($cashierId) $q->where('user_id', $cashierId);
        })->sum('qty');

        // Hitung persentase perubahan
        $itemPercentageChange = $totalItemCompare == 0
            ? ($totalItemCurrent > 0 ? 100 : 0)
            : (($totalItemCurrent - $totalItemCompare) / $totalItemCompare) * 100;

        return [
            'cash' => (float)$cashCurrent,
            'cash_change_percent' => $cashCompare == 0 ? ($cashCurrent > 0 ? 100 : 0) : (($cashCurrent - $cashCompare) / $cashCompare) * 100,
            'non_cash' => (float)$nonCashCurrent,
            'non_cash_change_percent' => $nonCashCompare == 0 ? ($nonCashCurrent > 0 ? 100 : 0) : (($nonCashCurrent - $nonCashCompare) / $nonCashCompare) * 100,
            'total_item' => (int)$totalItemCurrent,
            'total_item_change_percent' => (float)$itemPercentageChange
        ];
    }

    public function monthlySummary()
    {
        $start = Carbon::now()->subMonths(11)->startOfMonth();
        $end = Carbon::now()->endOfMonth();

        $data = Transaction::selectRaw("
                DATE_FORMAT(created_at, '%Y-%m') as month,
                SUM(CASE WHEN payment_method = 'cash' THEN total ELSE 0 END) as cash,
                SUM(CASE WHEN payment_method = 'qris' THEN total ELSE 0 END) as non_cash,
                SUM(total) as total_transaction
            ")
            ->whereBetween('created_at', [$start, $end])
            ->groupBy('month')
            ->orderBy('month', 'asc')
            ->get();

        return response()->json([
            'data' => $data
        ]);
    }
}
