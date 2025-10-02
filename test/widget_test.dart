import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:prac3/main.dart';

void main() {
  testWidgets('App starts successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(RecipeApp());

    // Verify that our app starts
    expect(find.byType(MainNavigationScreen), findsOneWidget);

    // Verify that bottom navigation is present
    expect(find.byType(BottomNavigationBar), findsOneWidget);

    // Verify that we have some recipe content
    expect(find.widgetWithText(AppBar, 'Мои рецепты'), findsOneWidget);
  });
}