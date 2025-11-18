<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Menu extends Model
{
    use HasFactory;

    protected $fillable = [
        'name', // Harus 'name', bukan 'nama'
        'description',
        'price',
        'image_url', // Harus 'image_url'
        // 'category', // Jika Anda menambahkan kolom ini
    ];
}