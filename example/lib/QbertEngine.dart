import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:tiler_example/Field.dart';
import 'package:tiler_example/SpriteLocations.dart';
import 'package:tiler_example/TileMapWidget.dart';

import 'Actor.dart';
import 'Board.dart';
import 'Game.dart';

class QbertEngine extends Engine {

  GameLogic gameLogic;

  @override
  void stateChanged(GameState oldState, GameState newState) {
    // TODO: implement stateChanged
  }

  @override
  void updatePhysicsEngine(int tickCounter) {
    // TODO: implement updatePhysicsEngine
    forceRedraw();
  }

  void startGame(int boardSize) {
    gameLogic = new GameLogic(boardSize, this);
    this.state = GameState.running;
  }

  void gameOver() {
    state = GameState.endOfGame;
  }

  GameLogic getGameLogic() {
    return gameLogic;
  }
}

class QbertView extends View {
  final QbertEngine qbertEngine;

  QbertView(String title, this.qbertEngine) : super(title);

  @override
  Widget getEndOfGamePageContent(BuildContext context) {
    // TODO: implement getEndOfGamePageContent
    throw UnimplementedError();
  }

  @override
  Widget getRunningPageContent(BuildContext context, var game) {
    // TODO: implement getRunningPageContent
    TileMapWidget tileMapWidget;
    if (qbertEngine.gameLogic.board.boardSize == 6) {
      tileMapWidget = new TileMapWidget('assets/qbert_xl.json', Offset(-200, 0), 0.89, qbertEngine);
    } else if (qbertEngine.gameLogic.board.boardSize == 4) {
      tileMapWidget = new TileMapWidget('assets/qbert.json', Offset(-195, 0), 1, qbertEngine);
    }
    return tileMapWidget;
  }

  @override
  Widget getStartPageContent(BuildContext context,) {
    // TODO: implement getStartPageContent
    return ChangeNotifierProvider<Engine>.value(
        value: qbertEngine,
        child: Scaffold(
            backgroundColor: Colors.green,
            appBar: AppBar(
              title: Text("Epic GAME"),
            ),
            body: Center(
                child: Column(
                    children: <Widget>[
                      MaterialButton(
                          child: Text('Normal'),
                          onPressed: () {
                            qbertEngine.startGame(4); }
                      ),
                      MaterialButton(
                          child: Text('XL'),
                          onPressed: () {
                            qbertEngine.startGame(6); }
                      ),
                      Text(
                          '${qbertEngine.tickCounter}'
                      ),
                    ]
                )
            )
        )
    );
  }
}


class GameLogic {
  Image sprite = new Image(image: AssetImage('assets/actor.png'));
  Board board;
  ActorWidget actor;
  var locations;

  bool checkMove(ActorWidget actor, int goalX, int goalY, QbertEngine engine) {
    Field current = board.getFieldAt(actor.getX(), actor.getY());

    print('Current Location: ${current.fieldX}-${current.fieldY}');
    print(goalX);
    print(goalY);
    print('TRUE/FALSE:');
    print(SpriteLocations.keys.contains('${goalX}-${goalY}'));
    if (SpriteLocations.keys.contains('${goalX}-${goalY}')) {
      Field goal = board.getFieldAt(goalX, goalY);
      if (board.getNeighbouringFieldsOf(current).contains(goal)) {
          if (goal.isPlayable()) {
            moveActor(actor, goal);
            goal.activateField();
            print('New Location: ${goalX}-${goalY}');
            return true;
          } else {
            engine.gameOver();
          }
        } else {
        print('INVALID MOVE');
      }
    }else {
      print('INVALID MOVE');
    }
    return false;
  }

  void moveActor(ActorWidget actor, Field field) {
      actor.setLocation(field.getFieldX(), field.getFieldY());
  }

  GameLogic(int boardSize, QbertEngine engine) {
    this.board = new Board(boardSize);
    this.locations = List.generate(boardSize + 1, (index) => List(boardSize + 1));
  }

  ActorWidget getActor() {
    return this.actor;
  }

  Board getBoard() {
    return this.board;
  }

  Image getSprite() {
    return this.sprite;
  }

  void setActor(ActorWidget actor) {
    this.actor = actor;
  }
}