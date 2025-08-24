import 'package:evently/core/cache_helper/cache_helper.dart';
import 'package:evently/core/provider/app_provider.dart';
import 'package:evently/core/utils/app_images.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:evently/view/screens/auth/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';


class OnboardingScreen extends StatelessWidget {
  static const String routeName = "ONBOARDING_SCREEN";

  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppProvider>(context);
    var pageDecoration = PageDecoration(
      imageFlex: 3,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Theme.of(context).secondaryHeaderColor,
      imagePadding: EdgeInsets.zero,
    );

    Widget _buildImage(String assetName, [double width = 320]) {
      return Image.asset(assetName, width: width.w);
    }

    return SafeArea(
      child:Scaffold(
        appBar: AppBar(title: Image.asset(AppImages.app_logo_img),),
        body: IntroductionScreen(
            globalBackgroundColor: Theme.of(context).secondaryHeaderColor,
            allowImplicitScrolling: false,
            infiniteAutoScroll: false,
            pages: [
              PageViewModel(
                titleWidget: Align(
                  alignment:  AlignmentDirectional.topStart,
                  child: Text(
                    "onboarding1_title".tr(),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                bodyWidget: Align(
                  alignment: AlignmentDirectional.topStart,
                  child: Text(
                    "onboarding1_text".tr(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                image: _buildImage(provider.isThemeDark()? AppImages.onboarding1_dark_img:AppImages.onboarding1_img),
                decoration: pageDecoration,
              ),
              PageViewModel(
                titleWidget: Align(
                  alignment:  AlignmentDirectional.topStart,
                  child: Text(
                    "onboarding2_title".tr(),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                bodyWidget: Align(
                  alignment:  AlignmentDirectional.topStart,
                  child: Text(
                    "onboarding2_text".tr(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                image: _buildImage(provider.isThemeDark()? AppImages.onboarding2_dark_img:AppImages.onboarding2_img),
                decoration: pageDecoration,
              ),
              PageViewModel(
                titleWidget: Align(
                  alignment:  AlignmentDirectional.topStart,
                  child: Text(
                    "onboarding3_title".tr(),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                bodyWidget: Align(
                  alignment:  AlignmentDirectional.topStart,
                  child: Text(
                    "onboarding3_text".tr(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                image: _buildImage(provider.isThemeDark()? AppImages.onboarding3_dark_img:AppImages.onboarding3_img),
                decoration: pageDecoration,
              ),
            ],
            showBackButton: true,
            showNextButton: true,
            showDoneButton: true,
            //rtl: true, // Display as right-to-left
            back: Container(
              padding: EdgeInsets.all(0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(width: 1.w, color: Theme.of(context).primaryColor),
              ),
              child: Icon(
                Icons.arrow_back,
                color: Theme.of(context).primaryColor,
                size: 24.r,
              ),
            ),
            next: Container(
              padding: EdgeInsets.all(0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(width: 1.w, color: Theme.of(context).primaryColor),
              ),
              child: Icon(
                Icons.arrow_forward,
                color: Theme.of(context).primaryColor,
                size: 24.r,
              ),
            ),
            done: Container(
              padding: EdgeInsets.all(0),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
                border: Border.all(width: 1.w, color: Theme.of(context).primaryColor),
              ),
              child: Icon(Icons.check, color: Colors.white, size: 24.r),
            ),
            onDone: () {
              CacheHelper.saveEligibility();
              Navigator.pushReplacementNamed(context, LoginScreen.routeName);
            },
            curve: Curves.fastLinearToSlowEaseIn,
            dotsDecorator: DotsDecorator(
              size: Size(10.w, 10.h),
              color: Theme.of(context).hintColor,
              activeSize: Size(20.0.w, 10.0.h),
              activeColor: Theme.of(context).primaryColor,
              activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.r)),
              ),
            ),
          ),
      ),

    );
  }
}
