import 'package:evently/core/firebase/firebase_manager.dart';
import 'package:evently/core/provider/app_provider.dart';
import 'package:evently/core/provider/user_provider.dart';
import 'package:evently/core/utils/app_colors.dart';
import 'package:evently/model/event_model.dart';
import 'package:evently/view/items/event_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoveTab extends StatefulWidget {
  const LoveTab({super.key});

  @override
  State<LoveTab> createState() => _LoveTabState();
}

class _LoveTabState extends State<LoveTab> {
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppProvider>(context);
    var userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.r),
            child: TextField(
              controller: searchController,
              onChanged: (_) => setState(() {}),
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: AppColors.primary_color,
                fontWeight: FontWeight.bold,
              ),
              cursorColor: AppColors.primary_color,
              decoration: InputDecoration(
                hint: Text(
                  "search_event".tr(),
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: AppColors.primary_color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                prefixIcon: Icon(
                  CupertinoIcons.search,
                  color: AppColors.primary_color,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(color: AppColors.primary_color),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(color: AppColors.primary_color),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(color: AppColors.primary_color),
                ),
              ),
            ),
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot<EventModel>>(
              stream: FirebaseManager.getEvents(0),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary_color,
                    ),
                  );
                }

                if (!snapshot.hasData ||
                    userProvider.userModel!.favEvents.isEmpty) {
                  return Center(
                    child: Text(
                      "add_to_fav".tr(),
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                final allEvents =
                    snapshot.data!.docs.map((doc) {
                      final event = doc.data();
                      event.id = doc.id;
                      return event;
                    }).toList();

                final favoriteIds = userProvider.userModel!.favEvents;
                final favEvents =
                    allEvents.where((e) => favoriteIds.contains(e.id)).toList();

                final searchQuery = searchController.text.trim().toLowerCase();
                final filteredEvents =
                    searchQuery.isEmpty
                        ? favEvents
                        : favEvents
                            .where(
                              (event) => event.title.toLowerCase().contains(
                                searchQuery,
                              ),
                            )
                            .toList();

                return Padding(
                  padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
                  child: Column(
                    children: [
                      filteredEvents.isEmpty
                          ? Expanded(
                            child: Center(
                              child: Text(
                                "add_to_fav".tr(),
                                style: Theme.of(context).textTheme.titleMedium,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                          : Expanded(
                            child: ListView.builder(
                              itemBuilder: (context, index) {
                                final event = filteredEvents[index];
                                return EventItem(
                                  isFav: true,
                                  userProvider: userProvider,
                                  provider: provider,
                                  eventModel: event,
                                );
                              },
                              itemCount: filteredEvents.length,
                            ),
                          ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
