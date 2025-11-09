import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_editor/helper/shapes.dart';
import 'package:photo_editor/providers/app_image_provider.dart';
import 'package:photo_editor/widgets/gesture_detector_widget.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:widget_mask/widget_mask.dart';

class MaskScreen extends StatefulWidget {
  const MaskScreen({super.key});

  @override
  State<MaskScreen> createState() => _MaskScreenState();
}

class _MaskScreenState extends State<MaskScreen> {
  late AppImageProvider imageProvider;
  ScreenshotController screenshotController = ScreenshotController();

  Uint8List? currentImage;

  BlendMode blendmode = BlendMode.dstIn;
  IconData iconData = Shapes().list()[0];

  double opacity = 1;

  @override
  void initState() {
    imageProvider = Provider.of<AppImageProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(),
        title: Text("Mask"),
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
                    child: WidgetMask(
                      blendMode: blendmode,
                      childSaveLayer: true,
                      mask: Stack(
                        children: [
                          Container(
                            color: Colors.white.withValues(alpha: .4),
                          ),
                          GestureDetectorWidget(
                            child: Icon(iconData, color: Colors.white.withValues(alpha: opacity), size: 250,)
                          )
                        ],
                      ),
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
        ]
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 110,
        color: Colors.blueGrey, 
        child: SafeArea(
          child: Column(
            children: [
              SingleChildScrollView(
                child: Row(
                  children: [
                    TextButton(
                      onPressed: (){
                        setState(() {
                          opacity = 1;
                          blendmode = BlendMode.dst;
                        });
                      }, 
                      child: Text('DstIn', 
                        style: TextStyle(color: Colors.white),
                      )
                    ),
                    TextButton(
                      onPressed: (){
                        setState(() {
                          blendmode = BlendMode.overlay;
                        });
                      }, 
                      child: Text('Overlay', 
                        style: TextStyle(color: Colors.white),
                      )
                    ),
                    TextButton(
                      onPressed: (){
                        setState(() {
                          blendmode = BlendMode.screen;
                          opacity = .7;
                        });
                      }, 
                      child: Text('Screen', 
                        style: TextStyle(color: Colors.white),
                      )
                    ),
                    TextButton(
                      onPressed: (){
                        setState(() {
                          blendmode = BlendMode.saturation;
                        });
                      }, 
                      child: Text('Saturation', 
                        style: TextStyle(color: Colors.white),
                      )
                    ),
                    TextButton(
                      onPressed: (){
                        setState(() {
                          blendmode = BlendMode.difference;
                        });
                      }, 
                      child: Text('Difference', 
                        style: TextStyle(color: Colors.white),
                      )
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      for(int i = 0; i < Shapes().list().length; i++)
                      _bottomBatItem(
                        Shapes().list()[i],
                        onPress: () {
                          setState(() {
                            iconData = Shapes().list()[i];
                          });
                        } 
                      )
                    ],
                  ),
                ),
              )
            ],
          ) 
        ),
      ),
    );
  }

  Widget _bottomBatItem(IconData icon, {required onPress}) {
    return InkWell(
      onTap: () {
        onPress();
      }, 
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Icon(icon, size: 40, color: Colors.white,),
            )
          ],
        ),
      ),
    );
  }
}