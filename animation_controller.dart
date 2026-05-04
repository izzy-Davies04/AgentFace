import 'dart:math';
import 'package:flutter/material.dart';
import '../models/animal_config.dart';

enum FaceState {
  idle,
  talking,
  thinking,
  happy,
  surprised,
  sleeping,
  listening,
  blinking,
}

class AgentAnimationController extends ChangeNotifier {
  FaceState _state = FaceState.idle;
  AnimalConfig _animal;
  double _blinkProgress = 0.0;
  double _mouthOpenness = 0.0;
  double _earWiggle = 0.0;
  double _headBobOffset = 0.0;
  double _pupilX = 0.0;
  double _pupilY = 0.0;
  bool _isTyping = false;
  String _statusText = '';

  final Random _random = Random();

  AgentAnimationController(this._animal);

  FaceState get state => _state;
  AnimalConfig get animal => _animal;
  double get blinkProgress => _blinkProgress;
  double get mouthOpenness => _mouthOpenness;
  double get earWiggle => _earWiggle;
  double get headBobOffset => _headBobOffset;
  double get pupilX => _pupilX;
  double get pupilY => _pupilY;
  bool get isTyping => _isTyping;
  String get statusText => _statusText;

  void setAnimal(AnimalConfig animal) {
    _animal = animal;
    _state = FaceState.idle;
    notifyListeners();
  }

  void setState(FaceState newState) {
    _state = newState;
    notifyListeners();
  }

  void setBlinkProgress(double v) {
    _blinkProgress = v;
    notifyListeners();
  }

  void setMouthOpenness(double v) {
    _mouthOpenness = v;
    notifyListeners();
  }

  void setEarWiggle(double v) {
    _earWiggle = v;
    notifyListeners();
  }

  void setHeadBob(double v) {
    _headBobOffset = v;
    notifyListeners();
  }

  void setPupil(double x, double y) {
    _pupilX = x;
    _pupilY = y;
    notifyListeners();
  }

  void setTyping(bool v) {
    _isTyping = v;
    notifyListeners();
  }

  void setStatus(String text) {
    _statusText = text;
    notifyListeners();
  }

  void randomGlance() {
    final angle = _random.nextDouble() * 2 * pi;
    _pupilX = cos(angle) * 3.0;
    _pupilY = sin(angle) * 2.0;
    notifyListeners();
  }

  void centerPupil() {
    _pupilX = 0;
    _pupilY = 0;
    notifyListeners();
  }
}
