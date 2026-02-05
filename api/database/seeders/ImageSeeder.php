<?php

namespace Database\Seeders;

use App\Models\Image;
use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class ImageSeeder extends Seeder
{
    public function run(): void
    {
        $users = User::all();
        $imageTitles = [
            'Sunset Dreams', 'Mountain Vista', 'Ocean Waves', 'Forest Path', 'City Lights',
            'Desert Bloom', 'Northern Lights', 'Tropical Paradise', 'Autumn Colors', 'Winter Wonderland',
            'Spring Awakening', 'Summer Breeze', 'Golden Hour', 'Blue Hour', 'Starry Night',
            'Morning Mist', 'Evening Glow', 'Rainbow Bridge', 'Waterfall Wonder', 'Lake Reflection',
            'Garden Paradise', 'Urban Jungle', 'Coastal Beauty', 'Island Life', 'Mountain Peak',
            'Valley View', 'River Flow', 'Canyon Dreams', 'Desert Sunset', 'Beach Walk',
            'Forest Canopy', 'Meadow Bloom', 'Alpine Lake', 'Glacier View', 'Volcano Peak',
            'Coral Reef', 'Marine Life', 'Underwater World', 'Ocean Depths', 'Tropical Fish',
            'Wildlife Safari', 'Bird Sanctuary', 'Butterfly Garden', 'Flower Field', 'Apple Orchard',
            'Vineyard Sunset', 'Farm Life', 'Country Road', 'Barn Scene', 'Harvest Moon',
            'City Skyline', 'Street Art', 'Architecture', 'Modern Building', 'Historic Landmark',
            'Bridge View', 'Tower Light', 'Park Bench', 'Fountain Joy', 'City Park',
            'Night Market', 'Festival Lights', 'Concert Crowd', 'Dance Floor', 'Music Festival',
            'Art Gallery', 'Museum Visit', 'Sculpture Garden', 'Street Performance', 'Cultural Event',
            'Food Market', 'Coffee Shop', 'Bakery Fresh', 'Restaurant View', 'Cooking Session',
            'Book Store', 'Library Quiet', 'Study Corner', 'Reading Nook', 'Knowledge Hub',
            'Sports Arena', 'Stadium Lights', 'Game Day', 'Team Spirit', 'Victory Celebration',
            'Fitness Center', 'Yoga Studio', 'Running Track', 'Swimming Pool', 'Gym Session',
            'Tech Hub', 'Office Space', 'Meeting Room', 'Startup Life', 'Innovation Lab',
            'Fashion Show', 'Style Statement', 'Designer Collection', 'Fashion Week', 'Runway Model',
            'Vintage Store', 'Antique Shop', 'Market Stall', 'Boutique Window', 'Shopping District',
            'Home Sweet Home', 'Living Room', 'Kitchen Dreams', 'Bedroom Comfort', 'Garden Party',
            'Pet Paradise', 'Cat Nap', 'Dog Play', 'Bird Song', 'Fish Tank',
            'Childhood Memories', 'Playground Fun', 'Birthday Party', 'Family Gathering', 'Holiday Joy',
            'Travel Adventure', 'Road Trip', 'Airport Terminal', 'Train Journey', 'Cruise Ship',
            'Camping Night', 'Hiking Trail', 'Climbing Summit', 'Kayaking Adventure', 'Sailing Trip',
            'Photography Session', 'Camera Lens', 'Photo Studio', 'Dark Room', 'Digital Art',
            'Music Studio', 'Guitar Solo', 'Piano Keys', 'Drum Beat', 'Concert Hall',
            'Theater Show', 'Movie Night', 'Drama Performance', 'Comedy Club', 'Dance Studio',
            'Workshop Space', 'Creative Corner', 'Art Studio', 'Craft Room', 'DIY Project',
            'Science Lab', 'Research Center', 'Innovation Hub', 'Tech Demo', 'Experiment Time',
            'School Days', 'University Life', 'Graduation Day', 'Study Group', 'Campus Tour',
            'Wedding Bliss', 'Anniversary Celebration', 'Engagement Party', 'Romantic Dinner', 'Date Night',
            'Friendship Bond', 'Group Hug', 'Team Building', 'Community Event', 'Social Gathering',
            'Nature Walk', 'Botanical Garden', 'Wildlife Reserve', 'National Park', 'Conservation Area',
            'Space View', 'Astronomy Night', 'Telescope View', 'Rocket Launch', 'Planet Discovery',
            'Abstract Art', 'Modern Design', 'Creative Expression', 'Art Installation', 'Color Splash',
            'Minimalist Style', 'Clean Design', 'Simple Beauty', 'Elegant Space', 'Modern Living',
            'Retro Vibes', 'Vintage Style', 'Classic Design', 'Old School', 'Timeless Beauty',
            'Futuristic Vision', 'Sci-Fi Scene', 'Digital Future', 'Tech Innovation', 'Space Age',
            'Cultural Heritage', 'Traditional Art', 'Historic Site', 'Ancient Ruins', 'Museum Artifact',
            'Festival Celebration', 'Cultural Event', 'Traditional Dance', 'Folk Art', 'Heritage Site',
            'Seasonal Beauty', 'Spring Bloom', 'Summer Heat', 'Autumn Fall', 'Winter Snow',
            'Weather Wonder', 'Storm Clouds', 'Rainbow Sky', 'Lightning Strike', 'Clear Blue Sky',
            'Time Lapse', 'Sunrise Magic', 'Sunset Glory', 'Day to Night', 'Night to Day',
            'Macro View', 'Close Up', 'Detail Shot', 'Texture Focus', 'Pattern Design',
            'Wide Angle', 'Panorama', 'Landscape View', 'Cityscape', 'Skyline Beauty',
            'Portrait Mode', 'Face Focus', 'Expression Capture', 'Mood Lighting', 'Character Study',
            'Action Shot', 'Motion Blur', 'Speed Capture', 'Dynamic Scene', 'Energy Flow',
            'Still Life', 'Product Shot', 'Food Photography', 'Object Study', 'Composition Art',
            'Black White', 'Monochrome', 'Sepia Tone', 'Vintage Filter', 'Artistic Effect',
            'Color Pop', 'Vibrant Hue', 'Pastel Dream', 'Neon Lights', 'Rainbow Colors',
            'Light Play', 'Shadow Dance', 'Golden Light', 'Blue Hour', 'Magic Hour',
            'Reflection Shot', 'Mirror Image', 'Water Mirror', 'Glass Reflection', 'Surface Shine',
            'Silhouette View', 'Backlight Beauty', 'Shadow Form', 'Outline Shape', 'Dark Profile',
            'Depth of Field', 'Bokeh Effect', 'Focus Blur', 'Selective Focus', 'Sharp Detail',
            'High Contrast', 'Dramatic Light', 'Bold Colors', 'Strong Shadows', 'Visual Impact',
            'Soft Focus', 'Gentle Light', 'Dreamy Effect', 'Hazy View', 'Misty Morning',
            'Crystal Clear', 'Sharp Focus', 'Perfect Detail', 'Clean Image', 'Pure Vision',
            'Artistic Blur', 'Creative Effect', 'Abstract Vision', 'Implied Motion', 'Dream State',
        ];

        foreach ($users as $user) {
            $imageCount = rand(20, 120);
            
            for ($i = 0; $i < $imageCount; $i++) {
                $titleIndex = array_rand($imageTitles);
                $title = $imageTitles[$titleIndex];
                $seed = strtolower(str_replace(' ', '', $user->name)) . '_' . $i;
                
                Image::create([
                    'title' => $title,
                    'description' => "Beautiful $title captured by {$user->name}. A stunning view that showcases the beauty of nature and art.",
                    'url' => "https://picsum.photos/seed/$seed/800/600",
                    'thumbnail_url' => "https://picsum.photos/seed/$seed/200/200",
                    'width' => 800,
                    'height' => 600,
                    'user_id' => $user->id,
                    'like_count' => rand(0, 500),
                    'comment_count' => rand(0, 50),
                    'is_active' => true,
                ]);
            }
        }
    }
}
