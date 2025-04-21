import 'dart:async';

import 'package:flutter/material.dart';

final class SheetableController extends ChangeNotifier {
  final _heightController = StreamController<double>.broadcast();
  final _visibilityController = StreamController<bool>.broadcast();

  Stream<double> get heightStream => _heightController.stream;

  Stream<bool> get visibleStream => _visibilityController.stream;

  double _height = 100;
  bool _visible = false;

  double get height => _height;

  set height(double value) {
    if (_height != value) {
      _height = value;
      _heightController.add(value);
      _visibilityController.add(value > 0);
      notifyListeners();
    }
  }

  bool get visible => _visible;

  set visible(bool value) {
    if (_visible != value) {
      _visible = value;
      _visibilityController.add(value);
      notifyListeners();
    }
  }

  void show() => visible = true;

  void hide() => visible = false;

  @override
  void dispose() {
    _heightController.close();
    _visibilityController.close();
    super.dispose();
  }
}
