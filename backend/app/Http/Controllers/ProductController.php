<?php

namespace App\Http\Controllers;

use App\Models\Product;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;

class ProductController extends Controller
{

    public function getAll()
    {
        $products = Product::with(['category', 'unit'])->get();
        return response()->json($products);
    }

    public function getById($id)
    {
        $product = Product::find($id);

        if (!$product) {
            return response()->json([
                'message' => 'Product not found',
            ], 404);
        }

        $product->load(['category', 'unit']);

        return response()->json($product);
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
            'image' => 'nullable|image|mimes:jpg,jpeg,png|max:2048'
        ]);

        if ($request->hasFile('image')) {
            $path = $request->file('image')->store('product', 'public');
            $validated['image'] = $path;
        }

        $products = Product::create($validated);

        $products->refresh()->load(['category', 'unit']);

        return response()->json($products, 201);
    }

    public function update(Request $request, Product $product)
    {

        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'category_id' => 'required|integer|exists:categories,id',
            'unit_id' => 'required|integer|exists:units,id',
            'price' => 'required|numeric',
            'sku' => 'nullable|string|max:50|unique:products,sku,' . $product->id,
            'description' => 'nullable|string',
            'image' => 'nullable|image|mimes:jpg,jpeg,png|max:2048'
        ]);

        if ($request->hasFile('image')) {
            if ($product->image && Storage::disk('public')->exists($product->image)) {
                Storage::disk('public')->delete($product->image);
            }

            $path = $request->file('image')->store('product', 'public');
            $validated['image'] = $path;
        }

        $product->update($validated);

        $product->refresh()->load(['category', 'unit']);

        return response()->json($product);
    }

    public function delete($id)
    {

        $product = Product::find($id);

        if (!$product) {
            return response()->json([
                'message' => 'Product not found',
            ], 404);
        }

        $product->delete();

        return response()->json(['deleted' => true]);
    }

    public function updateBulkStock(Request $request){

        $request->validate([
            'items' => 'required|array',
            'items.*.id' => 'required|exists:products,id',
            'items.*.stock' => 'required|integer|min:0'
        ]);

        DB::transaction(function () use ($request) {
            foreach($request->items as $item){
                Product::where('id', $item['id'])
                ->increment('stock', $item['stock']);
            }
        });

        return response()->json(['updated' => true]);
    }
}
