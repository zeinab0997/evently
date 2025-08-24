import 'package:evently/core/firebase/firebase_manager.dart';
import 'package:evently/core/provider/app_provider.dart';
import 'package:evently/core/utils/app_colors.dart';
import 'package:evently/core/utils/app_images.dart';
import 'package:evently/core/utils/app_validator.dart';
import 'package:evently/core/utils/reusable_func.dart';
import 'package:evently/view/items/elevated_btn_item.dart';
import 'package:evently/view/items/text_field_item.dart';
import 'package:evently/view/screens/auth/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class ForgetPassScreen extends StatefulWidget {
  static const String routeName = "FORGET_PASSWORD_SCREEN";

  ForgetPassScreen({super.key});

  @override
  State<ForgetPassScreen> createState() => _ForgetPassScreenState();
}

class _ForgetPassScreenState extends State<ForgetPassScreen> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppProvider>(context);

    final _formKey = GlobalKey<FormState>();
    TextEditingController emailController = TextEditingController();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "forget_pass_title".tr(),
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
                  Image.asset(AppImages.forget_pass_img),
                  SizedBox(height: 24.h),
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
                  ElevatedBtnItem(
                    label: "reset_pass",
                    isFilled: true,
                    onClicked: () {
                      FirebaseManager.forgetPass(
                        email: emailController.text,
                        onLoading: () {
                          showDialog(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  backgroundColor: Colors.transparent,
                                  title: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                          );
                        },
                        onSuccess: (){
                          ReusableFunc.showSnackBar(
                            context: context,
                            message:  '${"reset_email_sent".tr()} ${emailController.text}',
                          );
                          Navigator.pushNamedAndRemoveUntil(context, LoginScreen.routeName, (route) => false,);
                        },
                        onError: (message) {
                          Navigator.pop(context);
                          ReusableFunc.showSnackBar(
                            context: context,
                            message: message,
                          );
                        },
                      );
                    },
                    provider: provider,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
