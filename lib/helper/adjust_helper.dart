import 'dart:typed_data';
import 'package:image/image.dart' as img;

class ImageAdjustments {
  
  /// Швидке налаштування в окремому потоці
  static Future<Uint8List> applyAdjustments(
    Uint8List bytes, {
    double exposure = 0.0,
    double contrast = 0.0,
    double highlights = 0.0,
    double shadows = 0.0,
    double temperature = 0.0,
    double tint = 0.0,
    double saturation = 0.0,
    double sharpness = 0.0,
  }) async {
    final params = _AdjustmentParams(
      bytes: bytes,
      exposure: exposure,
      contrast: contrast,
      highlights: highlights,
      shadows: shadows,
      temperature: temperature,
      tint: tint,
      saturation: saturation,
      sharpness: sharpness,
    );
    
    return await Future(() => _processInIsolate(params));
  }
  
  static Uint8List _processInIsolate(_AdjustmentParams params) {
    var result = params.bytes;
    
    // Застосовуємо тільки ті параметри, що змінились
    if (params.exposure != 0.0) result = _adjustExposure(result, params.exposure);
    if (params.contrast != 0.0) result = _adjustContrast(result, params.contrast);
    if (params.highlights != 0.0) result = _adjustHighlights(result, params.highlights);
    if (params.shadows != 0.0) result = _adjustShadows(result, params.shadows);
    if (params.temperature != 0.0) result = _adjustTemperature(result, params.temperature);
    if (params.tint != 0.0) result = _adjustTint(result, params.tint);
    if (params.saturation != 0.0) result = _adjustSaturation(result, params.saturation);
    if (params.sharpness != 0.0) result = _adjustSharpness(result, params.sharpness);
    
    return result;
  }
  
  // Всі функції обробки (копія з попереднього файлу)
  
  static Uint8List _adjustExposure(Uint8List bytes, double exposure) {
    final image = img.decodeImage(bytes);
    if (image == null) return bytes;
    
    final adjustment = (exposure * 255).toInt();
    
    for (var pixel in image) {
      pixel
        ..r = _clamp(pixel.r.toInt() + adjustment)
        ..g = _clamp(pixel.g.toInt() + adjustment)
        ..b = _clamp(pixel.b.toInt() + adjustment);
    }
    
    return Uint8List.fromList(img.encodePng(image));
  }
  
  static Uint8List _adjustContrast(Uint8List bytes, double contrast) {
    final image = img.decodeImage(bytes);
    if (image == null) return bytes;
    
    final factor = (259 * (contrast * 255 + 255)) / (255 * (259 - contrast * 255));
    
    for (var pixel in image) {
      pixel
        ..r = _clamp((factor * (pixel.r.toInt() - 128) + 128).toInt())
        ..g = _clamp((factor * (pixel.g.toInt() - 128) + 128).toInt())
        ..b = _clamp((factor * (pixel.b.toInt() - 128) + 128).toInt());
    }
    
    return Uint8List.fromList(img.encodePng(image));
  }
  
  static Uint8List _adjustHighlights(Uint8List bytes, double amount) {
    final image = img.decodeImage(bytes);
    if (image == null) return bytes;
    
    for (var pixel in image) {
      final brightness = (pixel.r.toInt() + pixel.g.toInt() + pixel.b.toInt()) / 3;
      
      if (brightness > 128) {
        final factor = ((brightness - 128) / 127) * amount;
        pixel
          ..r = _clamp((pixel.r.toInt() + factor * 50).toInt())
          ..g = _clamp((pixel.g.toInt() + factor * 50).toInt())
          ..b = _clamp((pixel.b.toInt() + factor * 50).toInt());
      }
    }
    
    return Uint8List.fromList(img.encodePng(image));
  }
  
  static Uint8List _adjustShadows(Uint8List bytes, double amount) {
    final image = img.decodeImage(bytes);
    if (image == null) return bytes;
    
    for (var pixel in image) {
      final brightness = (pixel.r.toInt() + pixel.g.toInt() + pixel.b.toInt()) / 3;
      
      if (brightness < 128) {
        final factor = ((128 - brightness) / 128) * amount;
        pixel
          ..r = _clamp((pixel.r.toInt() + factor * 50).toInt())
          ..g = _clamp((pixel.g.toInt() + factor * 50).toInt())
          ..b = _clamp((pixel.b.toInt() + factor * 50).toInt());
      }
    }
    
    return Uint8List.fromList(img.encodePng(image));
  }
  
