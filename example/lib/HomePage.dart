import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiler_example/TileMapWidget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void startGame() {

  }

  void restart() {
    startGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.green,
        appBar: AppBar(
          title: Text("Epic GAME"),
        ),
        body: Center(
          child: Column(
              children: <Widget>[
                MaterialButton(
                  child: Text('Mini'),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => TileMapWidget('assets/qbert.json', Offset(-195, 0), 1))); }
              ),
              MaterialButton(
                  child: Text('XL'),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => TileMapWidget('assets/qbert_xl.json', Offset(-200, 0), 0.89))); }
              )]
          )
        )
    );
  }
}