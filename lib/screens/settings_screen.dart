import 'package:flutter/material.dart';
import 'package:photo_editor/constants/app_colors.dart';
import 'package:photo_editor/model/quality.dart';
import 'package:photo_editor/providers/quality_provider.dart';
import 'package:photo_editor/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkTheme;

    final qualityProvider = Provider.of<QualityProvider>(context);
    final qualityOptions = qualityProvider.qualityOptions;
    final exportQuality = qualityProvider.exportQuality;

    return Scaffold(
      appBar: AppBar(
        title: Align(
            alignment: Alignment.centerLeft,
            child: Text("Settings")
        ),
        leading: BackButton(),
      ),
      body: Container(
        color: AppColors.backgroundColor(isDark),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('APP PREFERENCES',
                    style: TextStyle(
                      color: AppColors.textSecondary(isDark),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.primaryColor(isDark),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    _settingItem(
                        icon: Icons.dark_mode_outlined,
                        title: "Dark theme",
                        child: Switch(
                          value: isDark,
                          onChanged: (val) {
                            setState(() {
                              themeProvider.setTheme(val);
                            });
                          },

                          activeThumbColor: Colors.white,
                          activeTrackColor: AppColors.activeSlider.withValues(alpha: 0.7),
                          inactiveThumbColor: Colors.grey,
                          inactiveTrackColor: Colors.grey.withValues(alpha: 0.3),
                        ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Divider(height: 1, color: AppColors.secondaryColor(isDark)),
                    ),

                    _settingItem(
                      icon: Icons.high_quality_outlined,
                      title: "Export quality",
                      child: Container(
                        width: 90,
                        child: DropdownButton<Quality>(
                          isExpanded: true,
                          value: exportQuality,
                          onChanged: (Quality? quality) {
                            if (quality != null) {
                              qualityProvider.setExportQuality(quality);
                            }
                          },
                          dropdownColor: AppColors.secondaryColor(isDark),
                          style: TextStyle(
                            color: AppColors.textPrimary(isDark),
                            fontSize: 16,
                          ),
                          items: qualityOptions.map((quality) {
                            return DropdownMenuItem<Quality>(
                              value: quality,
                              child: Text(quality.qualityName),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('ABOUT',
                    style: TextStyle(
                      color: AppColors.textSecondary(isDark),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor(isDark),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    _settingItem(
                      icon: Icons.info_outline,
                      title: "Version",
                      child: Text(
                        "1.0.0",
                        style: TextStyle(
                          color: AppColors.textSecondary(isDark),
                          fontSize: 16,
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Divider(height: 1, color: AppColors.secondaryColor(isDark)),
                    ),

                    _settingItem(
                      icon: Icons.code,
                      title: "Developer",
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: AppColors.textSecondary(isDark),
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

  Widget _settingItem({
    required IconData icon,
    required String title,
    required Widget child
  }) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.iconColor(isDark),
            size: 24,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              color: AppColors.textPrimary(isDark),
              fontSize: 16,
            ),
          ),
          const Spacer(), // Відштовхує Switch вправо
          child
        ],
      ),
    );
  }
}
