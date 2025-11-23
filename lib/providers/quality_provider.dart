import 'package:flutter/material.dart';
import 'package:photo_editor/helper/qualities.dart';
import 'package:photo_editor/model/quality.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QualityProvider extends ChangeNotifier {
  static const String _qualityKey = 'export_quality';

  final List<Quality> _qualityOptions = Qualities().list();
  late Quality _exportQuality;

  List<Quality> get qualityOptions => _qualityOptions;
  Quality get exportQuality => _exportQuality;

  QualityProvider() {
    _exportQuality = _qualityOptions[2]; // тимчасово, поки не завантажиться
    _loadQuality();
  }

  // Завантажити збережену якість
  Future<void> _loadQuality() async {
    final prefs = await SharedPreferences.getInstance();
    final savedQualityValue = prefs.getInt(_qualityKey);

    if (savedQualityValue != null) {
      // Знайти Quality з відповідним значенням
      final quality = _qualityOptions.firstWhere(
            (q) => q.qualityValue == savedQualityValue,
        orElse: () => _qualityOptions[2], // за замовчуванням середня якість
      );
      _exportQuality = quality;
    } else {
      _exportQuality = _qualityOptions[2]; // за замовчуванням
    }

    notifyListeners();
  }

  // Зберегти якість
  Future<void> _saveQuality() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_qualityKey, _exportQuality.qualityValue);
  }

  void setExportQuality(Quality quality) {
    _exportQuality = quality;
    _saveQuality();
    notifyListeners();
  }
}