import 'package:evently/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SwitchBtnItem extends StatelessWidget {
  int selectedIndex;
  String option1;
  String option2;
  Function onClick;
  bool isTheme;

  SwitchBtnItem({
    super.key,
    required this.selectedIndex,
    required this.option1,
    required this.option2,
    required this.onClick,
    required this.isTheme
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primary_color, width: 2.w),
        borderRadius: BorderRadius.circular(64.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => onClick(0),
            child: Container(
              decoration: BoxDecoration(
                color:
                    selectedIndex == 0
                        ? AppColors.primary_color
                        : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color:
                      selectedIndex == 0
                          ? AppColors.primary_color
                          : Colors.transparent,
                  width: 3.w,
                ),
              ),
              child: Image.asset(
                option1,
                color: isTheme ? selectedIndex == 0? Colors.white: AppColors.primary_color: null ,

                width: 22.w,
                height: 22.w,
              ),
            ),
          ),
          SizedBox(width: 8.w,),
          GestureDetector(
            onTap: () => onClick(1),
            child: Container(
              decoration: BoxDecoration(
                color:
                selectedIndex == 1
                    ? AppColors.primary_color
                    : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color:
                  selectedIndex == 1
                      ? AppColors.primary_color
                      : Colors.transparent,
                  width: 3.w,
                ),
              ),
              child: Image.asset(
                option2,
                color: isTheme ? selectedIndex == 1? Colors.white: AppColors.primary_color: null ,
                width: 22.w,
                height: 22.w,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
