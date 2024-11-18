<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Movie extends Model
{
    protected $table = 'movies';
    protected $fillable = ['title', 'description', 'image', 'rating', 'genre', 'filmProducer'];

    protected $casts = [
        'genre'=> 'array',
    ];

    public $timestamps = false;
}
