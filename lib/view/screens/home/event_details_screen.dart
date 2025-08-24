import 'package:evently/core/provider/app_provider.dart';
import 'package:evently/core/utils/app_colors.dart';
import 'package:evently/core/utils/app_images.dart';
import 'package:evently/core/utils/app_lists.dart';
import 'package:evently/core/firebase/firebase_manager.dart';
import 'package:evently/model/event_model.dart';
import 'package:evently/model/location_model.dart';
import 'package:evently/view/items/choose_location_field.dart';
import 'package:evently/view/items/date_time_item.dart';
import 'package:evently/view/screens/home/add_event_screen.dart';
import 'package:evently/view/screens/home/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:animated_confirm_dialog/animated_confirm_dialog.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EventDetailsScreen extends StatelessWidget {
  static const String routeName = "EVENT_DETAILS_SCREEN";

  const EventDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppProvider>(context);
    var eventModel = ModalRoute.of(context)!.settings.arguments as EventModel;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "event_details".tr(),
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: AppColors.primary_color,
              fontWeight: FontWeight.w500,
            ),
          ),
          leading: IconButton(
            onPressed: () {
              provider.changeSelectedDate(null);
              provider.changeAddEventCatIndex(0);
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_rounded),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return AddEventScreen(eventModel: eventModel);
                    },
                  ),
                );
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Image.asset(
                  AppImages.ic_edit_pen,
                  width: 24.w,
                  height: 24.h,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                showCustomDialog(
                  context: context,
                  title: "delete_title".tr(),
                  message: "delete_msg".tr(),
                  cancelButtonText: 'no'.tr(),
                  confirmButtonText: 'yes'.tr(),
                  cancelButtonColor: Colors.red,
                  cancelButtonTextColor: Colors.white,
                  confirmButtonColor: Colors.green,
                  confirmButtonTextColor: Colors.white,
                  backgroundColor: Theme.of(context).secondaryHeaderColor,
                  titleColor: Theme.of(context).hintColor,
                  messageColor: Theme.of(context).hintColor,
                  onCancel: () {
                    Navigator.of(context).pop();
                  },
                  onConfirm: () {
                    FirebaseManager.deleteEvent(eventModel.id);
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      HomeScreen.routeName,
                      (route) => false,
                    );
                  },
                  isFlip: true,
                );
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Image.asset(
                  AppImages.ic_delete,
                  width: 24.w,
                  height: 24.h,
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  AppLists.categories_images[eventModel.catIndex],
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 16.h),
                Text(
                  eventModel.title,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: AppColors.primary_color,
                  ),
                ),
                SizedBox(height: 16.h),
                DateTimeItem(
                  provider: provider,
                  date: eventModel.date,
                  time: eventModel.time,
                ),
                SizedBox(height: 16.h),
                ChooseLocationField(
                  provider: provider,
                  location: eventModel.location,
                  onclick: () {},
                  isDetailsScreen: true,
                ),
                SizedBox(height: 16.h),
                Container(
                  height: 350.h,

                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.r),
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                          eventModel.location.latitude,
                          eventModel.location.longitude,
                        ),
                        zoom: 18,
                      ),
                      markers: {
                        Marker(
                          markerId: MarkerId("1"),
                          position: LatLng(
                            eventModel.location.latitude,
                            eventModel.location.longitude,
                          ),
                        ),
                      },
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  "desc".tr(),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SizedBox(height: 8.h),
                Text(
                  eventModel.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
