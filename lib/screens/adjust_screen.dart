import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_editor/constants/app_colors.dart';
import 'package:photo_editor/helper/adjust_helper.dart';
import 'package:photo_editor/providers/app_image_provider.dart';
import 'package:photo_editor/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:image/image.dart' as img;

class AdjustScreen extends StatefulWidget {
  const AdjustScreen({super.key});

  @override
  State<AdjustScreen> createState() => _AdjustScreenState();
}

class _AdjustScreenState extends State<AdjustScreen> {
  late AppImageProvider imageProvider;
  Uint8List? _originalImage;
  Uint8List? _previewImage; // Зменшене зображення для preview
  Uint8List? _processedPreview;
  bool _isProcessing = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    imageProvider = Provider.of<AppImageProvider>(context, listen: false);
    _originalImage = imageProvider.currentImage;
    _initializePreview();
  }

  // Створити зменшене зображення для швидкого preview
  Future<void> _initializePreview() async {
    if (_originalImage == null) return;

    final original = img.decodeImage(_originalImage!);
    if (original == null) return;

    // Зменшити до 800px по довшій стороні
    final maxSize = 800;
    img.Image preview;
    
    if (original.width > maxSize || original.height > maxSize) {
      if (original.width > original.height) {
        preview = img.copyResize(original, width: maxSize);
      } else {
        preview = img.copyResize(original, height: maxSize);
      }
    } else {
      preview = original;
    }

    setState(() {
      _previewImage = Uint8List.fromList(img.encodeJpg(preview, quality: 85));
      _processedPreview = _previewImage;
    });
  }

  // Параметри налаштувань
  double _exposure = 0;
  double _contrast = 0;
  double _saturation = 0;
  double _highlights = 0;
  double _shadows = 0;
  double _temperature = 0;
  double _sharpness = 0;

  // Видимість слайдерів
  bool showExposure = true;
  bool showContrast = false;
  bool showSaturation = false;
  bool showHighlights = false;
  bool showShadows = false;
  bool showTemperature = false;
  bool showSharpness = false;

  void showSlider({exp, con, sat, high, shad, temp, sharp}) {
    setState(() {
      showExposure = exp ?? false;
      showContrast = con ?? false;
      showSaturation = sat ?? false;
      showHighlights = high ?? false;
      showShadows = shad ?? false;
      showTemperature = temp ?? false;
      showSharpness = sharp ?? false;
    });
  }

  // Швидкий preview на зменшеному зображенні
  Future<void> _applyPreview() async {
    if (_previewImage == null) return;
    
    setState(() => _isProcessing = true);

    try {
      final result = await ImageAdjustments.applyAdjustments(
        _previewImage!,
        exposure: _exposure,
        contrast: _contrast,
        saturation: _saturation,
        highlights: _highlights,
        shadows: _shadows,
        temperature: _temperature,
        sharpness: _sharpness,
      );

      setState(() {
        _processedPreview = result;
        _isProcessing = false;
      });
    } catch (e) {
      print('Error processing preview: $e');
      setState(() => _isProcessing = false);
    }
  }

  // Застосувати до оригіналу при збереженні
  Future<void> _applyToOriginal() async {
    if (_originalImage == null) return;

    setState(() => _isSaving = true);

    try {
      // Показуємо прогрес
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Processing full resolution...'),
              ],
            ),
          ),
        ),
      );

      // Обробляємо оригінал в повній якості
      final result = await ImageAdjustments.applyAdjustments(
        _originalImage!,
        exposure: _exposure,
        contrast: _contrast,
        saturation: _saturation,
        highlights: _highlights,
        shadows: _shadows,
        temperature: _temperature,
        sharpness: _sharpness,
      );

      if (!mounted) return;
      
      Navigator.of(context).pop(); // Закрити діалог прогресу
      imageProvider.changeImage(result);
      Navigator.of(context).pop(); // Закрити екран
      
    } catch (e) {
      print('Error processing original: $e');
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error processing image')),
        );
      }
    } finally {
      setState(() => _isSaving = false);
    }
  }

  void _resetAll() {
    setState(() {
      _exposure = 0;
      _contrast = 0;
      _saturation = 0;
      _highlights = 0;
      _shadows = 0;
      _temperature = 0;
      _sharpness = 0;
      _processedPreview = _previewImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkTheme;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        actions: [
          IconButton(
            onPressed: _isSaving ? null : _applyToOriginal,
            icon: const Icon(Icons.done),
          )
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: _processedPreview != null
                ? InteractiveViewer(
                    minScale: 0.5,
                    maxScale: 4.0,
                    boundaryMargin: const EdgeInsets.all(10),
                    panEnabled: true,
                    scaleEnabled: true,
                    child: Image.memory(_processedPreview!),
                  )
                : const CircularProgressIndicator(),
          ),
          if (_isProcessing)
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: AppColors.secondaryColor(isDark),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Visibility(
                          visible: showExposure,
                          child: _slider(
                            value: _exposure,
                            onChanged: (value) {
                              setState(() => _exposure = value);
                              _applyPreview();
                            },
                            onReset: () {
                              setState(() => _exposure = 0);
                              _applyPreview();
                            },
                          ),
                        ),
                        Visibility(
                          visible: showContrast,
                          child: _slider(
                            value: _contrast,
                            onChanged: (value) {
                              setState(() => _contrast = value);
                              _applyPreview();
                            },
                            onReset: () {
                              setState(() => _contrast = 0);
                              _applyPreview();
                            },
                          ),
                        ),
                        Visibility(
                          visible: showSaturation,
                          child: _slider(
                            value: _saturation,
                            onChanged: (value) {
                              setState(() => _saturation = value);
                              _applyPreview();
                            },
                            onReset: () {
                              setState(() => _saturation = 0);
                              _applyPreview();
                            },
                          ),
                        ),
                        Visibility(
                          visible: showHighlights,
                          child: _slider(
                            value: _highlights,
                            onChanged: (value) {
                              setState(() => _highlights = value);
                              _applyPreview();
                            },
                            onReset: () {
                              setState(() => _highlights = 0);
                              _applyPreview();
                            },
                          ),
                        ),
                        Visibility(
                          visible: showShadows,
                          child: _slider(
                            value: _shadows,
                            onChanged: (value) {
                              setState(() => _shadows = value);
                              _applyPreview();
                            },
                            onReset: () {
                              setState(() => _shadows = 0);
                              _applyPreview();
                            },
                          ),
                        ),
                        Visibility(
                          visible: showTemperature,
                          child: _slider(
                            value: _temperature,
                            onChanged: (value) {
                              setState(() => _temperature = value);
                              _applyPreview();
                            },
                            onReset: () {
                              setState(() => _temperature = 0);
                              _applyPreview();
                            },
                          ),
                        ),
                        Visibility(
                          visible: showSharpness,
                          child: _slider(
                            value: _sharpness,
                            min: 0,
                            max: 1,
                            onChanged: (value) {
                              setState(() => _sharpness = value);
                              _applyPreview();
                            },
                            onReset: () {
                              setState(() => _sharpness = 0);
                              _applyPreview();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: _resetAll,
                    child: Text(
                      "Reset all",
                      style: TextStyle(
                        color: AppColors.textPrimary(isDark),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 70 + MediaQuery.of(context).padding.bottom,
        color: AppColors.bottomBarColor(isDark),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _bottomBarItem(
                    Icons.brightness_6,
                    "Exposure",
                    color: showExposure ? AppColors.activeButton : null,
                    onPress: () => showSlider(exp: true),
                  ),
                  _bottomBarItem(
                    Icons.contrast,
                    "Contrast",
                    color: showContrast ? AppColors.activeButton : null,
                    onPress: () => showSlider(con: true),
                  ),
                  _bottomBarItem(
                    Icons.filter_tilt_shift,
                    "Saturation",
                    color: showSaturation ? AppColors.activeButton : null,
                    onPress: () => showSlider(sat: true),
                  ),
                  _bottomBarItem(
                    Icons.wb_sunny_outlined,
                    "Highlights",
                    color: showHighlights ? AppColors.activeButton : null,
                    onPress: () => showSlider(high: true),
                  ),
                  _bottomBarItem(
                    Icons.brightness_3,
                    "Shadows",
                    color: showShadows ? AppColors.activeButton : null,
                    onPress: () => showSlider(shad: true),
                  ),
                  _bottomBarItem(
                    Icons.thermostat,
                    "Temperature",
                    color: showTemperature ? AppColors.activeButton : null,
                    onPress: () => showSlider(temp: true),
                  ),
                  _bottomBarItem(
                    Icons.blur_off,
                    "Sharpness",
                    color: showSharpness ? AppColors.activeButton : null,
                    onPress: () => showSlider(sharp: true),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomBarItem(IconData icon, String title, {Color? color, required VoidCallback onPress}) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkTheme;

    return InkWell(
      onTap: onPress,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color ?? AppColors.iconColor(isDark),
            ),
            const SizedBox(height: 3),
            Text(
              title,
              style: TextStyle(
                color: color ?? AppColors.textSecondary(isDark),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _slider({
    required double value,
    required Function(double) onChanged,
    required VoidCallback onReset,
    double min = -1,
    double max = 1,
  }) {
    return GestureDetector(
      onDoubleTap: onReset,
      child: Slider(
        label: value.toStringAsFixed(2),
        value: value,
        onChanged: onChanged,
        max: max,
        min: min,
        activeColor: AppColors.activeSlider,
        thumbColor: AppColors.activeSlider,
        inactiveColor: Colors.black26,
      ),
    );
  }
}