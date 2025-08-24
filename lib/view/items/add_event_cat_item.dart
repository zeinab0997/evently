import 'package:evently/core/provider/app_provider.dart';
import 'package:evently/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class AddEventCatItem extends StatelessWidget {
  AppProvider provider;
  String text;
  String icon;
  int index;

  AddEventCatItem({
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
        provider.changeAddEventCatIndex(index);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color:
              provider.selectedAddEventCatIndex == index
                  ? AppColors.primary_color
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(48.r),
          border: Border.all(color: AppColors.primary_color, width: 1.r),
        ),
        child: Row(
          children: [
            Image.asset(
              icon,
              width: 24.w,
              height: 24.h,
              color:
                  provider.selectedAddEventCatIndex == index
                      ? provider.isThemeDark()
                          ? AppColors.dark_bg_color
                          : Colors.white
                      : AppColors.primary_color,
            ),
            SizedBox(width: 4.w),
            Text(
              text.tr(),
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color:
                    provider.selectedAddEventCatIndex == index
                        ? provider.isThemeDark()
                            ? AppColors.dark_bg_color
                            : Colors.white
                        : AppColors.primary_color,
              ),
            ),
          ],
        ),
      ),
    );
    ;
  }
}
