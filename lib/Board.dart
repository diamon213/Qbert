import 'Field.dart';

class Board {
  var fields;
  List<Field> fieldList = List.empty(growable: true);
  int boardSize;

  Board(int size) {
    this.boardSize = size;
    this.fields = List.generate(boardSize + 1, (index) => List(boardSize + 1));
    setupField();
  }

  void setupField() {
    int i = 0;
    int x = boardSize;
    int max = boardSize;

    //TODO fix horrible loop code (too lazy)
    while (i <= boardSize) {
      if (x >= 0) {
        fields[i][x] = new Field(i, x);
        fieldList.add(fields[i][x]);
        print('${i}-${x}');
        x--;
      } else {
        i++;
        max--;
        x = max;
      }
    }
  }

  List<Field> getNeighbouringFieldsOf(Field field) {
    List<Field> neighbours = List.empty(growable: true);
    int x = field.getFieldX();
    int y = field.getFieldY();

    if (x != 0) {
      neighbours.add(fields[x-1][y]);
    }
    if (y != 0) {
      neighbours.add(fields[x][y-1]);

    }
    if (x != boardSize) {
      neighbours.add(fields[x+1][y]);
    }
    if (y != boardSize) {
      neighbours.add(fields[x][y+1]);
    }
    print(neighbours);
    return neighbours;
}

  Field getFieldAt(int x, int y) {
    return fields[x][y];
  }

  Field getField(Field field) {
    return fields[field.getFieldX()][field.getFieldY()];
  }

  List<Field> getFieldList() {
    return fieldList;
  }
}