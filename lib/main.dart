import 'package:flutter/material.dart';
import 'package:photo_editor/constants/app_colors.dart';
import 'package:photo_editor/providers/app_image_provider.dart';
import 'package:photo_editor/screens/adjust_screen.dart';
import 'package:photo_editor/screens/blur_screen.dart';
import 'package:photo_editor/screens/crop_screen.dart';
import 'package:photo_editor/screens/draw_screen.dart';
import 'package:photo_editor/screens/filter_screen.dart';
import 'package:photo_editor/screens/fit_screen.dart';
import 'package:photo_editor/screens/home_screen.dart';
import 'package:photo_editor/screens/mask_screen.dart';
import 'package:photo_editor/screens/start_screen.dart';
import 'package:photo_editor/screens/sticker_screen.dart';
import 'package:photo_editor/screens/text_screen.dart';
import 'package:photo_editor/screens/tint_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AppImageProvider()),
    ], 
    child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "photo-editor",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: AppColors.backgroundColor, // Default background color
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.appBarColor, // Default app bar color
          foregroundColor: AppColors.textPrimary,
          centerTitle: true,
          elevation: 0,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.secondaryColor,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontFamily: 'Rubik'),
          bodyMedium: TextStyle(fontFamily: 'Rubik'),
          titleLarge: TextStyle(fontFamily: 'Rubik'),
        ),
        sliderTheme: const SliderThemeData(
          showValueIndicator: ShowValueIndicator.onDrag, 
        ),
      ),
      routes: <String, WidgetBuilder>{
        '/': (_) => StartScreen(),
        '/home': (_) => HomeScreen(),
        '/crop': (_) => CropScreen(),
        '/filter': (_) => FilterScreen(),
        '/adjust': (_) => AdjustScreen(),
        '/fit': (_) => FitScreen(),
        '/tint': (_) => TintScreen(),
        '/blur': (_) => BlurScreen(),
        '/sticker': (_) => StickerScreen(),
        '/text': (_) => TextScreen(),
        '/draw': (_) => DrawScreen(),
        '/mask': (_) => MaskScreen(),
      },
      initialRoute: '/',
    );
  }
}
