import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main(){
    runApp(MyApp());
}

class MyApp extends StatelessWidget{
    const MyApp({super.key});

    @override
  Widget build(BuildContext context) {
      return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Name App',
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.tealAccent),
        ),
        home: MyHomePage(),
      ),

      );
  }
}

class MyAppState extends ChangeNotifier{
    var current = "${WordPair.random()} ${WordPair.random()}";
    var favorites = <String>[];

    void getNext(){
        current = "${WordPair.random()} ${WordPair.random()}";
        notifyListeners();
    }

    void toggleFavorite(){
        if (favorites.contains(current)){
            favorites.remove(current);
        } else {
            favorites.add(current);
        }
        notifyListeners();
    }

    void removeFavorite(String name){
        if (favorites.contains(name)){
            favorites.remove(name);
        }
        notifyListeners();
    }

    bool contain(String words){
        return favorites.contains(words);
    }
}

class MyHomePage extends StatefulWidget{
    @override
    State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
    var selectedIndex = 0;

    @override
    Widget build(BuildContext context) {
        Widget page;

        switch (selectedIndex){
            case 0 :
                page = GeneratorPage();
                break;
            case 1 :
                page = FavoritesPage();
                break;
            default:
                throw UnimplementedError(
                'selected index $selectedIndex had not yet been implement'
                );
        }

        return LayoutBuilder(builder: (context, constrains) {
            return Scaffold(
                body: Row(
                    children: [
                        SafeArea(
                            child: NavigationRail(
                                extended: constrains.maxWidth >= 500,
                                destinations: [
                                    NavigationRailDestination(
                                    icon: Icon(Icons.home),
                                    label: Text('Home')
                                    ),
                                    NavigationRailDestination(
                                        icon: Icon(Icons.favorite),
                                        label: Text('Favorites')
                                    )
                                ],
                                selectedIndex: selectedIndex,
                                onDestinationSelected: (value) {
                                    setState(() {
                                            selectedIndex = value;
                                        }
                                    );
                                },
                            ),
                        ),
                        Expanded(
                            child: Container(
                                color: Theme.of(context).colorScheme.primaryContainer,
                                child: page
                            )
                        ),
                    ]
                ),
              );
        });
    }
}

class GeneratorPage extends StatelessWidget {
  const GeneratorPage({super.key});

    @override
  Widget build(BuildContext context) {
      var appState = context.watch<MyAppState>();
      var current = appState.current;

      IconData icon;
      if (appState.contain(current)){
          icon = Icons.favorite;
      } else {
          icon = Icons.favorite_border_outlined;
      }

      return Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    Text('A random name idea:'),
                    BigCard(current: current),
                    SizedBox(height: 10),
                    Row(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 15,
                        children: [
                            ElevatedButton.icon(
                                onPressed: () {
                                    appState.toggleFavorite();
                                },
                                icon: Icon(icon),
                                label: Text("Favorite"),
                            ),
                            ElevatedButton(
                                onPressed: () {
                                    appState.getNext();
                                },
                                child: Text('Next'),
                                ),
                        ]
                        ),
                    ]
            ),
        ),
        backgroundColor: Colors.blueGrey
      );
  }
}

class FavoritesPage extends StatelessWidget{
    const FavoritesPage({super.key});

    @override
    Widget build(BuildContext context){
        var app_state = context.watch<MyAppState>();

        if (app_state.favorites.isEmpty){
            return Center(
                child: Text('There is no favorite name yet'),
            );
        }
        return ListView(
            children: [
                Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text('You have '
                        '${app_state.favorites.length} favorites: '
                    ),
                ),

                for (var name in app_state.favorites)
                    ListTile(
                        leading: IconButton(
                            onPressed: () => {
                                app_state.removeFavorite(name)
                            },
                            style: ButtonStyle(
                            ),
                            icon: Icon(Icons.favorite),
                        ),
                        title: Text('$name'),
                    ),
            ],
        );
    }
}

class BigCard extends StatelessWidget{
    const BigCard({super.key,
        required this.current});

    final String current;

    @override
  Widget build(BuildContext context) {
      final theme = Theme.of(context);
      final style = theme.textTheme.displayMedium!.copyWith(
        color: theme.colorScheme.onPrimary,
      );

      var name = current.split(' ');

      return Card(
        color: theme.colorScheme.inversePrimary,
        child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
                "${current.toLowerCase()}",
                style: style,
                semanticsLabel: "${name[0]} ${name[1]}",
            ),
        ),
      );
  }
}
