import 'dart:io';
import 'dart:typed_data';
import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_editor/constants/app_colors.dart';
import 'package:photo_editor/helper/app_color_picker.dart';
import 'package:photo_editor/helper/app_image_picker.dart';
import 'package:photo_editor/helper/pixel_color_image.dart';
import 'package:photo_editor/helper/textures.dart';
import 'package:photo_editor/providers/app_image_provider.dart';
import 'package:photo_editor/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import '../model/texture.dart' as t;

class FitScreen extends StatefulWidget {
  const FitScreen({super.key});

  @override
  State<FitScreen> createState() => _FitScreenState();
}

class _FitScreenState extends State<FitScreen> {
  late AppImageProvider imageProvider;
  ScreenshotController screenshotController = ScreenshotController();

  Uint8List? currentImage;
  Uint8List? backgroundImage;

  int x = 1;
  int y = 1;

  bool showRatio = true;
  bool showBlur = false;
  bool showColor = false;
  bool showTexture = false;

  bool showColorBackground = true;
  bool showImageBackground = false;
  bool showTextureBackground = false;

  double blur = 0;

  Color backgroundColor = Colors.white;

  late t.Texture currentTexture;
  late List<t.Texture> textures;

  @override
  void initState() {
    textures = Textures().list();
    currentTexture = textures[0];
    imageProvider = Provider.of<AppImageProvider>(context, listen: false);
    super.initState();
  }
  
  void showActiveWidget({r, b, c, t}){
    showRatio = r != null ? true : false;
    showBlur = b != null ? true : false;
    showColor = c != null ? true : false;
    showTexture = t != null ? true : false;
    setState(() {});
  }

