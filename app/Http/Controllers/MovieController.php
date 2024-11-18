<?php

namespace App\Http\Controllers;

use App\Models\Movie;
use Illuminate\Http\Request;

class MovieController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $movies = Movie::all();
        return response()->json($movies, 201);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        try {
            $validatedData = $request->validate([
                'title' => 'required|string|max:255', 
                'description' => 'required|string',  
                'image' => 'nullable|string',       
                'rating' => 'nullable|numeric|min:0|max:5',
                'genre' => 'nullable|array',         
                'filmProducer' => 'nullable|string|max:255', 
            ]);
    
            $movie = Movie::create([
                'title' => $validatedData['title'],
                'description' => $validatedData['description'],
                'image' => $validatedData['image'] ?? null, 
                'rating' => $validatedData['rating'] ?? null,
                'genre' => $validatedData['genre'] ?? [],  
                'filmProducer' => $validatedData['filmProducer'] ?? null,
            ]);
    
            return response()->json($movie, 201);
    
        } catch (\Exception $e) {
            return response()->json(['error' => $e->getMessage()], 500);
        }
    }

    /**
     * Display the specified resource.
     */
    public function show(Movie $movie)
    {
        //
    }
    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id)
    {
        try {
            $movie = Movie::findOrFail($id);
    
            $movie->update([
                'title' => $request->input('title'),
                'description' => $request->input('description'),
                'rating' => $request->input('rating'),
                'filmProducer' => $request->input('filmProducer'),
                'genre' => $request->input('genre'), // Si es un arreglo, puedes gestionarlo así
            ]);
    
            return response()->json($movie);
        } catch (\Exception $e) {
            return response()->json(['error' => 'Error al actualizar la película'], 500);
        }
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy($id)
    {
        try {
            $movie = Movie::findOrFail($id); 
    
            $movie->delete();
    
            return response()->json(['message' => 'Película eliminada con éxito'], 200);
        } catch (\Exception $e) {
            return response()->json(['message' => 'Error al eliminar la película', 'error' => $e->getMessage()], 500);
        }
    }
}
