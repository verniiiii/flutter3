import 'package:flutter/material.dart';
import 'screens/my_recipes_screen.dart';
import 'screens/search_recipes_screen.dart';
import 'screens/add_recipe_screen.dart';
import 'screens/favorite_recipes_screen.dart';

void main() {
  runApp(RecipeApp());
}

class RecipeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe Master',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        fontFamily: 'Roboto',
        appBarTheme: AppBarTheme(
          elevation: 0,
          centerTitle: true,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      home: MainNavigationScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  @override
  _MainNavigationScreenState createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    MyRecipesScreen(),
    SearchRecipesScreen(),
    AddRecipeScreen(),
    FavoriteRecipesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.deepOrange,
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book),
              label: 'Мои рецепты',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Поиск',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle),
              label: 'Добавить',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Избранное',
            ),
          ],
        ),
      ),
    );
  }
}