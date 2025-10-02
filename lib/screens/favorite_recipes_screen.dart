import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../widgets/recipe_card.dart';
import 'edit_recipe_screen.dart';

class FavoriteRecipesScreen extends StatefulWidget {
  @override
  _FavoriteRecipesScreenState createState() => _FavoriteRecipesScreenState();
}

class _FavoriteRecipesScreenState extends State<FavoriteRecipesScreen> {
  List<Recipe> _favoriteRecipes = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() {
    setState(() {
      _favoriteRecipes = RecipeService.getFavoriteRecipes();
    });
  }

  void _toggleFavorite(String recipeId) {
    RecipeService.toggleFavorite(recipeId);
    _loadFavorites();
  }

  void _navigateToEdit(Recipe recipe) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditRecipeScreen(recipe: recipe),
      ),
    );

    if (result == true) {
      _loadFavorites();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Рецепт успешно обновлен!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Избранные рецепты'),
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _favoriteRecipes.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 80, color: Colors.grey[400]),
            SizedBox(height: 16),
            Text(
              'Нет избранных рецептов',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            SizedBox(height: 8),
            Text(
              'Добавляйте рецепты в избранное!',
              style: TextStyle(color: Colors.grey[500]),
            ),
          ],
        ),
      )
          : ListView.builder(
        itemCount: _favoriteRecipes.length,
        itemBuilder: (context, index) {
          final recipe = _favoriteRecipes[index];
          return RecipeCard(
            recipe: recipe,
            onTap: () => _navigateToEdit(recipe),
            onFavoriteToggle: () => _toggleFavorite(recipe.id),
          );
        },
      ),
    );
  }
}