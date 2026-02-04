<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('images', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->string('title');
            $table->text('description')->nullable();
            $table->string('url');
            $table->string('thumbnail_url')->nullable();
            $table->integer('width')->nullable();
            $table->integer('height')->nullable();
            $table->integer('like_count')->default(0);
            $table->integer('comment_count')->default(0);
            $table->boolean('is_active')->default(true);
            $table->timestamps();

            $table->index(['user_id', 'is_active']);
            $table->index('like_count');
            $table->index('created_at');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('images');
    }
};
