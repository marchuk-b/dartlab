import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class AppImageProvider extends ChangeNotifier {
  final List<Uint8List> _images = [];
  int _index = -1;

  bool canUndo = false;
  bool canRedo = false;

  void changeImageFile(File image) {
    _add(image.readAsBytesSync());
  }

  void changeImage(Uint8List image) {
    _add(image);
  }

  Uint8List? get currentImage {
    if (_images.isEmpty || _index < 0) return null;
    return _images[_index];
  }

  void _add(Uint8List image) {
    if (_images.isEmpty) {
      _images.add(image);
      _index = 0; // Встановлюємо індекс на 0 після додавання першого зображення
    } else {
      // Видаляємо все після поточного індексу
      if (_index < _images.length - 1) {
        _images.removeRange(_index + 1, _images.length);
      }
      _images.add(image);
      _index++;
    }
    _undoRedo();
    notifyListeners();
  }

  void undo() {
    if (_index > 0) {
      _index--;
      _undoRedo();
      notifyListeners();
    }
  }

  void redo() {
    if (_index < (_images.length - 1)) {
      _index++;
      _undoRedo();
      notifyListeners();
    }
  }

  void _undoRedo() {
    canUndo = _index > 0;
    canRedo = _index < (_images.length - 1);
  }

  void clearImage() {
    _images.clear();
    _index = -1;
    canUndo = false;
    canRedo = false;
    notifyListeners();
  }
}