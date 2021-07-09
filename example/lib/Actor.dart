import 'package:flutter/widgets.dart';

class ActorWidget extends StatelessWidget {
  Image sprite = Image(image: AssetImage('assets/actor.png'),);
  Offset offset = new Offset(0, 0);
  double size = 35;
  int locationX = 0;
  int locationY = 0;

  ActorWidget();

  Widget build(BuildContext context) {
    return new Align(
      alignment: Alignment(offset.dx, offset.dy),
      child: Container(
        width: size,
        height: size,
        child: new Image(image: sprite.image, fit: BoxFit.fitHeight,)
      ),
    );
  }
  /*update() {
    setState() {
      frame++;
      offset = Offset(offset.dx, offset.dy);
    }
  }*/
  void setLocation(int x, int y) {
    this.locationX = x;
    this.locationY = y;
  }

  int getX() {
    return locationX;
  }

  int getY() {
    return locationY;
  }
}

class ActorNotifier extends ChangeNotifier {
  ActorNotifier() {
    notifyListeners();
  }
}