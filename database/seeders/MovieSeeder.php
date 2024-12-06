<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class MovieSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $json = file_get_contents(database_path('data/movies.json'));
        $movies = json_decode($json, true);
        foreach ($movies as $movie) {
            DB::table('movies')->insert([
                'title' => $movie['title'],
                'description' => $movie['description'],
                'image' => $movie['image'] ?? null, 
                'rating' => $movie['rating'] ?? null, 
                'genre' => json_encode($movie['genre']) ?? null, 
                'filmProducer' => $movie['filmProducer'] ?? null, 
            ]);
        }
    }
}
