<?php

namespace App\Http\Controllers;

use App\Models\Image;
use App\Models\Like;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;

class ImageController extends Controller
{
    public function index(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'page' => 'integer|min:1',
            'limit' => 'integer|min:1|max:100',
            'sort' => 'in:latest,popular,random',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $page = $request->get('page', 1);
        $limit = $request->get('limit', 20);
        $sort = $request->get('sort', 'latest');

        $query = Image::active()->with(['user']);

        switch ($sort) {
            case 'popular':
                $query->orderBy('like_count', 'desc');
                break;
            case 'random':
                $query->inRandomOrder();
                break;
            case 'latest':
            default:
                $query->latest();
                break;
        }

        $images = $query->paginate($limit, ['*'], 'page', $page);

        return response()->json($images);
    }

    public function show($id)
    {
        $image = Image::active()
            ->with(['user', 'comments' => function ($query) {
                $query->active()->with('user')->latest();
            }])
            ->findOrFail($id);

        if (Auth::check()) {
            $image['is_liked'] = $image->isLikedBy(Auth::user());
        }

        return response()->json($image);
    }

    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'title' => 'required|string|max:255',
            'description' => 'nullable|string|max:1000',
            'url' => 'required|url',
            'thumbnail_url' => 'nullable|url',
            'width' => 'nullable|integer|min:1',
            'height' => 'nullable|integer|min:1',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $image = Image::create([
            'user_id' => Auth::id(),
            'title' => $request->title,
            'description' => $request->description,
            'url' => $request->url,
            'thumbnail_url' => $request->thumbnail_url,
            'width' => $request->width,
            'height' => $request->height,
        ]);

        return response()->json($image, 201);
    }

    public function like($id)
    {
        $image = Image::active()->findOrFail($id);
        $user = Auth::user();

        if ($image->isLikedBy($user)) {
            return response()->json(['message' => 'Already liked'], 409);
        }

        $like = Like::create([
            'user_id' => $user->id,
            'image_id' => $image->id,
        ]);

        $image->incrementLikeCount();

        return response()->json([
            'message' => 'Image liked successfully',
            'like_count' => $image->fresh()->like_count,
        ]);
    }

    public function unlike($id)
    {
        $image = Image::active()->findOrFail($id);
        $user = Auth::user();

        $like = Like::where('user_id', $user->id)
            ->where('image_id', $image->id)
            ->first();

        if (!$like) {
            return response()->json(['message' => 'Not liked'], 404);
        }

        $like->delete();
        $image->decrementLikeCount();

        return response()->json([
            'message' => 'Image unliked successfully',
            'like_count' => $image->fresh()->like_count,
        ]);
    }

    public function userImages(Request $request, $userId)
    {
        $validator = Validator::make($request->all(), [
            'page' => 'integer|min:1',
            'limit' => 'integer|min:1|max:100',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $page = $request->get('page', 1);
        $limit = $request->get('limit', 20);

        $images = Image::active()
            ->where('user_id', $userId)
            ->with(['user'])
            ->latest()
            ->paginate($limit, ['*'], 'page', $page);

        return response()->json($images);
    }
}
