import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class AppImageProvider extends ChangeNotifier {
  Uint8List? _currentImage;

  final List<Uint8List> _images = [];
  int _index = 0;

  bool canUndo = true;
  bool canRedo = true;

  void changeImageFile(File image) {
    _add(image.readAsBytesSync());
  }

  void changeImage(Uint8List image) {
    _add(_currentImage = image);
  }

  Uint8List? get currentImage {
    return _images[_index];
  }

  void _add(Uint8List image){
    if(_images.isEmpty){
      _images.add(image);
    } else {
      int removeUntil = (_images.length-1) - _index;
      _images.length -= removeUntil;
      _images.add(image);
      _index++; 
    }
    _undoRedo();
    notifyListeners();
  }

  void undo() {
    if(_index > 0){
      _index--;
    }
    _undoRedo(); 
    notifyListeners();
  }

  void redo() {
    if(_index < (_images.length-1)){
      _index++;
    }
    _undoRedo();
    notifyListeners();
  }

  void _undoRedo(){
    canUndo = (_index != 0) ? true : false;
    canRedo = (_index < (_images.length-1)) ? true: false;
  }

}