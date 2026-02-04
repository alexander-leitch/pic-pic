<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;

class PopulateDatabase extends Command
{
    protected $signature = 'db:populate {--fresh : Drop all tables first}';
    protected $description = 'Populate database with sample users and images';

    public function handle()
    {
        if ($this->option('fresh')) {
            $this->info('Dropping all tables...');
            DB::statement('SET FOREIGN_KEY_CHECKS=0;');
            
            $tables = ['likes', 'comments', 'images', 'users'];
            foreach ($tables as $table) {
                DB::table($table)->truncate();
            }
            
            DB::statement('SET FOREIGN_KEY_CHECKS=1;');
            $this->info('All tables dropped.');
        }

        $this->info('Populating database with sample data...');

        // Run seeders
        $this->call('db:seed', ['--class' => 'UserSeeder']);
        $this->call('db:seed', ['--class' => 'ImageSeeder']);

        $this->info('Database populated successfully!');
        
        // Show statistics
        $userCount = DB::table('users')->count();
        $imageCount = DB::table('images')->count();
        $likeCount = DB::table('likes')->count();
        $commentCount = DB::table('comments')->count();

        $this->table(['Table', 'Count'], [
            ['Users', $userCount],
            ['Images', $imageCount],
            ['Likes', $likeCount],
            ['Comments', $commentCount],
        ]);

        return 0;
    }
}
