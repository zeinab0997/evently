import 'package:evently/core/provider/app_provider.dart';
import 'package:evently/model/location_model.dart';
import 'package:evently/view/items/elevated_btn_item.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:evently/core/geolocator/geolocatorFunc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_places_flutter/google_places_flutter.dart';

class MapScreen extends StatefulWidget {
  static const String routeName = "MAP_SCREEN";

  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  TextEditingController searchController = TextEditingController();

  late CameraPosition initCamera;

  Set<Marker> markers = {};
  List<Placemark> placeMarks = [];

  late GoogleMapController googleController;

  Position? location;

  LatLng? userPosition;

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  void getLocation() async {
    try {
      location = await GeolocatorFunc.determinePosition();
      userPosition = LatLng(location!.latitude, location!.longitude);
      placeMarks = await placemarkFromCoordinates(
        location!.latitude,
        location!.longitude,
      );
      if (placeMarks.isEmpty) {
        print("❗ Places are empty!");
      } else {
        print("✅ Country: ${placeMarks[0].country}");
      }

      setState(() {
        LatLng latLng = LatLng(location!.latitude, location!.longitude);
        markers.add(Marker(markerId: MarkerId("1"), position: latLng));
        initCamera = CameraPosition(target: latLng, zoom: 18);
      });
    } catch (e) {
      print("🚨 Error in getLocation: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppProvider>(context);
    return location == null
        ? SafeArea(child: Center(child: CircularProgressIndicator()))
        : SafeArea(
          child: Scaffold(
            body: Stack(
              children: [
                GoogleMap(
                  myLocationEnabled: true,
                  onTap: (LatLng position) async {
                    placeMarks = await placemarkFromCoordinates(
                      position.latitude,
                      position.longitude,
                    );
                    userPosition = LatLng(
                      position.latitude,
                      position.longitude,
                    );
                    setState(() {
                      markers.add(
                        Marker(markerId: MarkerId("1"), position: position),
                      );
                    });
                  },
                  initialCameraPosition: initCamera,
                  markers: markers,
                  onMapCreated: (controller) {
                    googleController = controller;
                  },
                ),
                Padding(
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // placesAutoCompleteTextField(),
                      ElevatedBtnItem(
                        label: "select_location".tr(),
                        isFilled: true,
                        onClicked: () {
                          Navigator.pop(
                            context,
                            LocationModel(
                              latitude: userPosition!.latitude,
                              longitude: userPosition!.longitude,
                              country: placeMarks[0].country ?? "No Country!",
                              city:
                                  placeMarks[0].administrativeArea?.replaceAll(
                                    "Governorate",
                                    "",
                                  ) ??
                                  "No Adm!",
                            ),
                          );
                        },
                        provider: provider,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
  }
  //
  // placesAutoCompleteTextField() {
  //   return Container(
  //     padding: EdgeInsets.symmetric(horizontal: 16.r),
  //     child: GooglePlaceAutoCompleteTextField(
  //       textEditingController: searchController,
  //       googleAPIKey: "AIzaSyDtbzH1RGT2TN6fIHsQg8yOw2m61uuecFs",
  //       inputDecoration: InputDecoration(
  //         hintText: "Search your location",
  //         border: InputBorder.none,
  //         enabledBorder: InputBorder.none,
  //       ),
  //       debounceTime: 400,
  //       countries: ["eg",],
  //       isLatLngRequired: true,
  //       getPlaceDetailWithLatLng: (prediction) {
  //         print("placeDetails" + prediction.lat.toString());
  //       },
  //
  //       itemClick: (prediction) {
  //         searchController.text = prediction.description ?? "";
  //         searchController.selection = TextSelection.fromPosition(
  //           TextPosition(offset: prediction.description?.length ?? 0),
  //         );
  //       },
  //       seperatedBuilder: Divider(),
  //       containerHorizontalPadding: 10,
  //
  //       // OPTIONAL// If you want to customize list view item builder
  //       itemBuilder: (context, index, prediction) {
  //         return Container(
  //           padding: EdgeInsets.all(10),
  //           child: Row(
  //             children: [
  //               Icon(Icons.location_on),
  //               SizedBox(width: 7),
  //               Expanded(child: Text("${prediction.description ?? ""}")),
  //             ],
  //           ),
  //         );
  //       },
  //
  //       isCrossBtnShown: true,
  //
  //       // default 600 ms ,
  //     ),
  //   );
  // }
}
