import 'package:flutter/material.dart';
import 'package:photo_editor/providers/app_image_provider.dart';
import 'package:photo_editor/screens/adjust_screen.dart';
import 'package:photo_editor/screens/blur_screen.dart';
import 'package:photo_editor/screens/crop_screen.dart';
import 'package:photo_editor/screens/filter_screen.dart';
import 'package:photo_editor/screens/fit_screen.dart';
import 'package:photo_editor/screens/home_screen.dart';
import 'package:photo_editor/screens/start_screen.dart';
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
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.black, // Default background color
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blueGrey, // Default app bar color
          centerTitle: true,
          elevation: 0,
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
      },
      initialRoute: '/',
    );
  }
}
