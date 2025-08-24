import 'dart:async';

import 'package:evently/core/cache_helper/cache_helper.dart';
import 'package:evently/core/provider/user_provider.dart';
import 'package:evently/core/theming/theme.dart';
import 'package:evently/core/utils/app_images.dart';
import 'package:evently/view/screens/auth/login/login_screen.dart';
import 'package:evently/view/screens/home/home_screen.dart';
import 'package:evently/view/screens/intro_screen.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = "SPLASH_SCREEN";

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    Timer(
      Duration(seconds: 3),
      () => Navigator.pushReplacementNamed(
        context,
        CacheHelper.getEligibility() == true
            ? userProvider.firebaseUser == null
                ? LoginScreen.routeName
                : HomeScreen.routeName
            : IntroScreen.routeName,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Image.asset(AppImages.splash_logo_img)),
    );
  }
}
