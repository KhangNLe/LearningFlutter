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
    var current = WordPair.random();
}

class MyHomePage extends StatelessWidget {
    @override
  Widget build(BuildContext context) {
      var appState = context.watch<MyAppState>();

      return Scaffold(
        body: Column(
            children: [
                Text('A random name idea:'),
                Text(appState.current.asLowerCase)
                    ]
        )
      );
  }
}


