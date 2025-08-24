import 'package:evently/core/provider/app_provider.dart';
import 'package:evently/core/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:evently/core/utils/app_colors.dart';
import 'package:evently/core/utils/app_images.dart';
import 'package:evently/core/utils/app_lists.dart';
import 'package:evently/view/items/category_item.dart';
import 'package:provider/provider.dart';

class HomeAppbar extends StatelessWidget {
  AppProvider provider;

  HomeAppbar({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    var user = userProvider.userModel;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color:
            provider.isThemeDark()
                ? AppColors.dark_bg_color
                : AppColors.primary_color,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(24.r),
          bottomLeft: Radius.circular(24.r),
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              user == null
                  ? SizedBox(
                    height: 150.h,
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  )
                  : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "welcome".tr(),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        userProvider.userModel!.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Image.asset(AppImages.ic_location),
                          SizedBox(width: 4.w),
                          Text(
                            "${userProvider.userModel!.userLocation.country}, ${userProvider.userModel!.userLocation.city}",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      provider.swipeTheme();
                    },
                    child: Image.asset(
                      provider.isThemeDark()
                          ? AppImages.ic_dark
                          : AppImages.ic_light,
                      width: 32.w,
                      height: 32.h,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  GestureDetector(
                    onTap: () {
                      provider.swipeLanguage(context);
                    },
                    child: Container(
                      padding: EdgeInsets.all(6.r),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        "en".tr(),
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.bold,
                          color:
                              provider.isThemeDark()
                                  ? AppColors.dark_bg_color
                                  : AppColors.primary_color,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16.h),
          SizedBox(
            height: 40.h,
            child: ListView.separated(
              separatorBuilder: (context, index) => SizedBox(width: 10.w),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return CategoryItem(
                  provider: provider,
                  icon: AppLists.all_categories_icons[index],
                  text: AppLists.all_categories[index],
                  index: index,
                );
              },
              itemCount: AppLists.all_categories.length,
            ),
          ),
        ],
      ),
    );
  }
}
