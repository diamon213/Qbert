import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Game {
  final Engine gameEngine;
  final View gameView;

  Game(this.gameEngine, this.gameView);
}

enum GameState { waitForStart, running, endOfGame }



abstract class Engine extends ChangeNotifier {
  /// This function is called every 20 ms
  ///
  /// Do whatever you have to do here.
  /// If something changed, you should call forceRedraw()
  ///

  void updatePhysicsEngine(int tickCounter);

  /// Called whenever the game status changes
  void stateChanged(GameState oldState, GameState newState);

  GameState get state => _state;

  get tickCounter => _tickCounter;

  set state(GameState state) {
    if (_state == state) {
      return;
    }

    stateChanged(_state, state);
    _state = state;
    if (_state == GameState.running) {
      _startGameLoop();
    } else {
      _stopGameLoop();
    }
    forceRedraw();
  }

  void forceRedraw() {
    notifyListeners();
  }

  Timer _timer;
  int _tickCounter = 0;
  GameState _state;

  Engine() : this._state = GameState.waitForStart;

  void _startGameLoop() {
    _tickCounter = 0;
    _startTimer(16667);
    state = GameState.running;
  }

  void _stopGameLoop() {
    _timer?.cancel();
  }

  void _startTimer(int microseconds) {
    _stopGameLoop();
    _timer = Timer.periodic(Duration(microseconds: microseconds), (_) {
      _processTimeTick();
    });
  }

  void _processTimeTick() {
    ++_tickCounter;
    updatePhysicsEngine(_tickCounter);
  }
}




abstract class View extends StatelessWidget {
  final String title;
  var game;

  View(this.title);

  Widget getStartPageContent(BuildContext context);

  Widget getRunningPageContent(BuildContext context ,var game);

  Widget getEndOfGamePageContent(BuildContext context);

  @override
  Widget build(BuildContext context) {
    game = Provider.of<Engine>(context);
    return selectGamePageContent(context);
  }

  Widget selectGamePageContent(BuildContext context) {
    switch (game.state) {
      case GameState.running:
        return getRunningPageContent(context, game);
      case GameState.endOfGame:
        return getEndOfGamePageContent(context);
      case GameState.waitForStart:
        return getStartPageContent(context);
    }
  }
}