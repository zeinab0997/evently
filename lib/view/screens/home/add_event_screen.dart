import 'package:evently/core/provider/app_provider.dart';
import 'package:evently/core/utils/app_colors.dart';
import 'package:evently/core/utils/app_images.dart';
import 'package:evently/core/utils/app_lists.dart';
import 'package:evently/core/utils/app_validator.dart';
import 'package:evently/core/utils/reusable_func.dart';
import 'package:evently/core/firebase/firebase_manager.dart';
import 'package:evently/model/event_model.dart';
import 'package:evently/model/location_model.dart';
import 'package:evently/view/items/add_event_cat_item.dart';
import 'package:evently/view/items/choose_location_field.dart';
import 'package:evently/view/items/elevated_btn_item.dart';
import 'package:evently/view/items/text_field_item.dart';
import 'package:evently/view/screens/home/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AddEventScreen extends StatefulWidget {
  static const String routeName = "ADD_EVENT_SCREEN";
  EventModel? eventModel;

  AddEventScreen({super.key, this.eventModel});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  LocationModel? userLocation;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<AppProvider>(context, listen: false);

      if (widget.eventModel != null) {
        provider.changeAddEventCatIndex(widget.eventModel!.catIndex);
        titleController.text = widget.eventModel!.title;
        descController.text = widget.eventModel!.description;
        provider.changeSelectedDate(
          DateTime.fromMillisecondsSinceEpoch(widget.eventModel!.date),
        );
        provider.changeSelectedTime(
          TimeOfDay(
            hour: widget.eventModel!.time ~/ 60,
            minute: widget.eventModel!.time % 60,
          ),
        );
        userLocation = widget.eventModel!.location;
      } else {
        provider.changeAddEventCatIndex(0); // or any default
      }
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.eventModel != null ? "edit_event" : "create_event".tr(),
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
            color: AppColors.primary_color,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            provider.changeSelectedDate(null);
            provider.changeSelectedTime(null);
            provider.changeAddEventCatIndex(0);
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(AppLists.categories_images[provider
                            .selectedAddEventCatIndex],
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 16.h),
                  SizedBox(
                    height: 40.h,
                    child: ListView.separated(
                      separatorBuilder:
                          (context, index) => SizedBox(width: 10.w),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return AddEventCatItem(
                          provider: provider,
                          icon: AppLists.categories_icons[index],
                          text: AppLists.categories[index],
                          index: index,
                        );
                      },
                      itemCount: AppLists.categories.length,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "title".tr(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: 8.h),
                  TextFormFieldItem(
                    provider: provider,
                    prefixIcon: AppImages.ic_edit,
                    isPass: false,
                    label: "event_title".tr(),
                    maxLines: 1,
                    controller: titleController,
                    validator: AppValidator.validateTitle,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "desc".tr(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: 8.h),
                  TextFormFieldItem(
                    provider: provider,
                    prefixIcon: null,
                    isPass: false,
                    label: "event_desc".tr(),
                    maxLines: 3,
                    controller: descController,
                    validator: AppValidator.validateDesc,
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_month_outlined,
                        size: 24.r,
                        color: Theme.of(context).hintColor,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        "event_date".tr(),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Spacer(),
                      TextButton(
                        onPressed: () async {
                          var selected = await showDatePicker(
                            initialDate: DateTime.now(),
                            locale: context.locale,
                            context: context,
                            builder: (context, child) {
                              return Theme(
                                data: ThemeData(
                                  colorScheme: Theme.of(
                                    context,
                                  ).colorScheme.copyWith(
                                    primary: AppColors.primary_color,
                                  ),
                                ),
                                child: child!,
                              );
                            },
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(Duration(days: 365)),
                          );
                          if (selected != null) {
                            provider.changeSelectedDate(selected);
                          }
                        },
                        child: Text(
                          provider.selectedDate == null
                              ? "choose_date".tr()
                              : provider.selectedDate.toString().substring(
                                0,
                                10,
                              ),
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(color: AppColors.primary_color),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 24.r,
                        color: Theme.of(context).hintColor,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        "event_time".tr(),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Spacer(),
                      TextButton(
                        onPressed: () async {
                          final TimeOfDay? picked = await showTimePicker(
                            context: context,
                            builder: (context, child) {
                              return Theme(
                                data: ThemeData(
                                  colorScheme: Theme.of(
                                    context,
                                  ).colorScheme.copyWith(
                                    primary: AppColors.primary_color,
                                  ),
                                ),
                                child: child!,
                              );
                            },
                            initialTime: TimeOfDay.now(),
                          );
                          if (picked != null) {
                            provider.changeSelectedTime(picked);
                          }
                        },
                        child: Text(
                          provider.selectedTime == null
                              ? "choose_time".tr()
                              : formatTimeOfDay(
                                provider.selectedTime!,
                                locale: provider.languageCode,
                              ),
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(color: AppColors.primary_color),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "location".tr(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: 8.h),
                  ChooseLocationField(
                    isDetailsScreen: false,
                    provider: provider,
                    location: userLocation == null ? null : userLocation,
                    onclick: () async {
                      var location = await Navigator.pushNamed(
                        context,
                        MapScreen.routeName,
                      );
                      if (location != null) {
                        userLocation = location as LocationModel;
                        setState(() {});
                      }
                    },
                  ),
                  SizedBox(height: 16.h),
                  ElevatedBtnItem(
                    provider: provider,
                    label:
                        widget.eventModel != null
                            ? "update_event".tr()
                            : "add_event".tr(),
                    isFilled: true,
                    onClicked: () {
                      if (provider.selectedDate == null) {
                        ReusableFunc.showSnackBar(
                          context: context,
                          message: "select_date".tr(),
                        );
                      } else if (provider.selectedTime == null) {
                        ReusableFunc.showSnackBar(
                          context: context,
                          message: "select_time".tr(),
                        );
                      } else if (userLocation == null) {
                        ReusableFunc.showSnackBar(
                          context: context,
                          message: "${"select_location".tr()}!",
                        );
                      } else {
                        if (_formKey.currentState!.validate()) {
                          provider.changeLoadingState(true);
                          widget.eventModel != null
                              ? FirebaseManager.updateEvent(
                                EventModel(
                                  userId: FirebaseAuth.instance.currentUser!.uid,
                                  id: widget.eventModel!.id,
                                  title: titleController.text,
                                  description: descController.text,
                                  isDone: false,
                                  date:
                                      provider
                                          .selectedDate!
                                          .millisecondsSinceEpoch,
                                  time:
                                      provider.selectedTime!.hour * 60 +
                                      provider.selectedTime!.minute,
                                  location: userLocation!,
                                  catIndex: provider.selectedAddEventCatIndex,
                                ),
                              )
                              : FirebaseManager.addEvent(
                                EventModel(
                                  userId: FirebaseAuth.instance.currentUser!.uid,
                                  title: titleController.text,
                                  description: descController.text,
                                  isDone: false,
                                  date:
                                      provider
                                          .selectedDate!
                                          .millisecondsSinceEpoch,
                                  time:
                                      provider.selectedTime!.hour * 60 +
                                      provider.selectedTime!.minute,
                                  location: userLocation!,
                                  catIndex: provider.selectedAddEventCatIndex,
                                ),
                              );
                          provider.changeLoadingState(false);
                          provider.changeSelectedDate(null);
                          provider.changeSelectedTime(null);
                          provider.changeAddEventCatIndex(0);
                          provider.changeTabIndex(0);
                          Navigator.pop(context);
                        } else {
                          ReusableFunc.showSnackBar(
                            context: context,
                            message: "enter_required_fields".tr(),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String formatTimeOfDay(TimeOfDay time, {String? locale}) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);

    return DateFormat.jm(locale).format(dt); // 12:22 PM or ١٢:٢٢ م
  }
}
