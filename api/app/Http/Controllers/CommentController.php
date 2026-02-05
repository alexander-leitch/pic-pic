<?php

namespace App\Http\Controllers;

use App\Models\Comment;
use App\Models\Image;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Auth;

class CommentController extends Controller
{
    public function index(Request $request, Image $image): JsonResponse
    {
        $page = $request->get('page', 1);
        $limit = $request->get('limit', 20);

        $comments = $image->comments()
                        ->with('user')
                        ->active()
                        ->latest()
                        ->paginate($limit, ['*'], 'page', $page);

        return response()->json($comments);
    }

    public function store(Request $request, Image $image): JsonResponse
    {
        $validated = $request->validate([
            'content' => 'required|string|max:1000',
        ]);

        $comment = Comment::create([
            ...$validated,
            'user_id' => Auth::id(),
            'image_id' => $image->id,
        ]);

        $image->increment('comment_count');

        return response()->json($comment->load('user'), 201);
    }

    public function update(Request $request, Comment $comment): JsonResponse
    {
        if ($comment->user_id !== Auth::id()) {
            return response()->json(['error' => 'Unauthorized'], 403);
        }

        $validated = $request->validate([
            'content' => 'required|string|max:1000',
        ]);

        $comment->update($validated);

        return response()->json($comment->load('user'));
    }

    public function destroy(Comment $comment): JsonResponse
    {
        if ($comment->user_id !== Auth::id()) {
            return response()->json(['error' => 'Unauthorized'], 403);
        }

        $image = $comment->image;
        $comment->delete();
        $image->decrement('comment_count');

        return response()->json(['message' => 'Comment deleted successfully']);
    }
}
