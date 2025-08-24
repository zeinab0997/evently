import 'package:evently/core/firebase/firebase_manager.dart';
import 'package:evently/core/provider/app_provider.dart';
import 'package:evently/core/utils/app_colors.dart';
import 'package:evently/core/utils/app_images.dart';
import 'package:evently/core/utils/app_validator.dart';
import 'package:evently/core/utils/reusable_func.dart';
import 'package:evently/model/location_model.dart';
import 'package:evently/view/items/choose_location_field.dart';
import 'package:evently/view/items/elevated_btn_item.dart';
import 'package:evently/view/items/switch_btn_item.dart';
import 'package:evently/view/items/text_field_item.dart';
import 'package:evently/view/screens/home/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class SignupScreen extends StatefulWidget {
  static const String routeName = "SIGNUP_SCREEN";

  SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController nameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController rePasswordController = TextEditingController();

  TextEditingController locationController = TextEditingController();

  LocationModel? userLocation;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppProvider>(context);
    int selectedLanguageIndex = provider.isEngLang() ? 0 : 1;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "register".tr(),
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color:
                  provider.isThemeDark()
                      ? AppColors.dark_primary_color
                      : Theme.of(context).hintColor,
            ),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color:
                  provider.isThemeDark()
                      ? AppColors.dark_primary_color
                      : Theme.of(context).hintColor,
            ),
          ),
        ),
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
                    maxLines: 1,
                    provider: provider,
                    prefixIcon: AppImages.ic_person,
                    isPass: false,
                    label: "name".tr(),
                    controller: nameController,
                    validator: AppValidator.validateName,
                  ),
                  SizedBox(height: 16.h),
                  TextFormFieldItem(
                    maxLines: 1,
                    provider: provider,
                    prefixIcon: AppImages.ic_email,
                    isPass: false,
                    label: "email".tr(),
                    controller: emailController,
                    validator: AppValidator.validateEmail,
                  ),
                  SizedBox(height: 16.h),
                  TextFormFieldItem(
                    maxLines: 1,
                    provider: provider,
                    prefixIcon: AppImages.ic_pass,
                    isPass: true,
                    label: "password".tr(),
                    controller: passwordController,
                    validator: AppValidator.validatePassword,
                  ),
                  SizedBox(height: 16.h),
                  TextFormFieldItem(
                    maxLines: 1,
                    provider: provider,
                    prefixIcon: AppImages.ic_pass,
                    isPass: true,
                    label: "re_password".tr(),
                    controller: rePasswordController,
                    validator: (value) {
                      if (rePasswordController.text == passwordController.text)
                        return null;
                      else
                        return "password_must_be_matched".tr();
                    },
                  ),
                  SizedBox(height: 16.h),
                  ChooseLocationField(
                    userLoc: true,
                    isDetailsScreen: false,
                    provider: provider,
                    location: userLocation == null ? null : userLocation,
                    onclick: () async {
                      var location = await Navigator.pushNamed(
                        context,
                        MapScreen.routeName,
                      );
                      if (location != null) {
                        userLocation = location as LocationModel;
                        setState(() {});
                      }
                    },
                  ),
                  SizedBox(height: 16.h),
                  ElevatedBtnItem(
                    label: "create_account".tr(),
                    isFilled: true,
                    onClicked: () {
                      createAccount(context);
                    },
                    provider: provider,
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "already_have_account".tr(),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Text(
                          "login".tr(),
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

  createAccount(BuildContext context) {
    if(userLocation == null){
      ReusableFunc.showSnackBar(
        context: context,
        message: "${"select_location".tr()}!",
      );
    }else{
      if (_formKey.currentState!.validate()) {
        FirebaseManager.createAccount(
          email: emailController.text,
          password: passwordController.text,
          name: nameController.text,
          userLocation: userLocation!,
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
          onSuccess: () {
            ReusableFunc.showSnackBar(
              context: context,
              message: "account_created".tr(),
            );
            Navigator.pop(context);
          },
          onError: (message) {
            Navigator.pop(context);
            ReusableFunc.showSnackBar(context: context, message: message);
          },
        );
        Navigator.pop(context);
      } else {
        ReusableFunc.showSnackBar(
          context: context,
          message: "enter_required_fields".tr(),
        );
      }
    }
  }
}
