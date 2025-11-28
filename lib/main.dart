import 'package:flutter/material.dart';
import 'package:photo_editor/constants/app_colors.dart';
import 'package:photo_editor/providers/app_image_provider.dart';
import 'package:photo_editor/providers/quality_provider.dart';
import 'package:photo_editor/providers/theme_provider.dart';
import 'package:photo_editor/screens/adjust_screen.dart';
import 'package:photo_editor/screens/blur_screen.dart';
import 'package:photo_editor/screens/crop_screen.dart';
import 'package:photo_editor/screens/draw_screen.dart';
import 'package:photo_editor/screens/filter_screen.dart';
import 'package:photo_editor/screens/fit_screen.dart';
import 'package:photo_editor/screens/home_screen.dart';
import 'package:photo_editor/screens/mask_screen.dart';
import 'package:photo_editor/screens/settings_screen.dart';
import 'package:photo_editor/screens/start_screen.dart';
import 'package:photo_editor/screens/sticker_screen.dart';
import 'package:photo_editor/screens/text_screen.dart';
import 'package:photo_editor/screens/tint_screen.dart';
import 'package:photo_editor/screens/about_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AppImageProvider()),
      ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ChangeNotifierProvider(create: (_) => QualityProvider()),
    ], 
    child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isDark = themeProvider.isDarkTheme;

        return MaterialApp(
          title: "DartLab",
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.deepPurple,
            scaffoldBackgroundColor: AppColors.backgroundColor(isDark), // Default background color

            appBarTheme: AppBarTheme(
              backgroundColor: AppColors.appBarColor(isDark), // Default app bar color
              foregroundColor: AppColors.textPrimary(isDark),
              centerTitle: true,
              elevation: 0,
            ),

            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: AppColors.secondaryColor(isDark),
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
            '/settings': (_) => SettingsScreen(),
            '/about': (_) => AboutScreen(),
          },
          initialRoute: '/',
        );
      }
    );
  }
}
