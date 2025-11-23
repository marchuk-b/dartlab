import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

class PlatformHelper {
  static bool get isMobile => !kIsWeb && (Platform.isAndroid || Platform.isIOS);
  static bool get isDesktop => !kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS);
  static bool get isCameraSupported => isMobile;
  static bool get isGallerySaveSupported => isMobile;
}