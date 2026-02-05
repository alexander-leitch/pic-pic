<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class UserSeeder extends Seeder
{
    public function run(): void
    {
        // Create admin user
        User::create([
            'name' => 'Admin User',
            'email' => 'admin@picpic.com',
            'password' => Hash::make('password'),
            'avatar_url' => 'https://picsum.photos/seed/admin/200/200',
            'description' => 'PicPic administrator | Love sharing moments',
            'social_links' => [
                'twitter' => '@admin',
                'instagram' => '@admin_picpic',
            ],
            'is_admin' => true,
            'is_active' => true,
            'sso_provider' => 'google',
            'sso_id' => 'admin_sso_id',
        ]);

        // Create regular users
        $names = [
            'Emma Johnson', 'Liam Smith', 'Olivia Brown', 'Noah Davis', 'Ava Wilson',
            'Ethan Martinez', 'Sophia Anderson', 'Mason Taylor', 'Isabella Thomas', 'William Jackson',
            'Mia White', 'James Harris', 'Charlotte Martin', 'Benjamin Thompson', 'Amelia Garcia',
            'Lucas Martinez', 'Harper Robinson', 'Henry Clark', 'Evelyn Rodriguez', 'Alexander Lewis',
            'Abigail Lee', 'Michael Walker', 'Emily Hall', 'Ethan Allen', 'Elizabeth Young',
            'Daniel King', 'Sofia Wright', 'Joseph Lopez', 'Avery Hill', 'Andrew Scott',
            'Ella Green', 'David Adams', 'Madison Baker', 'Christopher Nelson', 'Scarlett Carter',
            'Joseph Mitchell', 'Victoria Perez', 'Charles Roberts', 'Grace Turner', 'Joshua Phillips',
            'Chloe Campbell', 'Samuel Parker', 'Zoe Evans', 'Nathan Edwards', 'Lily Collins',
            'Christian Stewart', 'Zoe Sanchez', 'Dylan Morris', 'Natalie Rogers', 'Leo Reed',
            'Hannah Cook', 'Gabriel Morgan', 'Aubrey Bell', 'Julian Murphy', 'Leah Bailey',
            'Aaron Rivera', 'Addison Cooper', 'Isaac Richardson', 'Lillian Cox', 'Evan Howard',
            'Layla Ward', 'Pierce Torres', 'Penelope Peterson', 'Owen Gray', 'Riley Ramirez',
            'Jack James', 'Aria Watson', 'Luke Brooks', 'Mila Kelly', 'Cameron Sanders',
            'Hazel Price', 'Bennett Bennett', 'Aurora Wood', 'Adrian Barnes', 'Stella Ross',
            'Jonathan Henderson', 'Ellis Coleman', 'Peyton Jenkins', 'Seth Perry', 'Brooke Powell',
            'Micah Long', 'Lila Patterson', 'Joel Flores', 'Claire Washington', 'Elias Morgan',
            'Isla Campbell', 'Parker Russell', 'Caroline Diaz', 'Jeremiah Hayes', 'Ruby Myers',
            'Vincent Freeman', 'Alice Hamilton', 'Graham Graham', 'Scarlett Sims', 'Bryce Walton',
            'Naomi Bryant', 'Alexander Alexander', 'Mila Griffin', 'Ryan Odom', 'Serenity Spencer',
            'Nathaniel Peters', 'Kennedy Paige', 'Rowan Kennedy', 'Mackenzie Kennedy', 'Oscar Kennedy',
            'Everly Kennedy', 'Jaxson Kennedy', 'Brooklyn Kennedy', 'Hudson Kennedy', 'Natalia Kennedy',
            'Caleb Kennedy', 'Lila Kennedy', 'Asher Kennedy', 'Aria Kennedy', 'Connor Kennedy',
            'Eliana Kennedy', 'Luke Kennedy', 'Riley Kennedy', 'Aiden Kennedy', 'Chloe Kennedy',
        ];

        foreach ($names as $index => $name) {
            $firstName = strtolower(str_replace(' ', '', $name));
            
            User::create([
                'name' => $name,
                'email' => $firstName . '@example.com',
                'password' => Hash::make('password'),
                'avatar_url' => "https://picsum.photos/seed/$firstName/200/200",
                'description' => 'PicPic enthusiast | Love sharing moments',
                'social_links' => [
                    'twitter' => '@' . $firstName,
                    'instagram' => '@' . $firstName . '_picpic',
                ],
                'is_admin' => false,
                'is_active' => true,
                'sso_provider' => 'google',
                'sso_id' => $firstName . '_sso_id',
            ]);
        }
    }
}
