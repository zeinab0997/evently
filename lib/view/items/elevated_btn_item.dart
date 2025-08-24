import 'package:evently/core/provider/app_provider.dart';
import 'package:evently/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ElevatedBtnItem extends StatelessWidget {
  String label;
  bool isFilled;
  String? icon;
  Function onClicked;
  AppProvider provider;

  ElevatedBtnItem({
    super.key,
    required this.label,
    required this.isFilled,
    this.icon,
    required this.onClicked,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: provider.isLoading? null :() {
          onClicked();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isFilled
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).secondaryHeaderColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
            side: BorderSide(color: Theme.of(context).primaryColor, width: 1.r),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:
                provider.isLoading
                    ? [
                      CircularProgressIndicator(color: AppColors.primary_color),
                    ]
                    : [
                      icon != null
                          ? Image.asset(icon!, width: 24.w, height: 24.h)
                          : SizedBox(),
                      SizedBox(width: icon != null ? 10.w : 0),
                      Text(
                        label,
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium!.copyWith(
                          color:
                              icon != null
                                  ? Theme.of(context).primaryColor
                                  : Colors.white,
                        ),
                      ),
                    ],
          ),
        ),
      ),
    );
  }
}
