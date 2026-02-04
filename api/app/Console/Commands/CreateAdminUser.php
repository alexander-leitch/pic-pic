<?php

namespace App\Console\Commands;

use App\Models\User;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;

class CreateAdminUser extends Command
{
    protected $signature = 'admin:create {email} {name} {--password=}';
    protected $description = 'Create a new admin user';

    public function handle()
    {
        $email = $this->argument('email');
        $name = $this->argument('name');
        $password = $this->option('password');

        $validator = Validator::make([
            'email' => $email,
            'name' => $name,
            'password' => $password,
        ], [
            'email' => 'required|email|unique:users,email',
            'name' => 'required|string|max:255',
            'password' => 'required|string|min:8',
        ]);

        if ($validator->fails()) {
            $this->error('Validation failed:');
            foreach ($validator->errors()->all() as $error) {
                $this->error("  - {$error}");
            }
            return 1;
        }

        $user = User::create([
            'name' => $name,
            'email' => $email,
            'password' => Hash::make($password),
            'is_admin' => true,
            'is_active' => true,
            'email_verified_at' => now(),
        ]);

        $this->info("Admin user created successfully!");
        $this->info("Email: {$user->email}");
        $this->info("Name: {$user->name}");
        $this->info("Admin: Yes");

        return 0;
    }
}
