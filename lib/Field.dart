
import 'package:flutter/widgets.dart';

class Field {
  bool empty = true;
  bool activated = false;
  int reward = 10;
  int fieldX;
  int fieldY;
  String fieldName;
  AssetImage sprite = AssetImage('assets/blocks_100_activated.png');
  Image activatedImage;

  Field(int x, int y) {
    this.fieldX = x;
    this.fieldY = y;
    this.fieldName = '${x}-${y}';
    this.activatedImage = Image(image: sprite, height: 0, width: 0,);
  }

  bool isPlayable() {
    return empty;
  }

  void activateField () {
    this.activated = true;
    activatedImage = Image(image: sprite);
  }

  bool isActivated() {
    return activated;
  }

  int getReward() {
    return reward;
  }

  int getFieldX() {
    return fieldX;
  }

  int getFieldY() {
    return fieldY;
  }

  String getFieldName() {
    return fieldName;
  }
}
