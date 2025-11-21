import 'package:flutter/material.dart';
import 'package:photo_editor/helper/qualities.dart';
import 'package:photo_editor/model/quality.dart';

class QualityProvider extends ChangeNotifier {
  final List<Quality> _qualityOptions = Qualities().list();

  late Quality _exportQuality = _qualityOptions[2];

  List<Quality> get qualityOptions => _qualityOptions;
  Quality get exportQuality => _exportQuality;

  void setExportQuality(Quality quality) {
    _exportQuality = quality;
    notifyListeners();
  }
}