  static Uint8List _adjustTemperature(Uint8List bytes, double temperature) {
    final image = img.decodeImage(bytes);
    if (image == null) return bytes;
    
    final strength = (temperature * 30).toInt();
    
    for (var pixel in image) {
      if (temperature > 0) {
        pixel
          ..r = _clamp(pixel.r.toInt() + strength)
          ..b = _clamp(pixel.b.toInt() - strength);
      } else {
        pixel
          ..r = _clamp(pixel.r.toInt() + strength)
          ..b = _clamp(pixel.b.toInt() - strength);
      }
    }
    
    return Uint8List.fromList(img.encodePng(image));
  }
  
  static Uint8List _adjustTint(Uint8List bytes, double tint) {
    final image = img.decodeImage(bytes);
    if (image == null) return bytes;
    
    final strength = (tint * 30).toInt();
    
    for (var pixel in image) {
      if (tint > 0) {
        pixel.g = _clamp(pixel.g.toInt() + strength);
      } else {
        pixel
          ..r = _clamp(pixel.r.toInt() - strength)
          ..b = _clamp(pixel.b.toInt() - strength);
      }
    }
    
    return Uint8List.fromList(img.encodePng(image));
  }
  
  static Uint8List _adjustSaturation(Uint8List bytes, double saturation) {
    final image = img.decodeImage(bytes);
    if (image == null) return bytes;
    
    for (var pixel in image) {
      final gray = (pixel.r.toInt() * 0.299 + pixel.g.toInt() * 0.587 + pixel.b.toInt() * 0.114).toInt();
      final factor = saturation + 1;
      
      pixel
        ..r = _clamp((gray + factor * (pixel.r.toInt() - gray)).toInt())
        ..g = _clamp((gray + factor * (pixel.g.toInt() - gray)).toInt())
        ..b = _clamp((gray + factor * (pixel.b.toInt() - gray)).toInt());
    }
    
    return Uint8List.fromList(img.encodePng(image));
  }
  
  static Uint8List _adjustSharpness(Uint8List bytes, double amount) {
    final image = img.decodeImage(bytes);
    if (image == null) return bytes;
    
    final result = img.Image.from(image);
    
    for (int y = 1; y < image.height - 1; y++) {
      for (int x = 1; x < image.width - 1; x++) {
        final center = image.getPixel(x, y);
        final top = image.getPixel(x, y - 1);
        final bottom = image.getPixel(x, y + 1);
        final left = image.getPixel(x - 1, y);
        final right = image.getPixel(x + 1, y);
        
        final r = _clamp((center.r.toInt() * (1 + 4 * amount) - 
                         (top.r.toInt() + bottom.r.toInt() + left.r.toInt() + right.r.toInt()) * amount).toInt());
        final g = _clamp((center.g.toInt() * (1 + 4 * amount) - 
                         (top.g.toInt() + bottom.g.toInt() + left.g.toInt() + right.g.toInt()) * amount).toInt());
        final b = _clamp((center.b.toInt() * (1 + 4 * amount) - 
                         (top.b.toInt() + bottom.b.toInt() + left.b.toInt() + right.b.toInt()) * amount).toInt());
        
        result.setPixelRgb(x, y, r, g, b);
      }
    }
    
    return Uint8List.fromList(img.encodePng(result));
  }
  
  static int _clamp(int value) {
    return value.clamp(0, 255);
  }
}

class _AdjustmentParams {
  final Uint8List bytes;
  final double exposure;
  final double contrast;
  final double highlights;
  final double shadows;
  final double temperature;
  final double tint;
  final double saturation;
  final double sharpness;

  _AdjustmentParams({
    required this.bytes,
    required this.exposure,
    required this.contrast,
    required this.highlights,
    required this.shadows,
    required this.temperature,
    required this.tint,
    required this.saturation,
    required this.sharpness,
  });
}