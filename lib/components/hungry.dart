import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:game_animation/langawGame.dart';

class Hungry{
  Sprite _spriteHungry1;
  Rect _spriteHungryRect1;

  Sprite _spriteHungry2;
  Rect _spriteHungryRect2;

  LangawGame game;
  Hungry(this.game,double x, double y) {
    _spriteHungry1 = Sprite('flies/hungry-fly-1.png');
    _spriteHungryRect1 = Rect.fromLTWH(x, y, game.tileSize * 2,game.tileSize * 2);

    _spriteHungry2 = Sprite('flies/hungry-fly-2.png');
    _spriteHungryRect2 = Rect.fromLTWH(x, y, game.tileSize * 2,game.tileSize * 2);
  }


  void render(Canvas c) {
    //bgSprite.renderRect(c,bgRect);
    _spriteHungry1.renderRect(c, _spriteHungryRect1);
    _spriteHungry2.renderRect(c, _spriteHungryRect2);
  }

  void update(double t) {}
}