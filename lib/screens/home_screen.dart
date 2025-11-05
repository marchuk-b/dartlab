import 'package:flutter/material.dart';
import 'package:photo_editor/providers/app_image_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Photo Editor"),
        leading: CloseButton(
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/');
          },
        ),
        actions: [
          TextButton(
            onPressed: (){},
            child: const Text(
              "Save",
              style: TextStyle(
                color: Colors.white, 
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Consumer<AppImageProvider>(
          builder: (BuildContext context, value, Widget? child) {
            if (value.currentImage != null) {
              return Image.memory(value.currentImage!);
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
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
                  Icons.water_drop, 
                  "Blur", 
                  onPress: () {
                    Navigator.of(context).pushNamed('/blur');
                  }
                ),
              ]
            ),
          ),
        )
      ),
    );
  }

  Widget _bottomBatItem(IconData icon, String title, {required onPress}) {
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
              color: Colors.white,
            ),
            const SizedBox(height: 3),
            Text(
              title, 
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}