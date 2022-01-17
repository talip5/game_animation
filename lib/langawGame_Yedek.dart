import 'dart:math';
import 'dart:ui';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flutter/gestures.dart';
import 'package:game_animation/components/backyard.dart';
import 'package:game_animation/components/fly.dart';
import 'package:game_animation/components/house_fly.dart';
import 'package:game_animation/components/hungry.dart';
import 'package:game_animation/components/hungry-fly.dart';
import 'package:game_animation/components/drooler-fly.dart';
import 'package:game_animation/components/agila-fly.dart';
import 'package:game_animation/components/macho-fly.dart';
import 'package:game_animation/components/start-button.dart';
import 'package:game_animation/view.dart';
import 'package:game_animation/views/home-view.dart';
import 'package:game_animation/views/lost-view.dart';
import 'package:game_animation/controllers/spawner.dart';
import 'package:game_animation/components/credits-button.dart';
import 'package:game_animation/components/help-button.dart';
import 'package:game_animation/views/help-view.dart';
import 'package:game_animation/views/credits-view.dart';

class LangawGame extends Game with TapDetector{
  Size screenSize;
  double tileSize;
  Backyard background;
  Hungry _hungry;
  Fly _fly;
  List<Fly> flies;
  Random rnd;
  View activeView = View.home;
  HomeView homeView;
  StartButton startButton;
  LostView lostView;
  FlySpawner spawner;
  HelpButton helpButton;
  CreditsButton creditsButton;
  HelpView helpView;
  CreditsView creditsView;

  LangawGame() {
    initialize();
  }

  void initialize() async {
    flies = List<Fly>();
    rnd = Random();
    resize(await Flame.util.initialDimensions());

    background = Backyard(this);
    homeView = HomeView(this);
    startButton = StartButton(this);
    lostView = LostView(this);
    spawner = FlySpawner(this);
    helpButton = HelpButton(this);
    creditsButton = CreditsButton(this);
    helpView = HelpView(this);
    creditsView = CreditsView(this);
  }

  void spawnFly() {
    double x = rnd.nextDouble() * (screenSize.width - (tileSize * 2.025));
    double y = rnd.nextDouble() * (screenSize.height - (tileSize * 2.025));
    //_hungry=Hungry(this, x , y);
    //_fly=Fly(this, x, y);
    switch (rnd.nextInt(5)) {
      case 0:
        flies.add(HouseFly(this, x, y));
        break;
      case 1:
        flies.add(DroolerFly(this, x, y));
        break;
      case 2:
        flies.add(AgileFly(this, x, y));
        break;
      case 3:
        flies.add(MachoFly(this, x, y));
        break;
      case 4:
        flies.add(HungryFly(this, x, y));
        break;
    }
  }

  void render(Canvas canvas) {
    background.render(canvas);
    flies.forEach((Fly fly) => fly.render(canvas));

    if (activeView == View.home) homeView.render(canvas);
    if (activeView == View.lost) lostView.render(canvas);
    if (activeView == View.home || activeView == View.lost) {
      startButton.render(canvas);
      helpButton.render(canvas);
      creditsButton.render(canvas);
    }
    if (activeView == View.help) helpView.render(canvas);
    if (activeView == View.credits) creditsView.render(canvas);
  }

  void update(double t) {
    spawner.update(t);
    flies.forEach((Fly fly) => fly.update(t));
    flies.removeWhere((Fly fly) => fly.isOffScreen);

  }

  void resize(Size size) {
    screenSize = size;
    tileSize = screenSize.width / 9;
  }

  void onTapDown(TapDownDetails d) {
    bool isHandled = false;

    // dialog boxes
    if (!isHandled) {
      if (activeView == View.help || activeView == View.credits) {
        activeView = View.home;
        isHandled = true;
      }
    }

    // credits button
    if (!isHandled && creditsButton.rect.contains(d.globalPosition)) {
      if (activeView == View.home || activeView == View.lost) {
        creditsButton.onTapDown();
        isHandled = true;
      }
    }

    //start button
    if (!isHandled && startButton.rect.contains(d.globalPosition)) {
      print('start button');
      if (activeView == View.home || activeView == View.lost) {
        startButton.onTapDown();
        isHandled = true;
      }
    }

    //flies
    if (!isHandled) {
      bool didHitAFly = false;
      flies.forEach((Fly fly) {
        if (fly.flyRect.contains(d.globalPosition)) {
          fly.onTapDown();
          isHandled = true;
          didHitAFly = true;
        }
      });
      if (activeView == View.playing && !didHitAFly) {
        activeView = View.lost;
      }
    }
    // help button
    if (!isHandled && helpButton.rect.contains(d.globalPosition)) {
      if (activeView == View.home || activeView == View.lost) {
        helpButton.onTapDown();
        isHandled = true;
      }
    }

    // credits button
    if (!isHandled && creditsButton.rect.contains(d.globalPosition)) {
      if (activeView == View.home || activeView == View.lost) {
        creditsButton.onTapDown();
        isHandled = true;
      }
    }
  }
}