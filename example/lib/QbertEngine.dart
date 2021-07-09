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
  RichText titleWidget;

  QbertView(String title, this.qbertEngine) : super(title);

  @override
  Widget getEndOfGamePageContent(BuildContext context) {
    return Column(children: [
      Padding(padding: EdgeInsets.fromLTRB(0, 300, 0, 100), child: Text('You won!', textScaleFactor: 0.75, style: TextStyle(fontFamily: 'Press Start', color: Colors.green, decorationColor: Colors.black))),
      Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 20), child: Text('Time: ${(qbertEngine.tickCounter / 60).round()}', textScaleFactor: 0.3, style: TextStyle(fontFamily: 'Press Start', color: Colors.blue, decorationColor: Colors.black),),),
      Align(alignment: Alignment.center, child: ElevatedButton(child: Text('Back to Menu'), onPressed: () {qbertEngine.state = GameState.waitForStart;},)),
    ],);
  }

  @override
  Widget getRunningPageContent(BuildContext context, var game) {
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
    return ChangeNotifierProvider<Engine>.value(
        value: qbertEngine,
        child: Scaffold(
            backgroundColor: Colors.black,
            body: Center(
                child: Column(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.fromLTRB(0, 300, 0, 100), child: Text('Q*bert', textScaleFactor: 3, style: TextStyle(color: Colors.deepOrange, fontFamily: 'Press Start')),
                      ),
                      ElevatedButton(
                          style: ButtonStyle(fixedSize: MaterialStateProperty.all(Size(200, 30))),
                          child: Text('Start normal game'),
                          onPressed: () {
                            qbertEngine.startGame(4); }
                      ),
                      ElevatedButton(
                          style: ButtonStyle(fixedSize: MaterialStateProperty.all(Size(200, 30))),
                          child: Text('XL game (coming soon)'),
                          onPressed: () {
                            print('Coming soon');
                          }
                            //qbertEngine.startGame(6); }
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
            checkIfWon(engine);
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

  void checkIfWon(QbertEngine engine) {
    bool won = true;
    board.getFieldList().forEach((element) {
      if (!element.isActivated()) {
        won = false;
      }
    });
    if (won) {
      engine.state = GameState.endOfGame;
    }
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