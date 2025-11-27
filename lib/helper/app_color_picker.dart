import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:photo_editor/constants/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:photo_editor/providers/theme_provider.dart';

class AppColorPicker {
  Future show(BuildContext context, {Color? backgroundColor, Function(Color)? onPick}) {
    final isDark = Provider.of<ThemeProvider>(context, listen: false).isDarkTheme;

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        Color tempColor = backgroundColor!;
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[850] : Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Handle
                    Container(
                      width: 40,
                      height: 5,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey.shade700 : Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),

                    // Color picker
                    SizedBox(
                      height: MediaQuery.of(context).size.height*0.42,
                      child: SingleChildScrollView(
                        child: HueRingPicker(
                          enableAlpha: false,
                          pickerColor: tempColor,
                          onColorChanged: (color) {
                            setState(() => tempColor = color);
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Preview box
                    Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: tempColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isDark ? Colors.white70 : Colors.black,
                          width: 2,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Button
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        child: Text(
                          'Got it',
                          style: TextStyle(color: AppColors.textPrimary(isDark),),
                        ),
                        onPressed: () {
                          onPick?.call(tempColor);
                          Navigator.of(context).pop();
                        },
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
