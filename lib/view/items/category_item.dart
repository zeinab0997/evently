import 'package:evently/core/provider/app_provider.dart';
import 'package:evently/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class CategoryItem extends StatelessWidget {
  AppProvider provider;
  String text;
  String icon;
  int index;

  CategoryItem({
    super.key,
    required this.provider,
    required this.icon,
    required this.text,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        provider.changeCatIndex(index);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color:
              provider.selectedCatIndex == index
                  ? provider.isThemeDark()
                      ? AppColors.dark_primary_color
                      : Colors.white
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(48.r),
          border: Border.all(
            color:
                provider.isThemeDark()
                    ? AppColors.dark_primary_color
                    : Colors.white,
            width: 1.r,
          ),
        ),
        child: Row(
          children: [
            Image.asset(icon, width: 24.w, height: 24.h, color:  provider.selectedCatIndex == index && !provider.isThemeDark()? AppColors.primary_color:Colors.white),
            SizedBox(width: 4.w),
            Text(
              text.tr(),
              style: Theme.of(
                context,
              ).textTheme.bodyMedium!.copyWith(color: provider.selectedCatIndex == index && !provider.isThemeDark()? AppColors.primary_color: Colors.white),
            ),
          ],
        ),
      ),
    );
    ;
  }
}
