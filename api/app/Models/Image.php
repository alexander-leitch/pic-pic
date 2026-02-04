<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;

class Image extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'title',
        'description',
        'url',
        'thumbnail_url',
        'width',
        'height',
        'like_count',
        'comment_count',
        'is_active',
    ];

    protected $casts = [
        'width' => 'integer',
        'height' => 'integer',
        'like_count' => 'integer',
        'comment_count' => 'integer',
        'is_active' => 'boolean',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function likes(): HasMany
    {
        return $this->hasMany(Like::class);
    }

    public function comments(): HasMany
    {
        return $this->hasMany(Comment::class);
    }

    public function likedByUsers(): BelongsToMany
    {
        return $this->belongsToMany(User::class, 'likes');
    }

    public function isLikedBy(User $user): bool
    {
        return $this->likes()->where('user_id', $user->id)->exists();
    }

    public function incrementLikeCount(): void
    {
        $this->increment('like_count');
    }

    public function decrementLikeCount(): void
    {
        $this->decrement('like_count');
    }

    public function incrementCommentCount(): void
    {
        $this->increment('comment_count');
    }

    public function decrementCommentCount(): void
    {
        $this->decrement('comment_count');
    }

    public function scopeActive($query)
    {
        return $query->where('is_active', true);
    }

    public function scopeWithLikeCount($query)
    {
        return $query->withCount('likes');
    }

    public function scopeWithCommentCount($query)
    {
        return $query->withCount('comments');
    }
}
