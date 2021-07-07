import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart' hide Image;
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:tiler/tiler.dart';

class TileMapWidget extends StatefulWidget {
  final String mapFile;
  final Offset offset;
  final double scaleFactor;

  const TileMapWidget(this.mapFile, this.offset, this.scaleFactor);

  @override
  _TileMapWidgetState createState() => _TileMapWidgetState(mapFile, offset, scaleFactor);
}

class _TileMapWidgetState extends State<TileMapWidget> {
  String mapFile;
  Future<LoadedTileMap> tileMap;
  Offset offset = Offset(-200, 0);
  Stopwatch sw = Stopwatch()..start();
  double scaleFactor;

  _TileMapWidgetState(this.mapFile, this.offset, this.scaleFactor);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LoadedTileMap>(
      future: tileMap,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final loadedMap = snapshot.data;
          final map = loadedMap.map;
          return Align(
            //padding: const EdgeInsets.all(60),
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
    //SystemChrome.setEnabledSystemUIOverlays([]);
  }

  @override
  void deactivate() {
    super.deactivate();
    sw.stop();
  }
}
