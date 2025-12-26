<?php

namespace Database\Seeders;

use App\Models\User;
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

        User::create([
            'name' => 'Yumi Lee',
            'email' => 'admin@gmail.com',
            'password' => 'admin123',
            'is_active' => true,
            'role_id' => 1,
        ]);

        User::create([
            'name' => 'Takeda Kaneshiro',
            'email' => 'kasir@gmail.com',
            'password' => 'kasir123',
            'is_active' => false,
            'role_id' => 2
        ]);
    }
}
