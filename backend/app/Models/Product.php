<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Storage;

class Product extends Model
{
    use HasFactory;

    protected $fillable = [
        'category_id',
        'sku',
        'name',
        'price',
        'stock',
        'unit_id',
        'image',
        'description'
    ];

    protected $casts = [
        'price' => 'double'
    ];

    protected $appends = ['image_url'];

    public function getImageUrlAttribute(){
        return $this->image ? asset('storage/' . $this->image) : null ;
    }

    public function category()
    {
        return $this->belongsTo(Category::class);
    }

    public function unit()
    {
        return $this->belongsTo(Unit::class);
    }

    public function scopeAvailable($query)
    {
        return $query->where('stock', '>', 0);
    }

    public function transactionItems(){
        return $this->hasMany(TransactionItems::class);
    }

    public function entries(){
        return $this->morphMany(ActivityLogs::class, 'entryable');
    }
}
