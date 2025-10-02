import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../widgets/recipe_card.dart';
import 'edit_recipe_screen.dart';

class MyRecipesScreen extends StatefulWidget {
  @override
  _MyRecipesScreenState createState() => _MyRecipesScreenState();
}

class _MyRecipesScreenState extends State<MyRecipesScreen> {
  List<Recipe> _recipes = [];

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  void _loadRecipes() {
    setState(() {
      _recipes = RecipeService.getRecipes();
    });
  }

  void _toggleFavorite(String recipeId) {
    RecipeService.toggleFavorite(recipeId);
    _loadRecipes();
  }

  void _navigateToEdit(Recipe recipe) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditRecipeScreen(recipe: recipe),
      ),
    );

    if (result == true) {
      _loadRecipes();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Рецепт успешно обновлен!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Мои рецепты'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _recipes.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.menu_book, size: 80, color: Colors.grey[400]),
            SizedBox(height: 16),
            Text(
              'Пока нет рецептов',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            SizedBox(height: 8),
            Text(
              'Добавьте свой первый рецепт!',
              style: TextStyle(color: Colors.grey[500]),
            ),
          ],
        ),
      )
          : ListView.builder(
        itemCount: _recipes.length,
        itemBuilder: (context, index) {
          final recipe = _recipes[index];
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