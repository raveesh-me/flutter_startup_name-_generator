import 'package:flutter/material.dart';
import 'package:flutterstartupnamegenerator/src/favorites_screen.dart';
import 'package:flutterstartupnamegenerator/src/home_screen.dart';

main() {
  runApp(StartupNameGeneratorApp());
}

class StartupNameGeneratorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        HomeScreen.routeName: (_) => HomeScreen(),
        FavoritesScreen.routeName: (_) => FavoritesScreen(
              favoriteNames: ModalRoute.of(_).settings.arguments,
            ),
      },
      initialRoute: '/',
    );
  }
}
