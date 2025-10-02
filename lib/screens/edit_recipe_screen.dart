import 'package:flutter/material.dart';
import '../models/recipe.dart';

class EditRecipeScreen extends StatefulWidget {
  final Recipe recipe;

  const EditRecipeScreen({Key? key, required this.recipe}) : super(key: key);

  @override
  _EditRecipeScreenState createState() => _EditRecipeScreenState();
}

class _EditRecipeScreenState extends State<EditRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _cookingTimeController;
  late TextEditingController _categoryController;
  late TextEditingController _imageUrlController;

  late Difficulty _selectedDifficulty;
  late List<String> _ingredients;
  late List<String> _steps;
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

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.recipe.title);
    _descriptionController = TextEditingController(text: widget.recipe.description);
    _cookingTimeController = TextEditingController(text: widget.recipe.cookingTime.toString());
    _categoryController = TextEditingController(text: widget.recipe.category);
    _imageUrlController = TextEditingController(text: widget.recipe.imageUrl);
    _selectedDifficulty = widget.recipe.difficulty;
    _ingredients = List.from(widget.recipe.ingredients);
    _steps = List.from(widget.recipe.steps);
  }

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

  void _updateRecipe() {
    if (_formKey.currentState!.validate() && _ingredients.isNotEmpty && _steps.isNotEmpty) {
      final updatedRecipe = widget.recipe.copyWith(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        ingredients: List.from(_ingredients),
        steps: List.from(_steps),
        cookingTime: int.parse(_cookingTimeController.text),
        difficulty: _selectedDifficulty,
        category: _categoryController.text.trim(),
        imageUrl: _imageUrlController.text.trim(),
      );

      RecipeService.updateRecipe(updatedRecipe);
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
        title: Text('Редактировать рецепт'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _updateRecipe,
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
              _buildUpdateButton(),
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
            hintText: 'URL изображения',
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
          value: _categoryController.text,
          items: _categories.map((category) => DropdownMenuItem(
            value: category,
            child: Text(category),
          )).toList(),
          onChanged: (value) => setState(() => _categoryController.text = value!),
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

  Widget _buildUpdateButton() {
    return ElevatedButton(
      onPressed: _updateRecipe,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text('Обновить рецепт', style: TextStyle(fontSize: 16)),
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