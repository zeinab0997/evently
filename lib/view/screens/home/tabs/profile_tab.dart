import 'package:evently/core/firebase/firebase_manager.dart';
import 'package:evently/core/provider/app_provider.dart';
import 'package:evently/core/provider/user_provider.dart';
import 'package:evently/core/utils/app_colors.dart';
import 'package:evently/core/utils/app_images.dart';
import 'package:evently/view/items/elevated_btn_item.dart';
import 'package:evently/view/screens/auth/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppProvider>(context);
    var userProvider = Provider.of<UserProvider>(context);

    final List<String> languages = ['eng'.tr(), 'ar'.tr()];
    final List<String> themes = ['light'.tr(), 'dark'.tr()];

    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: AppColors.primary_color,
              borderRadius: BorderRadius.only(
                bottomLeft:
                    provider.isEngLang() ? Radius.circular(64.r) : Radius.zero,
                bottomRight:
                    !provider.isEngLang() ? Radius.circular(64.r) : Radius.zero,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.r),
                  width: 124.w,
                  height: 124.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(64.r),
                      bottomRight: Radius.circular(64.r),
                      topRight: provider.isEngLang()? Radius.circular(64.r): Radius.zero,
                      topLeft: !provider.isEngLang()? Radius.circular(64.r): Radius.zero,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      "${userProvider.userModel!.name.split(" ")[0]}",
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: AppColors.primary_color,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        userProvider.userModel!.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        userProvider.userModel!.email,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium!.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 24.h, bottom: 48.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "language".tr(),
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  buildDropDownList(
                    provider: provider,
                    value: languages[provider.languageCode == "en" ? 0 : 1],
                    items: languages,
                    onChanged: (String? newValue) {
                      final index = languages.indexOf(newValue!);
                      provider.changeLanguage(context, index);
                    },
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "theme".tr(),
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  buildDropDownList(
                    provider: provider,
                    value: themes[provider.themeMode == ThemeMode.light ? 0 : 1],
                    items: themes,
                    onChanged: (String? value) {
                      final index = themes.indexOf(value!);
                      provider.changeTheme(index);
                    },
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: () => logoutBtn(provider),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(16.r),
                      ),
                      backgroundColor: AppColors.red_color,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(12.r),
                      child: Row(
                        children: [
                          Icon(
                            Icons.logout_rounded,
                            color: Colors.white,
                            size: 32.r,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            "logout".tr(),
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium!.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDropDownList({
    required AppProvider provider,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      dropdownColor: provider.isThemeDark()? Colors.black: Colors.white,
      icon: const Icon(Icons.arrow_drop_down, color: AppColors.primary_color),
      style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blue),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blue),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      items:
          items.map((e) {
            return DropdownMenuItem<String>(value: e, child: Text(e));
          }).toList(),
      onChanged: onChanged,
    );
  }

  logoutBtn(AppProvider provider) {
    FirebaseManager.logout();
    provider.changeTabIndex(0);
    provider.changeCatIndex(0);
    provider.changeAddEventCatIndex(0);
    Navigator.pushNamedAndRemoveUntil(
      context,
      LoginScreen.routeName,
      (route) => false,
    );
  }
}
