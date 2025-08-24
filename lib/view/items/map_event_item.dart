import 'package:evently/core/utils/app_colors.dart';
import 'package:evently/core/utils/app_images.dart';
import 'package:evently/core/utils/app_lists.dart';
import 'package:evently/model/event_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class MapEventItem extends StatelessWidget {
  EventModel event;
  Function onEventClicked;
  MapEventItem({super.key, required this.event, required this.onEventClicked});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onEventClicked();
      },
      child: Container(
        margin: EdgeInsets.only(right: 12.w),
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: Theme.of(context).secondaryHeaderColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: AppColors.primary_color,
          ),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: Image.asset(
                AppLists.categories_images[event
                    .catIndex],
              ),
            ),
            SizedBox(width: 8.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  event.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall!.copyWith(
                    color: AppColors.primary_color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Image.asset(
                      AppImages.ic_location,
                      color: Theme.of(context).hintColor,
                    ),
                    SizedBox(width: 4.w),
                    Text( "${event.location.country}, ${event.location.city}",
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall!.copyWith(
                        color:
                        Theme.of(context).hintColor,
                      ),)
                  ],
                )

              ],
            ),
          ],
        ),
      ),
    );;
  }
}
