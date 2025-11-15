import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:lindi_sticker_widget/lindi_controller.dart';
import 'package:lindi_sticker_widget/lindi_sticker_widget.dart';
import 'package:photo_editor/constants/app_colors.dart';
import 'package:photo_editor/helper/stickers.dart';
import 'package:photo_editor/providers/app_image_provider.dart';
import 'package:provider/provider.dart';

class StickerScreen extends StatefulWidget {
  const StickerScreen({super.key});

  @override
  State<StickerScreen> createState() => _StickerScreenState();
}

class _StickerScreenState extends State<StickerScreen> {
  late AppImageProvider imageProvider;
  LindiController controller = LindiController();

  int index = 0;

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
        // title: Text("Sticker"),
        actions: [
          IconButton(
            onPressed: () async{
              Uint8List? image = await controller.saveAsUint8List();
              imageProvider.changeImage(image!);
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
                  return LindiStickerWidget(
                    controller: controller,
                    child: Image.memory(value.currentImage!)
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
        height: 140,
        color: AppColors.bottomBarColor,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  color: AppColors.secondaryColor,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: Stickers().list()[index].length,
                    itemBuilder: (BuildContext context, int idx) {
                      String sticker = Stickers().list()[index][idx];
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5), 
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: FittedBox(
                                fit: BoxFit.fill,
                                child: InkWell(
                                  onTap: (){
                                    setState(() {
                                      controller.addWidget(
                                        Image.asset(sticker),
                                      );
                                    });
                                  },
                                  child: Column(
                                    children: [
                                      Image.asset(sticker)
                                    ],
                                  ),
                                )
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )
              ),
              Row(
                children: [
                  for(int i = 0; i < Stickers().list().length; i++)
                  _bottomBatItem(
                    i,
                    Stickers().list()[i][0],
                    onPress: () {
                      setState(() {
                        index = i;
                      });
                    } 
                  )
                ],
              )
            ],
          ) 
        ),
      ),
    );
  }

  Widget _bottomBatItem(int idx, String icon, {required onPress}) {
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
              child: Container(
                color: idx == index ? Colors.white : Colors.transparent,
                height: 2,
                width: 20,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(icon, width: 30,),
            )
          ],
        ),
      ),
    );
  }
}