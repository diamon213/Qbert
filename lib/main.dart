import 'package:flutter/material.dart' hide Image;
import 'package:provider/provider.dart';
import 'package:qbert/QbertEngine.dart';
import 'TileMapWidget.dart';
import 'Game.dart';

void main() {
  var gameEngine = QbertEngine();
  var gameView = QbertView('Q*bert', gameEngine);
  var game = Game(gameEngine, gameView);

  runApp(MyApp(game));
}

class MyApp extends StatelessWidget {
  final Game game;

  MyApp(this.game);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Engine>.value(
        value: game.gameEngine,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: game.gameView.title,
          home: game.gameView,
        ));
  }
}
