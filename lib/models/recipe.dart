class Recipe {
  final String id;
  final String title;
  final String description;
  final List<String> ingredients;
  final List<String> steps;
  final int cookingTime;
  final Difficulty difficulty;
  final String category;
  final String imageUrl;
  final bool isFavorite;
  final DateTime createdAt;

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.ingredients,
    required this.steps,
    required this.cookingTime,
    required this.difficulty,
    required this.category,
    required this.imageUrl,
    this.isFavorite = false,
    required this.createdAt,
  });

  Recipe copyWith({
    String? title,
    String? description,
    List<String>? ingredients,
    List<String>? steps,
    int? cookingTime,
    Difficulty? difficulty,
    String? category,
    String? imageUrl,
    bool? isFavorite,
  }) {
    return Recipe(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
      cookingTime: cookingTime ?? this.cookingTime,
      difficulty: difficulty ?? this.difficulty,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt,
    );
  }
}

enum Difficulty { easy, medium, hard }

class RecipeService {
  static List<Recipe> _recipes = [
    Recipe(
      id: '1',
      title: 'Паста Карбонара',
      description: 'Классическая итальянская паста с беконом и сыром',
      ingredients: [
        'Спагетти - 200г',
        'Бекон - 150г',
        'Яйца - 2 шт',
        'Пармезан - 50г',
        'Чеснок - 2 зубчика',
        'Сливки - 100мл',
        'Соль, перец по вкусу',
      ],
      steps: [
        'Отварить пасту в подсоленной воде согласно инструкции',
        'Обжарить бекон с чесноком до хрустящей корочки',
        'Взбить яйца с пармезаном и сливками',
        'Смешать горячую пасту с беконом и яичной смесью',
        'Подавать сразу же, посыпав дополнительным пармезаном',
      ],
      cookingTime: 20,
      difficulty: Difficulty.medium,
      category: 'Основные блюда',
      imageUrl: 'https://images.unsplash.com/photo-1621996346565-e3dbc353d2e5?w=400',
      isFavorite: true,
      createdAt: DateTime(2024, 1, 15),
    ),
    Recipe(
      id: '2',
      title: 'Салат Цезарь',
      description: 'Популярный салат с курицей и сухариками',
      ingredients: [
        'Куриное филе - 200г',
        'Помидоры черри - 100г',
        'Салат романо - 1 пучок',
        'Сухарики - 50г',
        'Пармезан - 30г',
        'Соус Цезарь - 3 ст.л.',
      ],
      steps: [
        'Обжарить куриное филе до готовности',
        'Нарезать салат и помидоры',
        'Смешать все ингредиенты в миске',
        'Заправить соусом и посыпать пармезаном',
      ],
      cookingTime: 15,
      difficulty: Difficulty.easy,
      category: 'Салаты',
      imageUrl: 'https://images.unsplash.com/photo-1546793665-c74683f339c1?w=400',
      isFavorite: false,
      createdAt: DateTime(2024, 1, 10),
    ),
  ];

  static List<Recipe> getRecipes() => _recipes;

  static void addRecipe(Recipe recipe) {
    _recipes.add(recipe);
  }

  static void updateRecipe(Recipe updatedRecipe) {
    final index = _recipes.indexWhere((r) => r.id == updatedRecipe.id);
    if (index != -1) {
      _recipes[index] = updatedRecipe;
    }
  }

  static void toggleFavorite(String recipeId) {
    final index = _recipes.indexWhere((r) => r.id == recipeId);
    if (index != -1) {
      _recipes[index] = _recipes[index].copyWith(
        isFavorite: !_recipes[index].isFavorite,
      );
    }
  }

  static List<Recipe> getFavoriteRecipes() {
    return _recipes.where((recipe) => recipe.isFavorite).toList();
  }

  static List<Recipe> searchRecipes(String query) {
    if (query.isEmpty) return _recipes;
    return _recipes.where((recipe) =>
    recipe.title.toLowerCase().contains(query.toLowerCase()) ||
        recipe.description.toLowerCase().contains(query.toLowerCase()) ||
        recipe.category.toLowerCase().contains(query.toLowerCase()) ||
        recipe.ingredients.any((ingredient) =>
            ingredient.toLowerCase().contains(query.toLowerCase())
        )
    ).toList();
  }
}