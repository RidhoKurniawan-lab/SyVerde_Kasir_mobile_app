<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ActivityLogs extends Model
{
    protected $fillable = [
        'user_id',
        'action',
        'description',
        'created_at'
    ];

    public function entryable(){

        return $this->morphTo();
    }

    public function user(){
        return $this->belongsTo(User::class);
    }
}
