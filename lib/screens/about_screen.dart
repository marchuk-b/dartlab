import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import '../providers/theme_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {

  Future<void> openLink(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception("Cannot launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkTheme;

    return Scaffold(
      appBar: AppBar(
        title: Align(
            alignment: Alignment.centerLeft,
            child: Text("About")
        ),
        leading: BackButton(),
      ),
      body: Container(
        color: AppColors.backgroundColor(isDark),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Image.asset('assets/images/logo_with_label824.png', width: 200),
                  Text("Where every photo becomes a masterpiece.",
                    style: TextStyle(color: AppColors.textSecondary(isDark)),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40, left: 15, right: 15, bottom: 5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Legal',
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
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: TextButton.icon(
                          label: Text(
                            "Privacy Policy",
                            style: TextStyle(
                              color: AppColors.textPrimary(isDark),
                              fontSize: 16,
                            ),
                          ),
                          icon: Icon(Icons.account_circle_outlined,
                            color: AppColors.iconColor(isDark),
                            size: 24,
                          ),
                          onPressed: (){}
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Divider(height: 1, color: AppColors.secondaryColor(isDark)),
                  ),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: TextButton.icon(
                          label: Text(
                            "Terms of Service",
                            style: TextStyle(
                              color: AppColors.textPrimary(isDark),
                              fontSize: 16,
                            ),
                          ),
                          icon: Icon(Icons.description_outlined,
                            color: AppColors.iconColor(isDark),
                            size: 24,
                          ),
                          onPressed: (){}
                      ),
                    ),
                  ),
                ],
              )
              ),

              Padding(
                padding: const EdgeInsets.only(top: 40, left: 15, right: 15, bottom: 5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Connect',
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
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: TextButton.icon(
                              label: Text(
                                "Like us in Instagram",
                                style: TextStyle(
                                  color: AppColors.textPrimary(isDark),
                                  fontSize: 16,
                                ),
                              ),
                              icon: Icon(Icons.camera_alt_outlined,
                                color: AppColors.iconColor(isDark),
                                size: 24,
                              ),
                              onPressed: (){
                                openLink("https://www.instagram.com/marchukk.b/");
                              }
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Divider(height: 1, color: AppColors.secondaryColor(isDark)),
                      ),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: TextButton.icon(
                              label: Text(
                                "Join our Community",
                                style: TextStyle(
                                  color: AppColors.textPrimary(isDark),
                                  fontSize: 16,
                                ),
                              ),
                              icon: Icon(Icons.facebook_outlined,
                                color: AppColors.iconColor(isDark),
                                size: 24,
                              ),
                              onPressed: (){}
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Divider(height: 1, color: AppColors.secondaryColor(isDark)),
                      ),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: TextButton.icon(
                              label: Text(
                                "You can contact us by email",
                                style: TextStyle(
                                  color: AppColors.textPrimary(isDark),
                                  fontSize: 16,
                                ),
                              ),
                              icon: Icon(Icons.email_outlined,
                                color: AppColors.iconColor(isDark),
                                size: 24,
                              ),
                              onPressed: (){
                                openLink("mailto:marchukbohdan29@gmail.com");
                              }
                          ),
                        ),
                      ),
                    ],
                  )
              )
            ]
          )
        )
      )
    );
  }
}
