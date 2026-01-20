<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Transaction extends Model
{
    use HasFactory;

    protected $fillable = [
        'invoice_number',
        'user_id',
        'total',
        'discount_total',
        'grand_total',
        'payment_method',
        'paid_amount',
        'change_amount'
    ];

    public function items(){
        return $this->hasMany(TransactionItems::class);
    }

    public function user(){
        return $this->belongsTo(User::class);
    }
}
