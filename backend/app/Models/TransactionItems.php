<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class TransactionItems extends Model
{
    use HasFactory;

    public $timestamps = false;

    protected $fillable = [
        'transaction_id',
        'product_id',
        'qty',
        'price',
        'discount',
        'subtotal'
    ];

    public function transaction(){
        return $this->belongsTo(Transaction::class);
    }

    public function product(){
        return $this->belongsTo(Product::class);
    }
}
