<?php

namespace App\Console\Commands;

use App\Models\User;
use Illuminate\Console\Command;

class ListUsers extends Command
{
    protected $signature = 'admin:users {--admin-only : Show only admin users} {--inactive : Show only inactive users}';
    protected $description = 'List all users with optional filters';

    public function handle()
    {
        $query = User::query();

        if ($this->option('admin-only')) {
            $query->where('is_admin', true);
        }

        if ($this->option('inactive')) {
            $query->where('is_active', false);
        }

        $users = $query->orderBy('created_at', 'desc')->get(['id', 'name', 'email', 'is_admin', 'is_active', 'created_at']);

        if ($users->isEmpty()) {
            $this->info('No users found matching the criteria.');
            return 0;
        }

        $this->info('Users:');
        $this->info(str_repeat('-', 80));
        $this->info(sprintf('%-5s %-25s %-30s %-8s %-8s %-20s', 
            'ID', 'Name', 'Email', 'Admin', 'Active', 'Created At'));
        $this->info(str_repeat('-', 80));

        foreach ($users as $user) {
            $this->info(sprintf('%-5d %-25s %-30s %-8s %-8s %-20s',
                $user->id,
                substr($user->name, 0, 24),
                substr($user->email, 0, 29),
                $user->is_admin ? 'Yes' : 'No',
                $user->is_active ? 'Yes' : 'No',
                $user->created_at->format('Y-m-d H:i')
            ));
        }

        $this->info(str_repeat('-', 80));
        $this->info("Total: {$users->count()} users");

        return 0;
    }
}
