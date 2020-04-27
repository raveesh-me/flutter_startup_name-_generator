import 'package:flutter/material.dart';

class FavoritesScreen extends StatelessWidget {
  static final String routeName = '/favorites';
  final Set<String> favoriteNames;

  const FavoritesScreen({Key key, @required this.favoriteNames})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(favoriteNames);
    return Scaffold(
      appBar: AppBar(
        title: Text('favorites'),
      ),
      body: favoriteNames.isEmpty
          ? Center(
              child: Text('No favorites so far'),
            )
          : ListView.builder(
              itemBuilder: (_, index) => Hero(
                tag: '${favoriteNames.toList()[index]}',
                child: Card(
                  child: ListTile(
                    title: Text(
                      favoriteNames.toList()[index],
                    ),
                    trailing: IconButton(
                        icon: Icon(Icons.favorite),
                        color: Colors.red,
                        onPressed: () {}),
                  ),
                ),
              ),
              itemCount: favoriteNames.length,
            ),
    );
  }
}
