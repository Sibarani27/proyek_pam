<?php

namespace App\Http\Controllers;

use App\Models\Order;
use App\Models\Menu; // Perlu untuk mengambil harga menu
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB; // Untuk transaksi database

class OrderController extends Controller
{
    // Metode index untuk melihat semua order (opsional, mungkin hanya untuk admin)
    public function index()
    {
        // Load relasi orderItems dan menu di dalamnya untuk detail
        $orders = Order::with('orderItems.menu')->get();
        return response()->json($orders);
    }

    public function store(Request $request)
    {
        // 1. Validasi Input
        $request->validate([
            'menu_items' => 'required|array', // Harus berupa array dari item menu
            'menu_items.*.menu_id' => 'required|exists:menus,id', // Setiap item harus punya menu_id yang valid
            'menu_items.*.quantity' => 'required|integer|min:1', // Kuantitas harus integer > 0
        ]);

        // 2. Hitung total_amount secara aman dari database (penting!)
        $totalAmount = 0;
        $orderItemsData = [];

        foreach ($request->menu_items as $item) {
            $menuItem = Menu::find($item['menu_id']);
            if (!$menuItem) {
                return response()->json(['message' => 'Menu item not found: ' . $item['menu_id']], 404);
            }
            $itemPrice = $menuItem->price; // Ambil harga terbaru dari database
            $quantity = $item['quantity'];

            $totalAmount += ($itemPrice * $quantity);
            $orderItemsData[] = [
                'menu_id' => $menuItem->id,
                'quantity' => $quantity,
                'price_at_order' => $itemPrice, // Simpan harga saat order dibuat
            ];
        }

        // 3. Buat Order dan Order_Items dalam transaksi database
        try {
            DB::beginTransaction();

            $order = Order::create([
                // 'user_id' => auth()->id(), // Jika Anda menggunakan otentikasi
                'total_amount' => $totalAmount,
                'status' => 'pending',
            ]);

            // Asosiasikan OrderItems dengan Order yang baru dibuat
            foreach ($orderItemsData as $itemData) {
                $order->orderItems()->create($itemData);
            }

            DB::commit();

            // 4. Kembalikan respons JSON dengan data order yang baru
            // Load relasi orderItems dan menu di dalamnya untuk memberikan detail ke Flutter
            return response()->json($order->load('orderItems.menu'), 201); // 201 Created
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(['message' => 'Failed to create order', 'error' => $e->getMessage()], 500);
        }
    }

    public function show(Order $order)
    {
        // Load relasi orderItems dan menu di dalamnya untuk memberikan detail
        return response()->json($order->load('orderItems.menu'));
    }

    public function update(Request $request, Order $order)
    {
        $request->validate([
            'total_amount' => 'sometimes|numeric|min:0',
            'status' => 'sometimes|string|in:pending,preparing,ready,completed,cancelled',
        ]);
        $order->update($request->all());
        return response()->json($order->load('orderItems.menu'));
    }

    public function destroy(Order $order)
    {
        $order->delete();
        return response()->json(['message' => 'Deleted']);
    }
}