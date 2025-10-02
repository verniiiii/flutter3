import 'package:flutter/material.dart';
import '../models/recipe.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onTap;
  final VoidCallback? onFavoriteToggle;

  const RecipeCard({
    Key? key,
    required this.recipe,
    required this.onTap,
    this.onFavoriteToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Изображение
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    recipe.imageUrl,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Container(
                          height: 150,
                          color: Colors.grey[300],
                          child: Icon(Icons.fastfood, size: 50, color: Colors.grey[500]),
                        ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      recipe.category,
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.timer, size: 12, color: Colors.white),
                        SizedBox(width: 4),
                        Text(
                          '${recipe.cookingTime} мин',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Контент
            Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          recipe.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          recipe.isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: recipe.isFavorite ? Colors.red : Colors.grey,
                        ),
                        onPressed: onFavoriteToggle,
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    recipe.description,
                    style: TextStyle(color: Colors.grey[600]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: _getDifficultyColor(recipe.difficulty),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _getDifficultyText(recipe.difficulty),
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.people, size: 14, color: Colors.grey),
                      SizedBox(width: 4),
                      Text(
                        '${recipe.ingredients.length} ингредиентов',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getDifficultyColor(Difficulty difficulty) {
    switch (difficulty) {
      case Difficulty.easy:
        return Colors.green;
      case Difficulty.medium:
        return Colors.orange;
      case Difficulty.hard:
        return Colors.red;
    }
  }

  String _getDifficultyText(Difficulty difficulty) {
    switch (difficulty) {
      case Difficulty.easy:
        return 'Легко';
      case Difficulty.medium:
        return 'Средне';
      case Difficulty.hard:
        return 'Сложно';
    }
  }
}