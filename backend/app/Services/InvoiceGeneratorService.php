<?php

namespace App\Services;

use Carbon\Carbon;

use App\Models\Transaction;
use function Symfony\Component\Clock\now;

class InvoiceGeneratorService
{
    public function generateInvoice(Carbon $date): string
    {
        $year = $date->format('Y');

        $lastInvoice = Transaction::whereYear('created_at', $year)
        ->orderByDesc('id')
        ->value('invoice_number');

        $next = $lastInvoice ? ((int) substr($lastInvoice, -4)) + 1 : 1;

        return 'INV-' . $year . '-' . str_pad($next, 4, '0', STR_PAD_LEFT);
    }
}
