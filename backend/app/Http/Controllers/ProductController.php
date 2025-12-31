<?php

namespace App\Http\Controllers;

use App\Models\Product;
use Illuminate\Http\Request;

class ProductController extends Controller
{
    public function getAll()
    {
        $products = Product::with(['category', 'unit'])->get();
        return response()->json($products);
    }

    public function insert(Request $request)
    {

        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'category_id' => 'required|integer|exists:categories,id',
            'unit_id' => 'required|integer|exists:units,id',
            'price' => 'required|numeric',
            'sku' => 'nullable|string|max:50|unique:products,sku',
            'description' => 'nullable|string',
        ]);

        $products = Product::create($validated);

        $products->refresh();

        $products->load(['category', 'unit']);

        return response()->json($products, 201);
    }
}
