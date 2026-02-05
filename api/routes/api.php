<?php

use App\Http\Controllers\ImageController;
use App\Http\Controllers\CommentController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

// Public routes
Route::get('/images', [ImageController::class, 'index']);
Route::get('/images/{image}', [ImageController::class, 'show']);
Route::get('/images/{image}/comments', [CommentController::class, 'index']);
Route::get('/users/{userId}/images', [ImageController::class, 'userImages']);

// Protected routes (require authentication)
Route::middleware('auth:sanctum')->group(function () {
    // Image management
    Route::post('/images', [ImageController::class, 'store']);
    Route::post('/images/{image}/like', [ImageController::class, 'like']);
    Route::delete('/images/{image}/like', [ImageController::class, 'unlike']);
    
    // Comment management
    Route::post('/images/{image}/comments', [CommentController::class, 'store']);
    Route::put('/comments/{comment}', [CommentController::class, 'update']);
    Route::delete('/comments/{comment}', [CommentController::class, 'destroy']);
    
    // User routes
    Route::get('/user', function (Request $request) {
        return $request->user();
    });
});

// Health check
Route::get('/health', function () {
    return response()->json([
        'status' => 'ok',
        'timestamp' => now()->toISOString(),
        'version' => '1.0.0',
    ]);
});
