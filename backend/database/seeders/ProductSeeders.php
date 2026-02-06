<?php

namespace Database\Seeders;

use App\Models\Product;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;

class ProductSeeders extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {

        DB::statement('SET FOREIGN_KEY_CHECKS=0;');
        Product::truncate();
        DB::statement('SET FOREIGN_KEY_CHECKS=1;');

        $products =
            [
                [
                    'sku' => 'AR-001',
                    'name' => 'Arabika Gayo Natural',
                    'category_id' => 1,
                    'unit_id' => 1,
                    'price' => 95000.00,
                    'image' => 'image',
                    'description' => 'Natural fruity gayo'
                ],
                [
                    'sku' => 'AR-002',
                    'name' => 'Arabika Gayo Washed',
                    'category_id' => 1,
                    'unit_id' => 2,
                    'price' => 90000.00,
                    'image' => 'image',
                    'description' => 'Clean washed gayo'
                ],
                [
                    'sku' => 'AR-003',
                    'name' => 'Arabika Kintamani Honey',
                    'category_id' => 1,
                    'unit_id' => 3,
                    'price' => 105000.00,
                    'image' => 'image',
                    'description' => 'Sweet honey process'
                ],
                [
                    'sku' => 'AR-004',
                    'name' => 'Arabika Kintamani Washed',
                    'category_id' => 1,
                    'unit_id' => 4,
                    'price' => 98000.00,
                    'image' => 'image',
                    'description' => 'Clean citrus body'
                ],
                [
                    'sku' => 'AR-005',
                    'name' => 'Arabika Toraja Sapan',
                    'category_id' => 1,
                    'unit_id' => 1,
                    'price' => 115000.00,
                    'image' => 'image',
                    'description' => 'Spicy earthy profile'
                ],
                [
                    'sku' => 'AR-006',
                    'name' => 'Arabika Toraja Natural',
                    'category_id' => 1,
                    'unit_id' => 1,
                    'price' => 120000.00,
                    'image' => 'image',
                    'description' => 'Bold natural toraja'
                ],
                [
                    'sku' => 'AR-007',
                    'name' => 'Arabika Flores Bajawa',
                    'category_id' => 1,
                    'unit_id' => 2,
                    'price' => 110000.00,
                    'image' => 'image',
                    'description' => 'Chocolate nutty body'
                ],
                [
                    'sku' => 'AR-008',
                    'name' => 'Arabika Flores Manggarai',
                    'category_id' => 1,
                    'unit_id' => 4,
                    'price' => 108000.00,
                    'image' => 'image',
                    'description' => 'Floral smooth finish'
                ],
                [
                    'sku' => 'AR-009',
                    'name' => 'Arabika Lintong Natural',
                    'category_id' => 1,
                    'unit_id' => 1,
                    'price' => 112000.00,
                    'image' => 'image',
                    'description' => 'Heavy body natural'
                ],
                [
                    'sku' => 'AR-010',
                    'name' => 'Arabika Mandheling Grade 1',
                    'category_id' => 1,
                    'unit_id' => 2,
                    'price' => 118000.00,
                    'image' => 'image',
                    'description' => 'Premium mandheling body'
                ],
                [
                    'sku' => 'AR-011',
                    'name' => 'Arabika Java Preanger',
                    'category_id' => 1,
                    'unit_id' => 4,
                    'price' => 102000.00,
                    'image' => 'image',
                    'description' => 'Classic java balance'
                ],
                [
                    'sku' => 'AR-012',
                    'name' => 'Arabika Ijen Raung',
                    'category_id' => 1,
                    'unit_id' => 1,
                    'price' => 100000.00,
                    'image' => 'image',
                    'description' => 'Bright volcanic taste'
                ],
                [
                    'sku' => 'AR-013',
                    'name' => 'Arabika Kerinci Honey',
                    'category_id' => 1,
                    'unit_id' => 3,
                    'price' => 107000.00,
                    'image' => 'image',
                    'description' => 'Sweet kerinci honey'
                ],
                [
                    'sku' => 'AR-014',
                    'name' => 'Arabika Kerinci Natural',
                    'category_id' => 1,
                    'unit_id' => 1,
                    'price' => 110000.00,
                    'image' => 'image',
                    'description' => 'Fruity kerinci natural'
                ],
                [
                    'sku' => 'AR-015',
                    'name' => 'Arabika Pangalengan Washed',
                    'category_id' => 1,
                    'unit_id' => 2,
                    'price' => 99000.00,
                    'image' => 'image',
                    'description' => 'Clean west java'
                ],
                [
                    'sku' => 'AR-016',
                    'name' => 'Arabika Pangalengan Honey',
                    'category_id' => 1,
                    'unit_id' => 2,
                    'price' => 104000.00,
                    'image' => 'image',
                    'description' => 'Sweet honey java'
                ],
                [
                    'sku' => 'RB-001',
                    'name' => 'Robusta Temanggung Fine',
                    'category_id' => 2,
                    'unit_id' => 3,
                    'price' => 85000.00,
                    'image' => 'image',
                    'description' => 'Strong chocolate bitterness'
                ],
                [
                    'sku' => 'RB-002',
                    'name' => 'Robusta Sidikalang Premium',
                    'category_id' => 2,
                    'unit_id' => 3,
                    'price' => 88000.00,
                    'image' => 'image',
                    'description' => 'Bold premium robusta'
                ],
                [
                    'sku' => 'BRA-001',
                    'name' => 'Espresso Blend House',
                    'category_id' => 2,
                    'unit_id' => 4,
                    'price' => 95000.00,
                    'image' => 'image',
                    'description' => 'Balanced daily espresso'
                ],
                [
                    'sku' => 'BRA-002',
                    'name' => 'Espresso Blend Signature',
                    'category_id' => 2,
                    'unit_id' => 1,
                    'price' => 105000.00,
                    'image' => 'image',
                    'description' => 'Rich signature blend'
                ],
            ];

            foreach($products as $productData){
                $product = Product::create([
                    'name' => $productData['name'],
                    'sku' => $productData['sku'],
                    'category_id' => $productData['category_id'],
                    'unit_id' => $productData['unit_id'],
                    'price' => $productData['price'],
                    'image' => $productData['image'],
                    'description' => $productData['description'],
                    'stock' => rand(200,350)
                ]);

                $product->entries()->create([
                    'user_id' => 1,
                    'description' => 'Add new product',
                    'action' => 'create',
                ]);

            }
    }
}
