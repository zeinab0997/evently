import 'dart:ui';

import 'package:evently/core/provider/app_provider.dart';
import 'package:evently/core/provider/user_provider.dart';
import 'package:evently/core/theming/dark_theme.dart';
import 'package:evently/core/theming/light_theme.dart';
import 'package:evently/core/theming/theme.dart';
import 'package:evently/view/screens/auth/forget_pass_screen.dart';
import 'package:evently/view/screens/auth/login/login_screen.dart';
import 'package:evently/view/screens/auth/signup_screen.dart';
import 'package:evently/view/screens/home/add_event_screen.dart';
import 'package:evently/view/screens/home/event_details_screen.dart';
import 'package:evently/view/screens/home/home_screen.dart';
import 'package:evently/view/screens/home/map_screen.dart';
import 'package:evently/view/screens/intro_screen.dart';
import 'package:evently/view/screens/onboarding_screen.dart';
import 'package:evently/view/screens/splash_screen.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'core/cache_helper/cache_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await CacheHelper.init();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }

  runApp(
     MultiProvider(
       providers: [
         ChangeNotifierProvider(create: (context) => AppProvider(),),
         ChangeNotifierProvider(create: (context) => UserProvider(),),
       ],
       child: EasyLocalization(
          supportedLocales: [Locale('en'), Locale('ar')],
          path: 'assets/translations',
          fallbackLocale: Locale('en'),
          child: Evently(),
        ),
     ),
  );
}

class Evently extends StatelessWidget {
  const Evently({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppProvider>(context);
    BaseTheme lightTheme = LightTheme();
    BaseTheme darkTheme = DarkTheme();
    return ScreenUtilInit(
      designSize: Size(393, 841),
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: lightTheme.theme_data,
          darkTheme: darkTheme.theme_data,
          themeMode: provider.themeMode,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          initialRoute: SplashScreen.routeName,
          routes: {
            SplashScreen.routeName: (context) => SplashScreen(),
            IntroScreen.routeName: (context) => IntroScreen(),
            OnboardingScreen.routeName: (context) => OnboardingScreen(),
            LoginScreen.routeName: (context) => LoginScreen(),
            SignupScreen.routeName: (context) => SignupScreen(),
            ForgetPassScreen.routeName: (context) => ForgetPassScreen(),
            HomeScreen.routeName: (context) => HomeScreen(),
            AddEventScreen.routeName: (context) => AddEventScreen(),
            EventDetailsScreen.routeName: (context) => EventDetailsScreen(),
            MapScreen.routeName: (context) => MapScreen(),
          },
        );
      },
    );
  }
}
