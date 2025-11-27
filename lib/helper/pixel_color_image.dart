import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:photo_editor/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:photo_editor/constants/app_colors.dart';

class PixelColorImage {
  Future show(
    BuildContext context, {
    Color? backgroundColor,
    Uint8List? image,
    Function(Color)? onPick,
  }) {
    final isDark = Provider.of<ThemeProvider>(context, listen: false).isDarkTheme;

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        Color tempColor = backgroundColor!;
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[850] : Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Handle
                    Container(
                      width: 40,
                      height: 5,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey.shade700 : Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),

                    // Image picker
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.45,
                      child: ClipRRect(
                        child: _ImageColorPicker(
                          imageBytes: image!,
                          onColorChanged: (color) {
                            setState(() => tempColor = color);
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Color preview box
                    Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        color: tempColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isDark ? Colors.white70 : Colors.black,
                          width: 2,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Buttons
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              "Cancel",
                              style: TextStyle(color: AppColors.textPrimary(isDark),),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              onPick?.call(tempColor);
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Pick",
                              style: TextStyle(color: AppColors.textPrimary(isDark),),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

}

class _ImageColorPicker extends StatefulWidget {
  final Uint8List imageBytes;
  final ValueChanged<Color> onColorChanged;

  const _ImageColorPicker({
    required this.imageBytes,
    required this.onColorChanged,
  });

  @override
  State<_ImageColorPicker> createState() => _ImageColorPickerState();
}

class _ImageColorPickerState extends State<_ImageColorPicker> {
  img.Image? _decodedImage;
  Offset? _touchPosition;
  Size? _imageSize;

  @override
  void initState() {
    super.initState();
    _decodeImage();
  }

  Future<void> _decodeImage() async {
    final decoded = img.decodeImage(widget.imageBytes);
    if (mounted) {
      setState(() {
        _decodedImage = decoded;
      });
    }
  }

  Color? _getPixelColor(Offset localPosition, Size displaySize) {
    if (_decodedImage == null) return null;

    final x = (localPosition.dx * _decodedImage!.width / displaySize.width).toInt().clamp(0, _decodedImage!.width - 1);
    final y = (localPosition.dy * _decodedImage!.height / displaySize.height).toInt().clamp(0, _decodedImage!.height - 1);

    final pixel = _decodedImage!.getPixel(x, y);
    
    return Color.fromARGB(
      255,
      pixel.r.toInt(),
      pixel.g.toInt(),
      pixel.b.toInt(),
    );
  }

  void _handleTouch(Offset localPosition, Size size) {
    final color = _getPixelColor(localPosition, size);
    if (color != null) {
      setState(() {
        _touchPosition = localPosition;
        _imageSize = size;
      });
      widget.onColorChanged(color);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_decodedImage == null) {
      return const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: GestureDetector(
        onPanStart: (details) {
          final box = context.findRenderObject() as RenderBox;
          _handleTouch(details.localPosition, box.size);
        },
        onPanUpdate: (details) {
          final box = context.findRenderObject() as RenderBox;
          _handleTouch(details.localPosition, box.size);
        },
        onTapDown: (details) {
          final box = context.findRenderObject() as RenderBox;
          _handleTouch(details.localPosition, box.size);
        },
        child: Stack(
          children: [
            Center(
              child: FittedBox(
                fit: BoxFit.contain,
                child: Image.memory(widget.imageBytes),
              ),
            ),
            if (_touchPosition != null)
              Positioned(
                left: _touchPosition!.dx - 15,
                top: _touchPosition!.dy - 15,
                child: IgnorePointer(
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.5),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}