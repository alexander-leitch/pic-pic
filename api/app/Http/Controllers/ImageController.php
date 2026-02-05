<?php

namespace App\Http\Controllers;

use App\Models\Image;
use App\Models\Like;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Auth;

class ImageController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $page = $request->get('page', 1);
        $limit = $request->get('limit', 20);
        $sort = $request->get('sort', 'latest');

        $query = Image::with('user')->active();

        if ($sort === 'latest') {
            $query->latest();
        } elseif ($sort === 'popular') {
            $query->popular();
        }

        $images = $query->paginate($limit, ['*'], 'page', $page);

        return response()->json($images);
    }

    public function show(Image $image): JsonResponse
    {
        $image->load(['user', 'comments.user']);
        
        return response()->json($image);
    }

    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'title' => 'required|string|max:255',
            'description' => 'nullable|string',
            'url' => 'required|url',
            'thumbnail_url' => 'nullable|url',
            'width' => 'nullable|integer',
            'height' => 'nullable|integer',
        ]);

        $image = Image::create([
            ...$validated,
            'user_id' => Auth::id(),
        ]);

        return response()->json($image, 201);
    }

    public function like(Image $image): JsonResponse
    {
        $user = Auth::user();
        
        if (!$user) {
            return response()->json(['error' => 'Unauthorized'], 401);
        }

        $existingLike = Like::where('user_id', $user->id)
                            ->where('image_id', $image->id)
                            ->first();

        if ($existingLike) {
            return response()->json(['error' => 'Already liked'], 422);
        }

        $like = Like::create([
            'user_id' => $user->id,
            'image_id' => $image->id,
        ]);

        $image->increment('like_count');

        return response()->json([
            'message' => 'Image liked successfully',
            'like_count' => $image->fresh()->like_count,
        ]);
    }

    public function unlike(Image $image): JsonResponse
    {
        $user = Auth::user();
        
        if (!$user) {
            return response()->json(['error' => 'Unauthorized'], 401);
        }

        $like = Like::where('user_id', $user->id)
                   ->where('image_id', $image->id)
                   ->first();

        if (!$like) {
            return response()->json(['error' => 'Not liked'], 422);
        }

        $like->delete();
        $image->decrement('like_count');

        return response()->json([
            'message' => 'Image unliked successfully',
            'like_count' => $image->fresh()->like_count,
        ]);
    }

    public function userImages(Request $request, int $userId): JsonResponse
    {
        $page = $request->get('page', 1);
        $limit = $request->get('limit', 20);

        $images = Image::with('user')
                       ->where('user_id', $userId)
                       ->active()
                       ->latest()
                       ->paginate($limit, ['*'], 'page', $page);

        return response()->json($images);
    }
}
