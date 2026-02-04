<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;
use Faker\Factory as Faker;

class UserSeeder extends Seeder
{
    public function run(): void
    {
        $faker = Faker::create();

        // Create admin user
        User::create([
            'name' => 'Admin User',
            'email' => 'admin@picpic.com',
            'password' => Hash::make('admin123'),
            'sso_provider' => 'google',
            'sso_id' => 'admin_sso_id',
            'avatar_url' => 'https://picsum.photos/seed/admin/200/200',
            'is_admin' => true,
            'is_active' => true,
            'email_verified_at' => now(),
        ]);

        // Create 99 regular users
        for ($i = 1; $i < 100; $i++) {
            User::create([
                'name' => $faker->name,
                'email' => "user{$i}@example.com",
                'password' => Hash::make('password'),
                'sso_provider' => 'google',
                'sso_id' => "user_sso_{$i}",
                'avatar_url' => "https://picsum.photos/seed/user{$i}/200/200",
                'is_admin' => false,
                'is_active' => true,
                'email_verified_at' => now(),
            ]);
        }
    }
}
