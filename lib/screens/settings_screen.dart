import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
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
  String _appVersion = '';
  String _buildNumber = '';

  Future<void> _loadAppInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = packageInfo.version;
      _buildNumber = packageInfo.buildNumber;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadAppInfo();
  }

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
                      isDark: isDark,
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
                      isDark: isDark,
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
                      isDark: isDark,
                      child: Text(
                        _appVersion.isEmpty
                            ? "Loading..."
                            : _appVersion,
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

                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: AppColors.primaryColor(isDark),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            title: Text(
                              'Developer Info',
                              style: TextStyle(
                                color: AppColors.textPrimary(isDark),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _developerInfoRow(
                                  'Developer',
                                  'Bohdan Marchuk',
                                  isDark,
                                ),
                                SizedBox(height: 12),
                                _developerInfoRow(
                                  'Email',
                                  'marchukbohdan29@gmail.com',
                                  isDark,
                                ),
                                SizedBox(height: 12),
                                _developerInfoRow(
                                  'GitHub',
                                  'github.com/marchuk-b',
                                  isDark,
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  'Close',
                                  style: TextStyle(
                                    color: AppColors.activeSlider,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      child: _settingItem(
                        icon: Icons.code,
                        title: "Developer",
                        isDark: isDark,
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
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

  Widget _settingItem({
    required IconData icon,
    required String title,
    required Widget child,
    required bool isDark
  }) {
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

  Widget _developerInfoRow(
    String label,
    String value,
    bool isDark,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: AppColors.textSecondary(isDark),
                  fontSize: 12,
                ),
              ),
              SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  color: AppColors.textPrimary(isDark),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


