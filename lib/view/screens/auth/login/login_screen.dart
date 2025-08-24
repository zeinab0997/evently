import 'package:evently/core/firebase/firebase_manager.dart';
import 'package:evently/core/provider/app_provider.dart';
import 'package:evently/core/provider/user_provider.dart';
import 'package:evently/core/utils/app_images.dart';
import 'package:evently/core/utils/app_validator.dart';
import 'package:evently/core/utils/reusable_func.dart';
import 'package:evently/model/location_model.dart';
import 'package:evently/model/user_model.dart';
import 'package:evently/view/items/elevated_btn_item.dart';
import 'package:evently/view/items/switch_btn_item.dart';
import 'package:evently/view/items/text_field_item.dart';
import 'package:evently/view/screens/auth/forget_pass_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:evently/view/screens/auth/signup_screen.dart';
import 'package:evently/view/screens/home/home_screen.dart';
import 'package:evently/view/screens/home/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = "LOGIN_SCREEN";

  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  LocationModel? userLocation;

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppProvider>(context);
    var userProvider = Provider.of<UserProvider>(context);
    int selectedLanguageIndex = provider.isEngLang() ? 0 : 1;
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(16.r),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Image.asset(AppImages.splash_logo_img),
                  SizedBox(height: 24.h),
                  TextFormFieldItem(
                    controller: emailController,
                    maxLines: 1,
                    provider: provider,
                    prefixIcon: AppImages.ic_email,
                    isPass: false,
                    label: "email".tr(),
                    validator: AppValidator.validateEmail,
                  ),
                  SizedBox(height: 16.h),
                  TextFormFieldItem(
                    controller: passwordController,
                    maxLines: 1,
                    provider: provider,
                    prefixIcon: AppImages.ic_pass,
                    isPass: true,
                    label: "password".tr(),
                    validator: AppValidator.validatePassword,
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    width: double.infinity,
                    alignment: AlignmentDirectional.centerEnd,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          ForgetPassScreen.routeName,
                        );
                      },
                      child: Text(
                        "forget_pass".tr(),
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          decoration: TextDecoration.underline,
                          decorationColor: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  ElevatedBtnItem(
                    label: "login".tr(),
                    isFilled: true,
                    onClicked: () {
                      login(context, userProvider);
                    },
                    provider: provider,
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "dont_have_account".tr(),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, SignupScreen.routeName);
                        },
                        child: Text(
                          "create_account".tr(),
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            decoration: TextDecoration.underline,
                            decorationColor: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Theme.of(context).primaryColor,
                            thickness: 1.r,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Text(
                            "or".tr(),
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium!.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Theme.of(context).primaryColor,
                            thickness: 1.r,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),
                  ElevatedBtnItem(
                    label: "login_with_google".tr(),
                    isFilled: false,
                    icon: AppImages.ic_google,
                    onClicked: () {
                      FirebaseManager.signInWithGoogle(
                        onLoading: () {
                          showDialog(
                            context: context,
                            builder:
                                (_) => const AlertDialog(
                                  backgroundColor: Colors.transparent,
                                  title: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                          );
                        },
                        onError: (message) {
                          print(message);
                          Navigator.pop(context);
                          ReusableFunc.showSnackBar(
                            context: context,
                            message: message,
                          );
                        },
                        onSuccess: () {
                          Navigator.pop(context); // close loading dialog
                          userProvider.initUser(); // ✅ initialize user
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            HomeScreen.routeName,
                            (route) => false,
                          );
                        },
                        completeUserData: (user) async {
                          var location = await Navigator.pushNamed(
                            context,
                            MapScreen.routeName,
                          );
                          if (location != null) {
                            userLocation = location as LocationModel;
                          }
                          googleLogin(context);
                        },
                      );
                    },
                    provider: provider,
                  ),
                  SizedBox(height: 24.h),
                  SwitchBtnItem(
                    selectedIndex: selectedLanguageIndex,
                    option1: AppImages.flag_usa,
                    option2: AppImages.flag_eg,
                    onClick: (index) {
                      provider.changeLanguage(context, index);
                      selectedLanguageIndex = provider.isEngLang() ? 0 : 1;
                    },
                    isTheme: false,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void login(BuildContext context, UserProvider userProvider) {
    FirebaseManager.login(
      email: emailController.text,
      password: passwordController.text,
      onLoading: () {
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                backgroundColor: Colors.transparent,
                title: Center(child: CircularProgressIndicator()),
              ),
        );
      },
      onError: (error) {
        Navigator.pop(context);
        ReusableFunc.showSnackBar(context: context, message: error ?? "");
      },
      onSuccess: () {
        userProvider.initUser();
        Navigator.pushNamedAndRemoveUntil(
          context,
          HomeScreen.routeName,
          (route) => false,
        );
      },
    );
  }

  void googleLogin(BuildContext context) async {
    if (userLocation == null) {
      ReusableFunc.showSnackBar(
        context: context,
        message: "${"select_location".tr()}!",
      );
    } else {
      var user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      UserModel userModel = UserModel(
        id: user.uid,
        email: user.email ?? '',
        name: user.displayName ?? '',
        createdAt: DateTime.now().millisecondsSinceEpoch,
        userLocation: userLocation!,
        // Replace with actual location
        favEvents: [],
      );
      await FirebaseManager.addUser(userModel);

      if (context.mounted) {
        Provider.of<UserProvider>(context, listen: false).initUser();
        Navigator.pushNamedAndRemoveUntil(
          context,
          HomeScreen.routeName,
          (route) => false,
        );
      }
    }
  }
}
