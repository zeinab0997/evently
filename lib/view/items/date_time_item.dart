import 'package:evently/core/provider/app_provider.dart';
import 'package:evently/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class DateTimeItem extends StatelessWidget {
  AppProvider provider;
  int date;
  int time;

  DateTimeItem({
    super.key,
    required this.provider,
    required this.date,
    required this.time,
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
              Icons.calendar_month_outlined,
              size: 24.r,
              color:
                  provider.isThemeDark()
                      ? AppColors.dark_bg_color
                      : Colors.white,
            ),
          ),
          SizedBox(width: 8.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat(
                  'd MMMM yyyy',
                  provider.languageCode,
                ).format(DateTime.fromMillisecondsSinceEpoch(date)),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: AppColors.primary_color,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                TimeOfDay(hour: time ~/ 60, minute:  time % 60).format(context),
                //DateFormat('h:mm a', provider.languageCode).format(DateTime.fromMillisecondsSinceEpoch(time)),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).hintColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
