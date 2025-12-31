<?php

namespace Database\Seeders;

use App\Models\User;
use App\Models\Unit;
use App\Models\Category;
use App\Models\Product;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;

class DatabaseSeeder extends Seeder
{
    use WithoutModelEvents;

    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // User::factory(10)->create();

        DB::table('roles')->insert([
            ['name' => 'Administrator'],
            ['name' => 'Cashier'],
        ]);

        Unit::insert([
            [
                'name' => 'Kg',
                'created_at' => now(),
                'updated_at' => now()
            ],
            [
                'name' => 'Gram',
                'created_at' => now(),
                'updated_at' => now()
            ],
            [
                'name' => 'Ons',
                'created_at' => now(),
                'updated_at' => now()
            ],
        ]);

        User::create([
            'name' => 'Yumi Lee',
            'email' => 'admin@gmail.com',
            'password' => 'admin123',
            'is_active' => true,
            'role_id' => 1,
            'created_at' => now(),
            'updated_at' => now()
        ]);

        User::create([
            'name' => 'Takeda Kaneshiro',
            'email' => 'kasir@gmail.com',
            'password' => 'kasir123',
            'is_active' => false,
            'role_id' => 2,
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        Category::insert([
            [
                'name' => 'Arabika',
                'created_at' => now(),
                'updated_at' => now()
            ],
            [
                'name' => 'Robusta',
                'created_at' => now(),
                'updated_at' => now()
            ],
            [
                'name' => 'Liberika',
                'created_at' => now(),
                'updated_at' => now()
            ],
            [
                'name' => 'Excelsa',
                'created_at' => now(),
                'updated_at' => now()
            ]
        ]);
        Product::insert([
            [
                'category_id' => 1,
                'sku' => 'AR-001',
                'name' => 'Kopi Arabika Gayo',
                'price' => 75000.00,
                'unit_id' => 2,
                'image' => 'image',
                'description' => '',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'category_id' => 2,
                'sku' => 'RB-001',
                'name' => 'Kopi Robusta Lampung',
                'price' => 60000.00,
                'unit_id' => 1,
                'image' => 'image',
                'description' => '',
                'created_at' => now(),
                'updated_at' => now(),
            ],
        ]);
    }
}
