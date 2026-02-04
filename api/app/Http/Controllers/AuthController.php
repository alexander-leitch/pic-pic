<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;
use Laravel\Socialite\Facades\Socialite;

class AuthController extends Controller
{
    public function redirectToProvider()
    {
        return Socialite::driver(config('sso.provider'))->redirect();
    }

    public function handleProviderCallback()
    {
        $ssoUser = Socialite::driver(config('sso.provider'))->user();
        
        $user = User::firstOrCreate([
            'email' => $ssoUser->getEmail(),
        ], [
            'name' => $ssoUser->getName(),
            'sso_provider' => config('sso.provider'),
            'sso_id' => $ssoUser->getId(),
            'avatar_url' => $ssoUser->getAvatar(),
            'email_verified_at' => now(),
        ]);

        $token = $user->createToken('picpic-token')->plainTextToken;

        return response()->json([
            'user' => $user,
            'token' => $token,
        ]);
    }

    public function user(Request $request)
    {
        return response()->json($request->user());
    }

    public function logout(Request $request)
    {
        $request->user()->currentAccessToken()->delete();
        
        return response()->json(['message' => 'Logged out successfully']);
    }
}
