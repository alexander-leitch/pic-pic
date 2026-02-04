<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\ImageController;
use App\Http\Controllers\CommentController;

// Public routes
Route::get('/images', [ImageController::class, 'index']);
Route::get('/images/{id}', [ImageController::class, 'show']);
Route::get('/images/{imageId}/comments', [CommentController::class, 'index']);
Route::get('/users/{userId}/images', [ImageController::class, 'userImages']);

// SSO Authentication routes
Route::get('/auth/redirect', [AuthController::class, 'redirectToProvider']);
Route::get('/auth/callback', [AuthController::class, 'handleProviderCallback']);

// Protected routes
Route::middleware('auth:sanctum')->group(function () {
    // User management
    Route::get('/user', [AuthController::class, 'user']);
    Route::post('/logout', [AuthController::class, 'logout']);
    
    // Image management
    Route::post('/images', [ImageController::class, 'store']);
    Route::post('/images/{id}/like', [ImageController::class, 'like']);
    Route::delete('/images/{id}/like', [ImageController::class, 'unlike']);
    
    // Comment management
    Route::post('/images/{imageId}/comments', [CommentController::class, 'store']);
    Route::delete('/comments/{id}', [CommentController::class, 'destroy']);
});

// Admin routes
Route::middleware(['auth:sanctum', 'admin'])->group(function () {
    Route::get('/admin/users', function () {
        return response()->json(User::all());
    });
    
    Route::delete('/admin/users/{id}', function ($id) {
        $user = User::findOrFail($id);
        $user->delete();
        return response()->json(['message' => 'User deleted successfully']);
    });
});
