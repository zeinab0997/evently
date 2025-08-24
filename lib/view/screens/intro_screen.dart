import 'package:evently/core/provider/app_provider.dart';
import 'package:evently/core/utils/app_images.dart';
import 'package:evently/view/items/switch_btn_item.dart';
import 'package:evently/view/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

class IntroScreen extends StatelessWidget {
  static const String routeName = "INTRO_SCREEN";

  IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppProvider>(context);
    int selectedLanguageIndex = provider.isEngLang()? 0: 1;
    int selectedThemeIndex = provider.isThemeDark()? 1: 0;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Image.asset(AppImages.app_logo_img)),
        body: Padding(
          padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 16.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 24.h),
                Center(child: Image.asset(provider.isThemeDark()? AppImages.dark_intro_img :AppImages.intro_img, width: 320.w,)),
                SizedBox(height: 24.h),
                Text(
                  "intro_title".tr(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: 24.h),
                Text(
                  "intro_text".tr(),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SizedBox(height: 24.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "language".tr(),
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SwitchBtnItem(
                      selectedIndex: selectedLanguageIndex,
                      option1: AppImages.flag_usa,
                      option2: AppImages.flag_eg,
                      onClick: (index) {
                        provider.changeLanguage(context, index);
                        selectedLanguageIndex = provider.isEngLang()? 0: 1;
                      },
                      isTheme: false,
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "theme".tr(),
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SwitchBtnItem(
                      selectedIndex: selectedThemeIndex,
                      option1: AppImages.ic_light,
                      option2: AppImages.ic_dark,
                      onClick: (index) {
                        provider.changeTheme(index);
                        selectedThemeIndex = provider.isThemeDark()? 1: 0;
                      },
                      isTheme: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(
                context,
                OnboardingScreen.routeName,
              );
            },
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: Text(
                "lets_start".tr(),
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
