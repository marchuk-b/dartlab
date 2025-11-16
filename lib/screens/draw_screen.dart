import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:painter/painter.dart';
import 'package:photo_editor/constants/app_colors.dart';
import 'package:photo_editor/helper/app_color_picker.dart';
import 'package:photo_editor/helper/pixel_color_image.dart';
import 'package:photo_editor/providers/app_image_provider.dart';
import 'package:photo_editor/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class DrawScreen extends StatefulWidget {
  const DrawScreen({super.key});

  @override
  State<DrawScreen> createState() => _DrawScreenState();
}

class _DrawScreenState extends State<DrawScreen> {
  late AppImageProvider imageProvider;
  ScreenshotController screenshotController = ScreenshotController();
  final PainterController _controller = PainterController();
  Uint8List? currentImage;

  @override
  void initState() {
    imageProvider = Provider.of<AppImageProvider>(context, listen: false);
    _controller.thickness = 5.0;
    _controller.backgroundColor = Colors.transparent;
    _controller.drawColor = Colors.black;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkTheme;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        // title: Text("Draw"),
        actions: [
          IconButton(
            onPressed: () async{
              Uint8List? bytes = await screenshotController.capture();
              imageProvider.changeImage(bytes!);
              if(!mounted) return;
              Navigator.of(context).pop();  
            }, 
            icon: const Icon(Icons.done)
          )
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: Consumer<AppImageProvider>(
              builder: (BuildContext context, value, Widget? child) {
                if (value.currentImage != null) {
                  currentImage = value.currentImage;
                  return Screenshot(
                    controller: screenshotController,
                    child: Stack(
                      children: [
                        Image.memory(value.currentImage!),
                        Positioned.fill(
                          child: Painter(_controller),
                        )
                      ]
                    )
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                        child: Center(
                          child: Icon(
                            Icons.circle,
                            color: Colors.white,
                            size: _controller.thickness + 3,
                          ),
                        ),
                      ),
                      Expanded(
                        child: slider(
                          value: _controller.thickness,
                          onChanged: (value) {
                            setState(() {
                              _controller.thickness = value;
                            });
                          }
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ]
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 80,
        color: AppColors.bottomBarColor(isDark), // Bottom navigation bar color
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child:
                _bottomBatItem(
                  Icons.color_lens_outlined, 
                  onPress: () {
                    AppColorPicker().show(
                      context,
                      backgroundColor: _controller.drawColor,
                      onPick: (color) {
                        setState(() {
                          _controller.drawColor = color;
                        });
                      }
                    );
                  }
                ),
              ),
              Expanded(child:
                _bottomBatItem(
                  Icons.colorize, 
                  onPress: () {
                    PixelColorImage().show(
                      context,
                      backgroundColor: _controller.drawColor,
                      image: currentImage,
                      onPick: (color) {
                        setState(() {
                          _controller.drawColor = color;
                        });
                      }
                    );
                  }
                ),
              ),
              Expanded(child:
                RotatedBox(
                  quarterTurns: _controller.eraseMode ? 2 : 0,
                  child: _bottomBatItem(
                    Icons.edit, 
                    onPress: () {
                      setState(() {
                        _controller.eraseMode = !_controller.eraseMode;
                      });
                    }
                  ),
                ),
              ),
              Expanded(child:
                _bottomBatItem(
                  Icons.undo, 
                  onPress: () {
                    _controller.undo();
                  }
                ),
              ),
              Expanded(child:
                _bottomBatItem(
                  Icons.delete, 
                  onPress: () {
                    _controller.clear();
                  }
                ),
              ),
            ]
          ),
        )
      ),
    );
  }

  Widget slider({value, onChanged}){
    return Slider(
      label: '${value.toStringAsFixed(2)}',
      value: value, 
      onChanged: onChanged,
      max: 20,
      min: 1,
      activeColor: AppColors.activeSlider,
    );
  }

  Widget _bottomBatItem(IconData icon, { required onPress}) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkTheme;

    return InkWell(
      onTap: () {
        onPress();
      }, 
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon, 
              color: AppColors.iconColor(isDark),
            ),
          ],
        ),
      ),
    );
  }
}