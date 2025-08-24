import 'package:evently/core/provider/app_provider.dart';
import 'package:evently/core/provider/user_provider.dart';
import 'package:evently/core/utils/app_colors.dart';
import 'package:evently/core/utils/app_images.dart';
import 'package:evently/core/utils/app_lists.dart';
import 'package:evently/core/firebase/firebase_manager.dart';
import 'package:evently/model/event_model.dart';
import 'package:evently/view/screens/home/add_event_screen.dart';
import 'package:evently/view/screens/home/event_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class EventItem extends StatefulWidget {
  AppProvider provider;
  UserProvider userProvider;
  EventModel eventModel;
  bool isFav = false;

  EventItem(
      {super.key, required this.provider, required this.eventModel, required this.userProvider, required this.isFav});

  @override
  State<EventItem> createState() => _EventItemState();
}

class _EventItemState extends State<EventItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Navigator.pushNamed(context, EventDetailsScreen.routeName,
              arguments: widget.eventModel),
      child: Container(
        padding: EdgeInsets.all(8.r),
        margin: EdgeInsets.only(bottom: 16.h),
        width: double.infinity,
        height: 208.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.primary_color, width: 1.r),
          image: DecorationImage(
            image: AssetImage(
                AppLists.categories_images[widget.eventModel.catIndex]),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color:
                    widget.provider.isThemeDark()
                        ? AppColors.dark_bg_color
                        : AppColors.bg_color,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Column(
                    children: [
                      Text(
                        DateTime.fromMillisecondsSinceEpoch(
                          widget.eventModel.date,
                        ).toString().substring(8, 10),
                        style: Theme
                            .of(context)
                            .textTheme
                            .titleMedium,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        DateFormat('MMM', context.locale.languageCode).format(
                          DateTime.fromMillisecondsSinceEpoch(
                              widget.eventModel.date),
                        ),
                        style: Theme
                            .of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(
                          color: AppColors.primary_color,
                        ),
                      ),
                    ],
                  ),
                ),

              ],
            ),
            Container(
                width: double.infinity,
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color:
                  widget.provider.isThemeDark()
                      ? AppColors.dark_bg_color
                      : AppColors.bg_color,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  Text(
                  widget.eventModel.title,
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(
                    color: Theme
                        .of(context)
                        .hintColor,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                GestureDetector(
                    onTap: () async {
                      if (widget.userProvider.userModel!.favEvents
                          .contains(widget.eventModel.id)) {
                        widget.userProvider.userModel!.favEvents.remove(
                            widget.eventModel.id);
                        FirebaseManager.updateUser(
                            widget.userProvider.userModel!.id,
                            "favEvents",
                            widget.userProvider.userModel!.favEvents);
                        await widget.userProvider.initUser();
                        setState(() {
                          widget.isFav = false;
                        });
                      } else {
                        widget.userProvider.userModel!.favEvents.add(
                            widget.eventModel.id);
                        FirebaseManager.updateUser(
                            widget.userProvider.userModel!.id,
                            "favEvents",
                            widget.userProvider.userModel!.favEvents);
                        await widget.userProvider.initUser();
                        setState(() {
                          widget.isFav = true;
                        });
                      }
                    },
                    child: Image.asset(widget.isFav? AppImages.ic_like_filled: AppImages.ic_like, width: 24.w,
                    height: 24.h)),
          ],
        ),
      ),
      ],
    ),)
    ,
    );
  }
}
