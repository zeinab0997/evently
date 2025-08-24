import 'package:geolocator/geolocator.dart';

class GeolocatorFunc {
  static Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('❌ Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      return Future.error(
        '❌ Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if(!serviceEnabled){
      Geolocator.openLocationSettings();
      return Future.error('❌ Location services are disabled!');
    }

    return await Geolocator.getCurrentPosition();
  }
}
