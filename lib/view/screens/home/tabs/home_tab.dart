import 'package:evently/core/provider/app_provider.dart';
import 'package:evently/core/provider/user_provider.dart';
import 'package:evently/core/utils/app_colors.dart';
import 'package:evently/core/utils/app_images.dart';
import 'package:evently/core/utils/app_lists.dart';
import 'package:evently/core/firebase/firebase_manager.dart';
import 'package:evently/model/event_model.dart';
import 'package:evently/view/items/category_item.dart';
import 'package:evently/view/items/event_item.dart';
import 'package:evently/view/items/home_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppProvider>(context);
    var userProvider = Provider.of<UserProvider>(context);
    return Column(
      children: [
        HomeAppbar(provider: provider),
        Expanded(
          child: StreamBuilder<QuerySnapshot<EventModel>>(
            stream: FirebaseManager.getEvents(provider.selectedCatIndex),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary_color,
                  ),
                );
              } else if ((snapshot.data?.docs.isEmpty ?? true) ||
                  snapshot.data?.docs.length == 0) {
                return Center(
                  child: Text(
                    "add_events_to_see".tr(),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                );
              }
              return Padding(
                padding: EdgeInsets.only(top: 16.h, left: 16.w, right: 16.w),
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return EventItem(
                      isFav: userProvider.userModel!.favEvents.contains(
                        snapshot.data!.docs[index].data().id,
                      ),
                      userProvider: userProvider,
                      provider: provider,
                      eventModel: snapshot.data!.docs[index].data(),
                    );
                  },
                  itemCount: snapshot.data?.docs.length ?? 0,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
