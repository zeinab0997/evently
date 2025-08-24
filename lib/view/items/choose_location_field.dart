import 'package:evently/core/provider/app_provider.dart';
import 'package:evently/core/utils/app_colors.dart';
import 'package:evently/model/location_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

class ChooseLocationField extends StatelessWidget {
  AppProvider provider;
  LocationModel? location;
  Function onclick;
  bool isDetailsScreen;
  bool userLoc;

  ChooseLocationField({
    super.key,
    required this.provider,
    required this.location,
    required this.onclick,
    required this.isDetailsScreen,
    this.userLoc = false
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.primary_color, width: 1.r),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: AppColors.primary_color,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.my_location,
              size: 24.r,
              color:
                  provider.isThemeDark()
                      ? AppColors.dark_bg_color
                      : Colors.white,
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            location == null ? userLoc ? "choose_your_location".tr():"choose_event_locations".tr():
            "${location!.country}, ${location!.city}",
            style: Theme.of(
              context,
            ).textTheme.bodyMedium!.copyWith(color: AppColors.primary_color),
          ),
          Spacer(),
          isDetailsScreen? SizedBox():IconButton(
            onPressed: () {
              onclick();
            },
            icon: Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.primary_color,
              size: 24.r,
            ),
          ),
        ],
      ),
    );
  }
}
