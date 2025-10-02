import 'package:flutter/material.dart';
import '../models/recipe.dart';

class AddRecipeScreen extends StatefulWidget {
  @override
  _AddRecipeScreenState createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _cookingTimeController = TextEditingController();
  final _categoryController = TextEditingController();
  final _imageUrlController = TextEditingController();

  Difficulty _selectedDifficulty = Difficulty.easy;
  final List<String> _ingredients = [];
  final List<String> _steps = [];
  final _ingredientController = TextEditingController();
  final _stepController = TextEditingController();

  final List<String> _categories = [
    'Завтраки',
    'Салаты',
    'Супы',
    'Основные блюда',
    'Десерты',
    'Напитки',
    'Закуски',
  ];

  void _addIngredient() {
    if (_ingredientController.text.trim().isNotEmpty) {
      setState(() {
        _ingredients.add(_ingredientController.text.trim());
        _ingredientController.clear();
      });
    }
  }

  void _removeIngredient(int index) {
    setState(() {
      _ingredients.removeAt(index);
    });
  }

  void _addStep() {
    if (_stepController.text.trim().isNotEmpty) {
      setState(() {
        _steps.add(_stepController.text.trim());
        _stepController.clear();
      });
    }
  }

  void _removeStep(int index) {
    setState(() {
      _steps.removeAt(index);
    });
  }

  void _saveRecipe() {
    if (_formKey.currentState!.validate() && _ingredients.isNotEmpty && _steps.isNotEmpty) {
      final newRecipe = Recipe(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        ingredients: List.from(_ingredients),
        steps: List.from(_steps),
        cookingTime: int.parse(_cookingTimeController.text),
        difficulty: _selectedDifficulty,
        category: _categoryController.text.trim(),
        imageUrl: _imageUrlController.text.trim().isEmpty
            ? 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400'
            : _imageUrlController.text.trim(),
        isFavorite: false,
        createdAt: DateTime.now(),
      );

      RecipeService.addRecipe(newRecipe);

      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Заполните все обязательные поля')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Добавить рецепт'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveRecipe,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildImageSection(),
              SizedBox(height: 20),
              _buildBasicInfoSection(),
              SizedBox(height: 20),
              _buildIngredientsSection(),
              SizedBox(height: 20),
              _buildStepsSection(),
              SizedBox(height: 30),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Изображение блюда', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        TextFormField(
          controller: _imageUrlController,
          decoration: InputDecoration(
            hintText: 'URL изображения (опционально)',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildBasicInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Основная информация', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 12),
        TextFormField(
          controller: _titleController,
          decoration: InputDecoration(
            labelText: 'Название рецепта *',
            border: OutlineInputBorder(),
          ),
          validator: (value) => value?.trim().isEmpty ?? true ? 'Введите название' : null,
        ),
        SizedBox(height: 12),
        TextFormField(
          controller: _descriptionController,
          maxLines: 3,
          decoration: InputDecoration(
            labelText: 'Описание *',
            border: OutlineInputBorder(),
          ),
          validator: (value) => value?.trim().isEmpty ?? true ? 'Введите описание' : null,
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _cookingTimeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Время (мин) *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value?.trim().isEmpty ?? true ? 'Введите время' : null,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: DropdownButtonFormField<Difficulty>(
                value: _selectedDifficulty,
                items: Difficulty.values.map((difficulty) => DropdownMenuItem(
                  value: difficulty,
                  child: Text(_getDifficultyText(difficulty)),
                )).toList(),
                onChanged: (value) => setState(() => _selectedDifficulty = value!),
                decoration: InputDecoration(
                  labelText: 'Сложность',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: _categories.first,
          items: _categories.map((category) => DropdownMenuItem(
            value: category,
            child: Text(category),
          )).toList(),
          onChanged: (value) => _categoryController.text = value!,
          decoration: InputDecoration(
            labelText: 'Категория *',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildIngredientsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Ингредиенты *', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        ..._ingredients.asMap().entries.map((entry) => ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.deepOrange,
            child: Text('${entry.key + 1}', style: TextStyle(color: Colors.white)),
          ),
          title: Text(entry.value),
          trailing: IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () => _removeIngredient(entry.key),
          ),
        )),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _ingredientController,
                decoration: InputDecoration(
                  hintText: 'Добавить ингредиент',
                  border: OutlineInputBorder(),
                ),
                onFieldSubmitted: (_) => _addIngredient(),
              ),
            ),
            SizedBox(width: 8),
            FloatingActionButton(
              onPressed: _addIngredient,
              mini: true,
              child: Icon(Icons.add),
            ),
          ],
        ),
        if (_ingredients.isEmpty) ...[
          SizedBox(height: 8),
          Text(
            'Добавьте хотя бы один ингредиент',
            style: TextStyle(color: Colors.red, fontSize: 12),
          ),
        ],
      ],
    );
  }

  Widget _buildStepsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Шаги приготовления *', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        ..._steps.asMap().entries.map((entry) => ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blue,
            child: Text('${entry.key + 1}', style: TextStyle(color: Colors.white)),
          ),
          title: Text(entry.value),
          trailing: IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () => _removeStep(entry.key),
          ),
        )),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _stepController,
                decoration: InputDecoration(
                  hintText: 'Добавить шаг приготовления',
                  border: OutlineInputBorder(),
                ),
                onFieldSubmitted: (_) => _addStep(),
              ),
            ),
            SizedBox(width: 8),
            FloatingActionButton(
              onPressed: _addStep,
              mini: true,
              child: Icon(Icons.add),
            ),
          ],
        ),
        if (_steps.isEmpty) ...[
          SizedBox(height: 8),
          Text(
            'Добавьте хотя бы один шаг',
            style: TextStyle(color: Colors.red, fontSize: 12),
          ),
        ],
      ],
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: _saveRecipe,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text('Сохранить рецепт', style: TextStyle(fontSize: 16)),
    );
  }

  String _getDifficultyText(Difficulty difficulty) {
    switch (difficulty) {
      case Difficulty.easy: return 'Легко';
      case Difficulty.medium: return 'Средне';
      case Difficulty.hard: return 'Сложно';
    }
  }
}