<?php

namespace App\Http\Controllers;

use App\Models\Product;
use Illuminate\Http\Request;

class ProductSearchController extends Controller
{
    public function search(Request $request)
    {
        $query = $request->query('query', '');

        $products = Product::with(['category', 'unit'])
            ->when($query != '', function ($q) use ($query) {
                $q->where('name', 'like', "%$query%")
                  ->orWhere('sku', 'like', "%$query%");
            })
            ->get();

        return response()->json([
            'data' => $products
        ]);
    }
}
