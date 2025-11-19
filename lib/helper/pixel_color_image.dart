import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

class PixelColorImage {
  Future show(BuildContext context, {Color? backgroundColor, Uint8List? image, onPick}) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        Color tempColor = backgroundColor!;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Pick a color"),
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _ImageColorPicker(
                        imageBytes: image!,
                        onColorChanged: (color) {
                          setState(() {
                            tempColor = color;
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(
                          color: tempColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel")
                ),
                TextButton(
                  onPressed: () {
                    onPick(tempColor);
                    Navigator.of(context).pop();
                  },
                  child: const Text("Pick")
                ),
              ],
            );
          }
        );
      }
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
            Image.memory(
              widget.imageBytes,
              fit: BoxFit.contain,
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