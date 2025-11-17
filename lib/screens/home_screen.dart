import 'package:flutter/material.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:photo_editor/constants/app_colors.dart';
import 'package:photo_editor/providers/app_image_provider.dart';
import 'package:photo_editor/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late AppImageProvider appImageProvider;

  @override
  void initState() {
    appImageProvider = Provider.of<AppImageProvider>(context, listen: false);
    super.initState();
  }

  void _savePhoto() async {
    final result = await ImageGallerySaverPlus.saveImage(
      appImageProvider.currentImage!,
      quality: 100,
      name: '${DateTime.now().millisecondsSinceEpoch}'
    );
    if (!mounted) return;
    if (result['isSuccess']) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Image saved to Gallery')
        )
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong!')
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkTheme;

    return Scaffold(
      appBar: AppBar(
        // title: Text("Photo Editor"),
        leading: BackButton(
          onPressed: () {
            appImageProvider.clearImage();
            Navigator.of(context).pushReplacementNamed('/');
          },
        ),
        actions: [
          TextButton(
            onPressed: (){
              _savePhoto();
            },
            child: Text(
              "Save",
              style: TextStyle(
                color: AppColors.textPrimary(isDark),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: Consumer<AppImageProvider>(
              builder: (BuildContext context, value, Widget? child) {
                if (value.currentImage != null) {
                  return InteractiveViewer(
                      minScale: 0.5,
                      maxScale: 4.0,
                      boundaryMargin: const EdgeInsets.all(10),
                      panEnabled: true,  // Можливість переміщувати
                      scaleEnabled: true,
                      child: Image.memory(value.currentImage!)
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColors.secondaryColor(isDark),
              ),
              child: Consumer<AppImageProvider>(
                builder: (context, value, child) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: (){
                          appImageProvider.undo();
                        }, 
                        icon: Icon(Icons.undo, 
                          color: value.canUndo ? AppColors.activeArrow : AppColors.disabledArrow
                        )
                      ),
                      IconButton(
                        onPressed: (){
                           appImageProvider.redo();
                        }, 
                        icon: Icon(Icons.redo, 
                          color: value.canRedo ? AppColors.activeArrow : AppColors.disabledArrow
                        )
                      ),
                    ],
                  );
                }
              )
            ),
          )
        ],
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 90,
        color: AppColors.bottomBarColor(isDark),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsetsGeometry.directional(top: 7),
              scrollDirection: Axis.horizontal,
              child: Center(
                child: Row(
                  children: [
                    _bottomBatItem(
                      Icons.crop_rotate_sharp,
                      "Crop",
                      onPress: () {
                        Navigator.of(context).pushNamed('/crop');
                      }
                    ),
                    _bottomBatItem(
                      Icons.filter_alt_rounded,
                      "Filters",
                      onPress: () {
                        Navigator.of(context).pushNamed('/filter');
                      }
                    ),
                    _bottomBatItem(
                      Icons.tune_outlined,
                      "Adjust",
                      onPress: () {
                        Navigator.of(context).pushNamed('/adjust');
                      }
                    ),
                    _bottomBatItem(
                      Icons.fit_screen,
                      "Fit",
                      onPress: () {
                        Navigator.of(context).pushNamed('/fit');
                      }
                    ),
                    _bottomBatItem(
                      Icons.water_drop_outlined,
                      "Tint",
                      onPress: () {
                        Navigator.of(context).pushNamed('/tint');
                      }
                    ),
                    _bottomBatItem(
                      Icons.lens_blur,
                      "Blur",
                      onPress: () {
                        Navigator.of(context).pushNamed('/blur');
                      }
                    ),
                    _bottomBatItem(
                      Icons.emoji_emotions,
                      "Stickers",
                      onPress: () {
                        Navigator.of(context).pushNamed('/sticker');
                      }
                    ),
                    _bottomBatItem(
                        Icons.text_fields,
                        "Text",
                        onPress: () {
                          Navigator.of(context).pushNamed('/text');
                        }
                    ),
                    _bottomBatItem(
                        Icons.draw,
                        "Draw",
                        onPress: () {
                          Navigator.of(context).pushNamed('/draw');
                        }
                    ),
                    _bottomBatItem(
                        Icons.star_border,
                        "Mask",
                        onPress: () {
                          Navigator.of(context).pushNamed('/mask');
                        }
                    ),
                  ]
                ),
              ),
            ),
          ),
        )
      ),
    );
  }

  Widget _bottomBatItem(IconData icon, String title, {required onPress}) {
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
              color: AppColors.textPrimary(isDark),
            ),
            const SizedBox(height: 3),
            Text(
              title, 
              style: TextStyle(
                color: AppColors.textPrimary(isDark),
              ),
            ),
          ],
        ),
      ),
    );
  }
}