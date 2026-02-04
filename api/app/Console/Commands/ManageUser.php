<?php

namespace App\Console\Commands;

use App\Models\User;
use Illuminate\Console\Command;

class ManageUser extends Command
{
    protected $signature = 'admin:manage-user {email} {--activate : Activate user} {--deactivate : Deactivate user} {--make-admin : Make user admin} {--remove-admin : Remove admin status}';
    protected $description = 'Manage user status and admin privileges';

    public function handle()
    {
        $email = $this->argument('email');
        $user = User::where('email', $email)->first();

        if (!$user) {
            $this->error("User with email '{$email}' not found.");
            return 1;
        }

        $changes = [];

        if ($this->option('activate') && $this->option('deactivate')) {
            $this->error('Cannot use --activate and --deactivate together.');
            return 1;
        }

        if ($this->option('make-admin') && $this->option('remove-admin')) {
            $this->error('Cannot use --make-admin and --remove-admin together.');
            return 1;
        }

        if ($this->option('activate')) {
            $user->is_active = true;
            $changes[] = 'Activated';
        }

        if ($this->option('deactivate')) {
            $user->is_active = false;
            $changes[] = 'Deactivated';
        }

        if ($this->option('make-admin')) {
            $user->is_admin = true;
            $changes[] = 'Made admin';
        }

        if ($this->option('remove-admin')) {
            $user->is_admin = false;
            $changes[] = 'Removed admin status';
        }

        if (empty($changes)) {
            $this->info('No changes specified. Use --help to see available options.');
            $this->info("Current user status:");
            $this->info("  Name: {$user->name}");
            $this->info("  Email: {$user->email}");
            $this->info("  Admin: " . ($user->is_admin ? 'Yes' : 'No'));
            $this->info("  Active: " . ($user->is_active ? 'Yes' : 'No'));
            return 0;
        }

        $user->save();

        $this->info("User '{$email}' updated successfully:");
        foreach ($changes as $change) {
            $this->info("  - {$change}");
        }

        $this->info("\nUpdated user status:");
        $this->info("  Name: {$user->name}");
        $this->info("  Email: {$user->email}");
        $this->info("  Admin: " . ($user->is_admin ? 'Yes' : 'No'));
        $this->info("  Active: " . ($user->is_active ? 'Yes' : 'No'));

        return 0;
    }
}
