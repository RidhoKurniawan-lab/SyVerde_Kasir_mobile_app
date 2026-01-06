<?php

namespace App\Http\Controllers;

use App\Models\Category;
use Illuminate\Http\Request;

class CategoryController extends Controller
{
    public function getAll()
    {
        $categories = Category::all();
        return response()->json($categories);
    }

    public function getById(Category $category){

        if(!$category){
            return response()->json([
                'message' => 'Category not found'
            ], 404);
        }

        return response()->json($category);
    }

    public function insert(Request $request){
        $validate = $request->validate([
            'name' => 'required|string|max:50'
        ]);

        $category = Category::create($validate);

        $category->refresh();

        return response()->json($category, 201);
    }

    public function update(Request $request, Category $category){
         $validate = $request->validate([
            'name' => 'required|string|max:50'
        ]);

        $category->update($validate);

        $category->refresh();

        return response()->json($category);
    }

    public function delete(Category $category){

        if (!$category) {
            return response()->json([
                'message' => 'Category not find'
            ], 404);
        }

        $category->delete();

        return response()->json(['deleted' => true]);
    }
}
