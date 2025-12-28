<?php

namespace App\Http\Controllers;

use App\Models\Unit;
use Illuminate\Http\Request;

class UnitController extends Controller
{
    public function getAll(){
        $unit = Unit::all();
        return response()->json($unit);
    }
}
