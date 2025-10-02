import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../widgets/recipe_card.dart';
import 'edit_recipe_screen.dart';

class SearchRecipesScreen extends StatefulWidget {
  @override
  _SearchRecipesScreenState createState() => _SearchRecipesScreenState();
}

class _SearchRecipesScreenState extends State<SearchRecipesScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Recipe> _searchResults = [];
  List<Recipe> _allRecipes = [];

  @override
  void initState() {
    super.initState();
    _allRecipes = RecipeService.getRecipes();
    _searchResults = _allRecipes;
  }

  void _searchRecipes(String query) {
    setState(() {
      _searchResults = RecipeService.searchRecipes(query);
    });
  }

  void _toggleFavorite(String recipeId) {
    RecipeService.toggleFavorite(recipeId);
    _searchRecipes(_searchController.text);
  }

  void _navigateToEdit(Recipe recipe) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditRecipeScreen(recipe: recipe),
      ),
    );

    if (result == true) {
      _allRecipes = RecipeService.getRecipes();
      _searchRecipes(_searchController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Рецепт успешно обновлен!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Поиск рецептов'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Поисковая строка
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: _searchRecipes,
              decoration: InputDecoration(
                hintText: 'Поиск по названию, ингредиентам...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ),

          // Результаты поиска
          Expanded(
            child: _searchResults.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
                  SizedBox(height: 16),
                  Text(
                    'Рецепты не найдены',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Попробуйте изменить запрос',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ],
              ),
            )
                : ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final recipe = _searchResults[index];
                return RecipeCard(
                  recipe: recipe,
                  onTap: () => _navigateToEdit(recipe),
                  onFavoriteToggle: () => _toggleFavorite(recipe.id),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}