import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutterstartupnamegenerator/src/favorites_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  static final String routeName = '/';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

//Color getRandomColor() => );

class _HomeScreenState extends State<HomeScreen> {
  List<String> startupNames = [];
  Set<String> favoriteNames = Set<String>();
  bool isFetchingFromSP = true;
  final String savekey = 'favorites';
  ScrollController scrollController;

  SharedPreferences preferences;
  Color _heartColor;

  @override
  void initState() {
    super.initState();
    startupNames
        .addAll(List.generate(30, (index) => WordPair.random().asPascalCase));
    fetchSP();
    scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          _heartColor =
              Color(0xFFFF0000 + (scrollController.offset / scrollController.position.viewportDimension * 0x000000FF).floor());
        });
      });
  }

  fetchSP() async {
    setState(() {
      isFetchingFromSP = true;
    });
    preferences = await SharedPreferences.getInstance();
    List<String> savedFavorites = preferences.getStringList(savekey);
    if (savedFavorites == null) {
      preferences.setStringList(savekey, <String>[]);
      savedFavorites = <String>[];
    }
    favoriteNames.addAll(savedFavorites);
    startupNames = [...savedFavorites, ...startupNames];
    setState(() {
      isFetchingFromSP = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Strtp Nms'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              // navigate to the favorites screen
              Navigator.pushNamed(
                context,
                FavoritesScreen.routeName,
                arguments: favoriteNames,
              );
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          if (isFetchingFromSP) LinearProgressIndicator(),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemBuilder: (context, index) {
                if (index >= startupNames.length)
                  startupNames.addAll(List.generate(
                      20, (index) => WordPair.random().asPascalCase));
                final String startupName = startupNames[index];
                return Hero(
                  tag: startupName,
                  child: Card(
                    child: ListTile(
                      key: Key(startupName),
                      title: Text(startupName),
                      trailing: IconButton(
                        icon: favoriteNames.contains(startupName)
                            ? Icon(Icons.favorite)
                            : Icon(Icons.favorite_border),
                        color: favoriteNames.contains(startupName)
                            ? _heartColor
                            : Colors.black54,
                        onPressed: () {
                          // what happens when Icon is pressed
                          print('$startupName pressed');
                          setState(() {
                            favoriteNames.contains(startupName)
                                ? favoriteNames.remove(startupName)
                                : favoriteNames.add(startupName);
                            final Set favorites =
                                preferences.getStringList(savekey)?.toSet();
                            favorites.add(startupName);
                            preferences.setStringList(
                                savekey, favorites.toList());
                          });
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
