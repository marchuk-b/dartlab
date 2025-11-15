import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:photo_editor/constants/app_colors.dart';
import 'package:photo_editor/providers/app_image_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class BlurScreen extends StatefulWidget {
  const BlurScreen({super.key});

  @override
  State<BlurScreen> createState() => _BlurScreenState();
}

class _BlurScreenState extends State<BlurScreen> {
  late AppImageProvider imageProvider;
  ScreenshotController screenshotController = ScreenshotController();

  double sigmaX = 0.0;
  double sigmaY = 0.0;
  TileMode tileMode = TileMode.decal;

  @override
  void initState() {
    imageProvider = Provider.of<AppImageProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        // title: Text("Blur"),
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
                  return Screenshot(
                    controller: screenshotController,
                    child: ImageFiltered(
                      imageFilter: ImageFilter.blur(
                        sigmaX: sigmaX,
                        sigmaY: sigmaY,
                        tileMode: tileMode,
                      ),
                      child: Image.memory(value.currentImage!),
                    ),
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
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Text("X:", 
                        style: TextStyle(
                          color: AppColors.textPrimary
                        ) 
                      ),
                      Expanded(
                        child: slider(
                          value: sigmaX,
                          onChanged: (value) {
                            setState(() {
                              sigmaX = value;
                            });
                          }
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text("Y: ", 
                        style: TextStyle(
                          color: AppColors.textPrimary
                        ) 
                      ),
                      Expanded(
                        child: slider(
                          value: sigmaY,
                          onChanged: (value) {
                            setState(() {
                              sigmaY = value;
                            });
                          }
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ),
        ],
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 80,
        color: AppColors.bottomBarColor,
        child: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _bottomBatItem(
                  "Decal", 
                  color: tileMode == TileMode.decal ? AppColors.activeButton : null,
                  onPress: () {
                    setState(() {
                      tileMode = TileMode.decal;
                    });
                  }
                ),
                _bottomBatItem(
                  "Clamp", 
                  color: tileMode == TileMode.clamp ? AppColors.activeButton : null,
                  onPress: () {
                    setState(() {
                      tileMode = TileMode.clamp;
                    });
                  }
                ),
                _bottomBatItem(
                  "Mirror", 
                  color: tileMode == TileMode.mirror ? AppColors.activeButton : null,
                  onPress: () {
                    setState(() {
                      tileMode = TileMode.mirror;
                    });
                  }
                ),
                _bottomBatItem(
                  "Repeated", 
                  color: tileMode == TileMode.repeated ? AppColors.activeButton : null,
                  onPress: () {
                    setState(() {
                      tileMode = TileMode.repeated;
                    });
                  }
                ),
              ]
            ),
          ),
        )
      ),
    );
  }

  Widget _bottomBatItem(String title, {Color? color, required onPress}) {
    return InkWell(
      onTap: () {
        onPress();
      }, 
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title, 
              style: TextStyle(
                color: color ?? AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget slider({value, onChanged}){
    return Slider(
      label: '${value.toStringAsFixed(2)}',
      value: value, 
      onChanged: onChanged,
      max: 10.0,
      min: 0.0,
      activeColor: AppColors.activeSlider,
    );
  }
}