<?php

namespace Database\Seeders;

use App\Models\Image;
use App\Models\User;
use Illuminate\Database\Seeder;
use Faker\Factory as Faker;

class ImageSeeder extends Seeder
{
    public function run(): void
    {
        $faker = Faker::create();
        $users = User::all();

        foreach ($users as $user) {
            // Random number of images between 20 and 120
            $imageCount = rand(20, 120);
            
            for ($i = 1; $i <= $imageCount; $i++) {
                $width = rand(400, 1200);
                $height = rand(300, 900);
                $seed = $faker->unique()->word . $user->id . $i;
                
                Image::create([
                    'user_id' => $user->id,
                    'title' => $faker->sentence(rand(3, 8)),
                    'description' => $faker->paragraph(rand(1, 3)),
                    'url' => "https://picsum.photos/seed/{$seed}/{$width}/{$height}",
                    'thumbnail_url' => "https://picsum.photos/seed/{$seed}/300/300",
                    'width' => $width,
                    'height' => $height,
                    'like_count' => rand(0, 500),
                    'comment_count' => rand(0, 50),
                    'is_active' => true,
                ]);
            }
        }
    }
}