  void showBackgroundWidget({c, i, t}){
    showColorBackground = c != null ? true : false;
    showImageBackground = i != null ? true : false;
    showTextureBackground = t != null ? true : false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkTheme;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        // title: Text("Fit"),
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
                  currentImage = value.currentImage!;
                  backgroundImage ??= value.currentImage!;
                  return AspectRatio(
                    aspectRatio: x / y,
                    child: Screenshot(
                      controller: screenshotController,
                      child: Stack(
                        children: [
                          if(showColorBackground)
                          Container(
                            color: backgroundColor,
                          ),
                          if(showImageBackground)
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: MemoryImage(backgroundImage!)
                              )
                            ),
                          ).blurred(
                            colorOpacity: 0,
                            blur: blur
                          ),
                          if(showTextureBackground)
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(currentTexture.path!)
                              )
                            ),
                          ),
                          Center(
                            child: Image.memory(value.currentImage!),
                          )
                        ],
                      )
                    ),
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
        color: AppColors.bottomBarColor(isDark), // Bottom navigation bar color
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    if(showRatio)
                      ratioWidget(),
                    if(showBlur)
                      blurWidget(),
                    if(showColor)
                      colorWidget(),
                    if(showTexture)
                      textureWidget()
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: _bottomBatItem(
                        Icons.aspect_ratio, 
                        "Ratio", 
                        onPress: () {
                          showActiveWidget(r: true);
                        }
                      ),
                    ),
                    Expanded(
                      child: _bottomBatItem(
                        Icons.blur_on,
                        "Blur", 
                        onPress: () {
                          showBackgroundWidget(i: true);
                          showActiveWidget(b: true);
                        }
                      ),
                    ),
                    Expanded(
                      child: _bottomBatItem(
                        Icons.color_lens, 
                        "Color", 
                        onPress: () {
                          showBackgroundWidget(c: true);
                          showActiveWidget(c: true);
                        }
                      ),
                    ),
                    Expanded(
                      child: _bottomBatItem(
                        Icons.texture, 
                        "Texture",
                        onPress: () {
                          showBackgroundWidget(t: true);
                          showActiveWidget(t: true);
                        }
                      ),
                    ),
                  ]
                ),
              ),
            ],
          ),
        ),
      )
    );
  }

  Widget _bottomBatItem(IconData icon, String title, {Color? color, required onPress}) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkTheme;

    return InkWell(
      onTap: () {
        onPress();
      }, 
      child: Padding(
        padding: EdgeInsets.only(top: 10, left: 15, right: 15),
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

  Widget ratioWidget() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkTheme;

    return Container(
      color: AppColors.secondaryColor(isDark),
      child: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              TextButton(
                onPressed: (){
                  setState(() {
                    x = 1;
                    y = 1;
                  });
                }, 
                child: Text("1:1",
                  style: TextStyle(color: AppColors.textPrimary(isDark)),
                )
              ),
              TextButton(
                onPressed: (){
                  setState(() {
                    x = 1;
                    y = 2;
                  });
                },  
                child: Text("1:2",
                  style: TextStyle(color: AppColors.textPrimary(isDark)),
                )
              ),
              TextButton(
                onPressed: (){
                  setState(() {
                    x = 2;
                    y = 1;
                  });
                },  
                child: Text("2:1",
                  style: TextStyle(color: AppColors.textPrimary(isDark)),
                )
              ),
              TextButton(
                onPressed: (){
                  setState(() {
                    x = 3;
                    y = 4;
                  });
                },  
                child: Text("3:4",
                  style: TextStyle(color: AppColors.textPrimary(isDark)),
                )
              ),
              TextButton(
                onPressed: (){
                  setState(() {
                    x = 4;
                    y = 3;
                  });
                },  
                child: Text("4:3",
                  style: TextStyle(color: AppColors.textPrimary(isDark)),
                )
              ),
              TextButton(
                onPressed: (){
                  setState(() {
                    x = 4;
                    y = 5;
                  });
                },  
                child: Text("4:5",
                  style: TextStyle(color: AppColors.textPrimary(isDark)),
                )
              ),
              TextButton(
                onPressed: (){
                  setState(() {
                    x = 5;
                    y = 4;
                  });
                },
                child: Text("5:4",
                  style: TextStyle(color: AppColors.textPrimary(isDark)),
                )
              ),
              TextButton(
                onPressed: (){
                  setState(() {
                    x = 16;
                    y = 9;
                  });
                },  
                child: Text("16:9",
                  style: TextStyle(color: AppColors.textPrimary(isDark)),
                )
              ),
              TextButton(
                onPressed: (){
                  setState(() {
                    x = 9;
                    y = 16;
                  });
                },  
                child: Text("9:16",
                  style: TextStyle(color: AppColors.textPrimary(isDark)),
                )
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget blurWidget() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkTheme;

    return Container(
      color: AppColors.secondaryColor(isDark),
      child: Center(
        child: Row(
          children: [
            IconButton(
              onPressed: (){
                AppImagePicker(source: ImageSource.gallery)
                  .pick(onPick: (File? image) async{
                    backgroundImage = await image!.readAsBytesSync();
                    setState(() {});
                  });
              }, 
              icon: Icon(
                Icons.photo_library_outlined, 
                color: AppColors.iconColor(isDark)
              )
            ),
            Expanded(
              child: Slider(
                label: blur.toStringAsFixed(2),
                value: blur, 
                onChanged: (value){
                  setState(() {
                    blur = value;
                  });
                },
                max: 100,
                min: 0,
                activeColor: AppColors.activeSlider,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget colorWidget() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkTheme;

    return Container(
      color: AppColors.secondaryColor(isDark),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: (){
                AppColorPicker().show(
                  context,
                  backgroundColor: backgroundColor,
                  onPick: (color) {
                    setState(() {
                      backgroundColor = color;
                    });
                  }
                );
              }, 
              icon: Icon(
                Icons.color_lens, 
                color: AppColors.iconColor(isDark)
              )
            ),
            IconButton(
              onPressed: (){
                PixelColorImage().show(
                  context,
                  backgroundColor: backgroundColor,
                  image: currentImage,
                  onPick: (color) {
                    setState(() {
                      backgroundColor = color;
                    });
                  }
                );
              }, 
              icon: Icon(
                Icons.colorize, 
                color: AppColors.iconColor(isDark)
              )
            ),
          ],
        ),
      ),
    );
  }

  Widget textureWidget() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkTheme;

    return Container(
      color: AppColors.secondaryColor(isDark),
      child: Center(
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: textures.length,
          itemBuilder: (BuildContext context, int index) {
            t.Texture texture = textures[index];
            return Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 10), 
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: InkWell(
                        onTap: (){
                          setState(() {
                            currentTexture = texture;
                          });
                        },
                        child: Image.asset(texture.path!)
                      )
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}