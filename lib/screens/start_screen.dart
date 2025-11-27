import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_editor/constants/app_colors.dart';
import 'package:photo_editor/helper/app_image_picker.dart';
import 'package:photo_editor/helper/platform_helper.dart';
import 'package:photo_editor/providers/app_image_provider.dart';
import 'package:photo_editor/providers/theme_provider.dart';
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkTheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg_start_screen.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Верхня панель замість AppBar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _circleButton(
                      icon: Icons.info,
                      label: "About",
                      onPressed: () {
                        Navigator.of(context).pushNamed('/about');
                      },
                    ),
                    _circleButton(
                      icon: Icons.settings,
                      label: "Settings",
                      onPressed: () {
                        Navigator.of(context).pushNamed('/settings');
                      }
                    ),
                  ],
                ),
              ),

              // Логотип
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Center(
                  child: Container(
                    // decoration: BoxDecoration(
                    //     // borderRadius: BorderRadius.circular(10),
                    //     color: Colors.black38
                    // ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 20),
                      child: Image.asset(
                        'assets/images/logos.png',
                        width: 240,
                      ),
                    ),
                  ),
                ),
              ),

              // Кнопки
              Padding(
                padding: const EdgeInsets.only(top: 40, bottom: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (PlatformHelper.isCameraSupported)
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black45,
                          padding: EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          AppImagePicker(source: ImageSource.camera)
                              .pick(onPick: (File? image){
                            imageProvider.changeImageFile(image!);
                            Navigator.of(context).pushReplacementNamed('/home');
                          }
                          );
                        },
                        icon: Icon(Icons.camera_alt, size: 40, color: AppColors.iconColor(isDark)),
                        label: Text(
                          "CAMERA",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            color: AppColors.textSecondary(isDark),
                          ),
                        ),
                      ),

                    if (PlatformHelper.isCameraSupported)
                      SizedBox(height: 12),

                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black45,
                        padding: EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        AppImagePicker(source: ImageSource.gallery)
                            .pick(onPick: (File? image){
                          imageProvider.changeImageFile(image!);
                          Navigator.of(context).pushReplacementNamed('/home');
                        }
                        );
                      },
                      icon: Icon(Icons.photo_library, size: 40, color: AppColors.iconColor(isDark)),
                      label: Text(
                        "GALLERY",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: AppColors.textSecondary(isDark),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: InkWell(
        onTap: onPressed,
        customBorder: CircleBorder(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 36,
              height: 36,
              child: Center(
                child: Icon(icon, size: 36, color: Colors.white),
              ),
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.darkTextSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}