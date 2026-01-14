<?php

namespace App\Services;

use App\Models\Transaction;

use function Symfony\Component\Clock\now;

class InvoiceNumberService
{
    public function generate(): string
    {
        $year = now()->format('Y');

        $lastInvoice = Transaction::whereYear('created_at', $year)
        ->orderByDesc('id')
        ->value('invoice_number');

        $next = $lastInvoice ? ((int) substr($lastInvoice, -4)) + 1 : 1;

        return 'INV-' . $year . '-' . str_pad($next, 4, '0', STR_PAD_LEFT);
    }
}
