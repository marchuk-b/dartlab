import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_editor/constants/app_colors.dart';
import 'package:photo_editor/helper/app_image_picker.dart';
import 'package:photo_editor/providers/app_image_provider.dart';
import 'package:provider/provider.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {

  late AppImageProvider imageProvider;

  @override
  void initState(){
    imageProvider = Provider.of<AppImageProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.backgroundColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Image.asset('assets/images/logo_with_label2.png', width: 250,),
              ),
            ),
            Expanded(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _circleButton(
                      onPressed: () {
                        AppImagePicker(source: ImageSource.gallery)
                          .pick(onPick: (File? image){
                            imageProvider.changeImageFile(image!);
                            Navigator.of(context).pushReplacementNamed('/home');
                          }
                        );
                      },
                      icon: Icons.backup_outlined,
                      label: "Gallery",
                    ),
                    _circleButton(
                      onPressed: () {
                        AppImagePicker(source: ImageSource.camera)
                            .pick(onPick: (File? image){
                          imageProvider.changeImageFile(image!);
                          Navigator.of(context).pushReplacementNamed('/home');
                        }
                        );
                      },
                      icon: Icons.camera,
                      label: "Camera",
                    ),
                  ],
                )
              )
           ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 80,
        color: AppColors.bottomBarColor,
        child: SafeArea(
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton.icon(
                  onPressed: () {

                  },
                  icon: Icon(Icons.settings, color: AppColors.iconColor),
                  label: Text("Settings", style: TextStyle(color: AppColors.textSecondary)),
                ),
                TextButton.icon(
                  onPressed: () {

                  },
                  icon: Icon(Icons.question_mark, color: AppColors.iconColor),
                  label: Text("About", style: TextStyle(color: AppColors.textSecondary)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _circleButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: AppColors.secondaryColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPressed,
              customBorder: CircleBorder(),
              child: Center(
                child: Icon(icon, size: 48, color: Colors.white),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}