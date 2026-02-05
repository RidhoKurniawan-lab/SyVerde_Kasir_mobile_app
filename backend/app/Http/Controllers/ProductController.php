<?php

namespace App\Http\Controllers;

use App\Models\Product;
use App\Models\Transaction;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Services\TransactionService;
use App\Services\InvoiceGeneratorService;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;

class ProductController extends Controller
{
    protected $transactionService;

    public function __construct(TransactionService $transactionService)
    {
        $this->transactionService = $transactionService;
    }

    public function getAll(Request $request)
    {
        $query = Product::with(['category', 'unit']);

        if ($request->user()->role->name === 'Cashier') $query->available();

        return response()->json($query->get());
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

        $userId = Auth::id();

        $products->entries()->create([
            'user_id' => $userId,
            'description' => 'Add new Product',
            'action' => 'create'
        ]);

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

        $userId = Auth::id();

        $product->entries()->create([
            'user_id' => $userId,
            'description' => 'Update Product',
            'action' => 'update'
        ]);

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

        $product->entries()->create([
            'user_id' => $id,
            'description' => 'Deleted Product' . $product->name,
            'action' => 'delete'
        ]);

        $product->delete();

        return response()->json(['deleted' => true]);
    }

    public function updateBulkStock(Request $request)
    {

        $request->validate([
            'items' => 'required|array',
            'items.*.id' => 'required|exists:products,id',
            'items.*.stock' => 'required|integer|min:0'
        ]);

        DB::transaction(function () use ($request) {
            foreach ($request->items as $item) {
                Product::where('id', $item['id'])
                    ->increment('stock', $item['stock']);
            }
        });

        return response()->json(['updated' => true]);
    }

    public function store(Request $request, InvoiceGeneratorService $invoiceService)
    {

        $request->validate([
            'payment_method' => 'required|string',
            'paid_amount' => 'required|numeric',
            'total' => 'required|numeric',
            'grand_total' => 'required|numeric',
            'discount_total' => 'required|numeric',
            'change_amount' => 'required|numeric',
            'items' => 'required|array|min:1',
            'items.*.product_id' => 'required|integer|exists:products,id',
            'items.*.qty' => 'required|integer',
            'items.*.price' => 'required|numeric',
            'items.*.discount' => 'required|numeric',
            'items.*.subtotal' => 'required|numeric',
        ]);


        $transaction = $this->transactionService->createTransaction(
            $request,
            $invoiceService
        );

        $userId = Auth::id();

        $transaction->entries()->create([
            'user_id' => $userId,
            'description' => 'Add new Transaction',
            'action' => 'create'
        ]);


        return response()->json([
            'status' => true,
            'message' => 'Transaksi berhasil',
            'data' => $transaction,
        ]);
    }

    public function getAllPaginate(Request $request)
    {
        $limit = $request->query('limit', 10);

        $products = Product::select([
            'products.name',
            'products.stock',
            'products.price',
            'units.name as unit_name'
        ])
            ->join('units', 'units.id', '=', 'products.unit_id')
            ->latest('products.created_at')
            ->simplePaginate($limit);

        return response()->json($products);
    }
}
