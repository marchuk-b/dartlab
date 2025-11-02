import 'dart:typed_data';
import 'package:colorfilter_generator/addons.dart';
import 'package:colorfilter_generator/colorfilter_generator.dart';
import 'package:flutter/material.dart';
import 'package:photo_editor/providers/app_image_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class AdjustScreen extends StatefulWidget {
  const AdjustScreen({super.key});

  @override
  State<AdjustScreen> createState() => _AdjustScreenState();
}

class _AdjustScreenState extends State<AdjustScreen> {
  late AppImageProvider imageProvider;
  ScreenshotController screenshotController = ScreenshotController();
  late ColorFilterGenerator adj;

  @override
  void initState() {
    imageProvider = Provider.of<AppImageProvider>(context, listen: false);
    adjust();
    super.initState();
  }

  double brightness = 0;
  double saturation = 0;
  double contrast = 0;
  double hue = 0;
  double sepia = 0;

  bool showBrightness = true;
  bool showContrast = false;
  bool showSaturation = false;
  bool showHue = false;
  bool showSepia = false;

  adjust({b, s, c, h, se}){
    adj = ColorFilterGenerator(
      name: "Adjust", 
      filters: [
        ColorFilterAddons.brightness(b ?? brightness),
        ColorFilterAddons.contrast(c ?? contrast),
        ColorFilterAddons.saturation(s ?? saturation),
        ColorFilterAddons.hue(h ?? hue),
        ColorFilterAddons.sepia(se ?? sepia),
      ]
    );
  }

  showSlider({b, s, c, h, se}) {
    setState(() {
      showBrightness = b ?? false;  
      showContrast = c ?? false;  
      showSaturation = s ?? false; 
      showHue = h ?? false; 
      showSepia = se ?? false;  
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(),
        title: Text("Adjust"),
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
                    child: ColorFiltered(
                      colorFilter: ColorFilter.matrix(adj.matrix),
                      child: Image.memory(value.currentImage!),
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
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Visibility(
                        visible: showBrightness,
                        child: slider(
                          value: brightness,
                          onChanged: (value){
                            setState(() {
                              brightness = value;
                              adjust(b: brightness);
                            });
                          }
                        ),
                      ),
                      Visibility(
                        visible: showContrast,
                        child: slider(
                          value: contrast,
                          onChanged: (value){
                            setState(() {
                              contrast = value;
                              adjust(c: contrast);
                            });
                          }
                        ),
                      ),
                      Visibility(
                        visible: showSaturation,
                        child: slider(
                          value: saturation,
                          onChanged: (value){
                            setState(() {
                              saturation = value;
                              adjust(s: saturation);
                            });
                          }
                        ),
                      ),
                      Visibility(
                        visible: showHue,
                        child: slider(
                          value: hue,
                          onChanged: (value){
                            setState(() {
                              hue = value;
                              adjust(h: hue);
                            });
                          }
                        ),
                      ),
                      Visibility(
                        visible: showSepia,
                        child: slider(
                          value: sepia,
                          onChanged: (value){
                            setState(() {
                              sepia = value;
                              adjust(se: sepia);
                            });
                          }
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: (){
                    setState(() {
                      brightness = 0;
                      saturation = 0;
                      contrast = 0;
                      hue = 0;
                      sepia = 0;
                      adjust();
                    });
                  }, 
                  child: const Text("Reset",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  )
                ),
              ],
            ),
          ),          
        ],
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 80,
        color: Colors.blueGrey, // Bottom navigation bar color
        child: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _bottomBatItem(
                  Icons.brightness_5, 
                  "Brightness", 
                  color: showBrightness ? Colors.deepPurple : null,
                  onPress: () {
                    showSlider(b: true);
                  }
                ),
                _bottomBatItem(
                  Icons.contrast, 
                  "Contrast", 
                  color: showContrast ? Colors.deepPurple : null,
                  onPress: () {
                    showSlider(c: true);
                  }
                ),
                _bottomBatItem(
                  Icons.filter_tilt_shift, 
                  "Saturation",
                  color: showSaturation? Colors.deepPurple : null, 
                  onPress: () {
                    showSlider(s: true);
                  }
                ),
                _bottomBatItem(
                  Icons.water_drop, 
                  "Hue", 
                  color: showHue ? Colors.deepPurple : null,
                  onPress: () {
                    showSlider(h: true);
                  }
                ),
                _bottomBatItem(
                  Icons.motion_photos_on, 
                  "Sepia", 
                  color: showSepia ? Colors.deepPurple : null,
                  onPress: () {
                    showSlider(se: true);
                  }
                ),
              ]
            ),
          ),
        )
      ),
    );
  }

  Widget _bottomBatItem(IconData icon, String title, {Color? color, required onPress}) {
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
              color: color ?? Colors.white,
            ),
            const SizedBox(height: 3),
            Text(
              title, 
              style: TextStyle(
                color: color ?? Colors.white70,
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
      max: 1,
      min: -0.9,
    );
  }
}