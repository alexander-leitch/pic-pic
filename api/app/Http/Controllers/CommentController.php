<?php

namespace App\Http\Controllers;

use App\Models\Comment;
use App\Models\Image;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;

class CommentController extends Controller
{
    public function index(Request $request, $imageId)
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

        $comments = Comment::active()
            ->where('image_id', $imageId)
            ->with(['user'])
            ->latest()
            ->paginate($limit, ['*'], 'page', $page);

        return response()->json($comments);
    }

    public function store(Request $request, $imageId)
    {
        $image = Image::active()->findOrFail($imageId);

        $validator = Validator::make($request->all(), [
            'content' => 'required|string|max:1000',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $comment = Comment::create([
            'user_id' => Auth::id(),
            'image_id' => $image->id,
            'content' => $request->content,
        ]);

        $image->incrementCommentCount();

        return response()->json($comment->load('user'), 201);
    }

    public function destroy($id)
    {
        $comment = Comment::findOrFail($id);

        if ($comment->user_id !== Auth::id() && !Auth::user()->isAdmin()) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $image = $comment->image;
        $comment->delete();
        $image->decrementCommentCount();

        return response()->json(['message' => 'Comment deleted successfully']);
    }
}
