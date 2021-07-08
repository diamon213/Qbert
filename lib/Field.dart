class Field {
  bool empty = true;
  bool activated = false;
  int reward = 10;
  int fieldX;
  int fieldY;
  String fieldName;

  Field(int x, int y) {
    this.fieldX = x;
    this.fieldY = y;
    this.fieldName = '${x}-${y}';
  }

  bool isPlayable() {
    return empty;
  }

  void activateField () {
    this.activated = true;
  }

  bool checkActivatet() {
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