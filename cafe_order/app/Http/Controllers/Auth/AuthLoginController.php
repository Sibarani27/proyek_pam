<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;

class AuthLoginController extends Controller
{
    public function login(Request $request)
    {
        $user = User::where('email', $request->email)->first();

        if (!$user || !Hash::check($request->password, $user->password)) {
            return response()->json(['message' => 'Email atau password salah'], 401);
        }

        // regenerate token
        $user->api_token = bin2hex(random_bytes(40));
        $user->save();

        return response()->json([
            'message' => 'Login berhasil',
            'token' => $user->api_token,
        ]);
    }
}

