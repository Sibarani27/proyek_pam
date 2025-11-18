<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('menus', function (Blueprint $table) {
            $table->id();
            $table->string('name'); // Nama menu
            $table->text('description')->nullable(); // Deskripsi, bisa kosong
            $table->decimal('price', 8, 2); // Harga (misal: 999999.99) - PENTING: ini harus decimal!
            $table->string('image_url')->nullable(); // URL gambar menu
            // $table->string('category')->nullable(); // Jika Anda ingin kolom kategori
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('menus');
    }
};
