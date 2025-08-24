import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:evently/core/firebase/firebase_manager.dart';
import 'package:evently/core/geolocator/geolocatorFunc.dart';
import 'package:evently/core/provider/app_provider.dart';
import 'package:evently/core/provider/user_provider.dart';
import 'package:evently/core/utils/app_colors.dart';
import 'package:evently/core/utils/app_images.dart';
import 'package:evently/core/utils/app_lists.dart';
import 'package:evently/view/items/event_item.dart';
import 'package:evently/view/items/map_event_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapTab extends StatefulWidget {
  MapTab({super.key});

  @override
  State<MapTab> createState() => _MapTabState();
}

class _MapTabState extends State<MapTab> {
  late CameraPosition initCamera;

  Set<Marker> markers = {};

  late GoogleMapController googleController;

  Position? location;

  @override
  void initState() {
    getLocation();
    super.initState();
  }

  void getLocation() async {
    location = await GeolocatorFunc.determinePosition();
    if (!mounted) return; // don't call setState if widget is no longer active
    setState(() {
      LatLng latLng = LatLng(location!.latitude, location!.longitude);
      //markers.add(Marker(markerId: MarkerId("1"), position: latLng));
      initCamera = CameraPosition(target: latLng, zoom: 18);
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppProvider>(context);
    var userProvider = Provider.of<UserProvider>(context);
    return location == null
        ? Center(child: CircularProgressIndicator())
        : StreamBuilder(
          stream: FirebaseManager.getEvents(provider.selectedCatIndex),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary_color,
                ),
              );
            }
            return Scaffold(
              body: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  GoogleMap(
                    initialCameraPosition: initCamera,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    markers: {
                      //...markers, // your location marker
                      ...snapshot.data!.docs.map((doc) {
                        final event = doc.data();
                        final id = doc.id;

                        if (doc.data().location.latitude != null &&
                            doc.data().location.longitude != null) {
                          return Marker(
                            markerId: MarkerId(id),
                            position: LatLng(
                              doc.data().location.latitude,
                              doc.data().location.longitude,
                            ),
                            infoWindow: InfoWindow(
                              title: event.title,
                              //snippet: event.description,
                              onTap: () {
                                // Navigate to event details
                              },
                            ), // optional
                          );
                        } else {
                          return null; // skip events without location
                        }
                      }).whereType<Marker>(), // removes nulls
                    },
                    onMapCreated: (controller) {
                      googleController = controller;
                    },
                  ),
                  Positioned(
                    bottom: 36.h,
                    left: 0,
                    right: 0,
                    child: IgnorePointer(
                      ignoring: false,
                      // change to true if you want the map to receive all touch events
                      child: SizedBox(
                        height: 100.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final event = snapshot.data!.docs[index].data();
                            return MapEventItem(
                              event: event,
                              onEventClicked: () {
                                googleController.animateCamera(
                                  CameraUpdate.newLatLng(
                                    LatLng(
                                      event.location.latitude,
                                      event.location.longitude,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
              floatingActionButton: Padding(
                padding: EdgeInsets.only(top: 16.h),
                child: FloatingActionButton(
                  onPressed: () async {
                    final user = userProvider.userModel;
                    if (user == null) return;

                    googleController.animateCamera(
                      CameraUpdate.newLatLng(
                        LatLng(
                          userProvider.userModel!.userLocation.latitude,
                          userProvider.userModel!.userLocation.longitude
                        ),
                      ),
                    );
                  },
                  child: Icon(
                    Icons.my_location,
                    color:
                        provider.isThemeDark()
                            ? AppColors.dark_bg_color
                            : Colors.white,
                  ),
                  backgroundColor: AppColors.primary_color,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
              ),
            );
          },
        );
  }
}
