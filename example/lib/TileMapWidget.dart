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
import 'FieldLocations.dart';
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
  ButtonStyle buttonStyle = ButtonStyle(fixedSize: MaterialStateProperty.all(Size(64, 64)));
  EdgeInsets controlPadding = EdgeInsets.fromLTRB(10, 10, 10, 10);


  _TileMapWidgetState(String mapFile, Offset offset, double scaleFactor, QbertEngine gameEngine) {
    this.mapFile = mapFile;
    this.offset = offset;
    this.scaleFactor = scaleFactor;
    this.gameEngine = gameEngine;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = List.empty(growable: true);
    for(Field field in gameEngine.getGameLogic().getBoard().getFieldList()) {
      widgets.add(
          Padding(
            padding: FieldLocations[field.fieldName],
            child: field.activatedImage
      ));
    }

    widgets.add(
      Padding(
        padding: insets,
        child: actorWidget,
      ),
    );
    widgets.add(
      Padding(
        padding: EdgeInsets.fromLTRB(125, 650, 0, 0),
        child: Row( children: [
          Column(children: [
            Padding(
                padding: controlPadding,
                child: ElevatedButton(style: buttonStyle, child: Image(image: AssetImage('assets/arrow_up_left.png')), onPressed: () {move(Directions.upLeft);}),
                ),
            Padding(
                padding: controlPadding,
                child: ElevatedButton(style: buttonStyle, child: Image(image: AssetImage('assets/arrow_down_left.png')), onPressed: () {move(Directions.downLeft);}),
                ),
          ],),
          Column(children: [
            Padding(
              padding: controlPadding,
              child: ElevatedButton(style: buttonStyle, child: Image(image: AssetImage('assets/arrow_up_right.png')), onPressed: () {move(Directions.upRight);}),
            ),
            Padding(
              padding: controlPadding,
              child: ElevatedButton(style: buttonStyle, child: Image(image: AssetImage('assets/arrow_down_right.png'),), onPressed: () {move(Directions.downRight);}),
            ),
          ],),
        ]),
      ),
    );
    widgets.add(
      Padding(
        padding: EdgeInsets.fromLTRB(30, 40, 0, 0),
        child: Text('Time: ${(gameEngine.tickCounter / 60).round()}', textScaleFactor: 0.5, style: TextStyle(decorationColor: Colors.black, color: Colors.blue, fontFamily: 'Press Button')),
      )
    );

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
                Stack(
                  children: widgets,
                )
              //Image(image: AssetImage('assets/actor.png'), height: 40,)
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
    actorWidget.setLocation(x, y);
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
