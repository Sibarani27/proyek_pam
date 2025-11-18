<?php

namespace App\Http\Controllers;

use App\Models\Menu;
use Illuminate\Http\Request;

class MenuController extends Controller
{
    public function index()
    {
        return response()->json(Menu::all()); // PENTING: Harus ada response()->json()
    }

    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'description' => 'nullable|string',
            'price' => 'required|numeric', // Validasi price sebagai numeric
            'image_url' => 'nullable|url',
        ]);
        $menu = Menu::create($request->all());
        return response()->json($menu, 201); // 201 Created
    }

    public function show(Menu $menu)
    {
        return response()->json($menu); // PENTING: Harus ada response()->json()
    }

    public function update(Request $request, Menu $menu)
    {
        $request->validate([
            'name' => 'sometimes|string|max:255',
            'description' => 'nullable|string',
            'price' => 'sometimes|numeric',
            'image_url' => 'nullable|url',
        ]);
        $menu->update($request->all());
        return response()->json($menu); // PENTING: Harus ada response()->json()
    }

    public function destroy(Menu $menu)
    {
        $menu->delete();
        return response()->json(['message' => 'Deleted']);
    }
}