import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:tiler/tiler.dart';
import 'package:tiler_example/SpriteLocations.dart';

import 'Actor.dart';
import 'Field.dart';
import 'QbertEngine.dart';

class TileMapWidget extends StatefulWidget {
  final String mapFile;
  final Offset offset;
  final double scaleFactor;
  final QbertEngine gameEngine;

  const TileMapWidget(this.mapFile, this.offset, this.scaleFactor, this.gameEngine);

  @override
  _TileMapWidgetState createState() => _TileMapWidgetState(mapFile, offset, scaleFactor, gameEngine);
}

class _TileMapWidgetState extends State<TileMapWidget> {
  String mapFile;
  Future<LoadedTileMap> tileMap;
  Offset offset = Offset(-200, 0);
  Stopwatch sw = Stopwatch()..start();
  double scaleFactor;
  QbertEngine gameEngine;
  ActorWidget actorWidget = new ActorWidget();
  EdgeInsets insets = EdgeInsets.fromLTRB(0, 0, 0, 0);

  _TileMapWidgetState(this.mapFile, this.offset, this.scaleFactor, this.gameEngine);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LoadedTileMap>(
      future: tileMap,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final loadedMap = snapshot.data;
          final map = loadedMap.map;
          return Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: TileMap(
                    loadedMap,
                    offset,
                    Size(
                      (map.width * map.tileWidth).toDouble() * scaleFactor,
                      (map.height * map.tileHeight).toDouble() * scaleFactor / 2,
                    ),
                    scale: scaleFactor,
                    elapsedMilliseconds: sw.elapsedMilliseconds,
                    debugMode: false,
                  ),
                ),
              //Image(image: AssetImage('assets/actor.png'), height: 40,)
                Padding(
                  padding: insets,
                  child: actorWidget,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(50, 50, 50, 50),
                  child: Column( children: [
                    ElevatedButton(child: Text('PRINT'),onPressed: () {print('tiles:'); print(loadedMap.map);}),

                    ElevatedButton(child: Text('MOVE DOWN LEFT'),onPressed: () {move(Directions.downLeft);}),
                    ElevatedButton(child: Text('MOVE DOWN RIGHT'),onPressed: () {move(Directions.downRight);}),
                    ElevatedButton(child: Text('MOVE UP LEFT'),onPressed: () {move(Directions.upLeft);}),
                    ElevatedButton(child: Text('MOVE UP RIGHT'),onPressed: () {move(Directions.upRight);}),
                  ]),
                ),
               ],
            );
        } else if (snapshot.hasError) {
          // TODO: ....
          return Text('ERROR LOADING MAP: ${snapshot.error}');
        }

        return const CircularProgressIndicator();
      },
    );
  }

  @override
  void initState() {
    super.initState();
    tileMap = loadMap(rootBundle, mapFile);
    updateActorLocation(0, 0);
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  void updateActorLocation(int x, int y) {
    insets = SpriteLocations[gameEngine.getGameLogic().getBoard().getFieldAt(x, y).getFieldName()];
    print('KEY:');
    print(SpriteLocations[gameEngine.getGameLogic().getBoard().getFieldAt(x, y).getFieldName()]);
  }

  void move(directions) {
    int x;
    int y;
    switch (directions) {

      case Directions.downRight: {
        x = actorWidget.getX() + 1;
        y = actorWidget.getY();
      }
      break;
      case Directions.downLeft: {
        x = actorWidget.getX();
        y = actorWidget.getY() + 1;
      }
      break;
      case Directions.upRight: {
        x = actorWidget.getX();
        y = actorWidget.getY() - 1;
      }
      break;
      case Directions.upLeft: {
        x = actorWidget.getX() - 1;
        y = actorWidget.getY();
      }
    }
      if (gameEngine.getGameLogic().checkMove(actorWidget, x, y, gameEngine)) {
        updateActorLocation(x, y);
      }
    }

  @override
  void deactivate() {
    super.deactivate();
    sw.stop();
  }
}

enum Directions {
  downRight,
  downLeft,
  upRight,
  upLeft
}
