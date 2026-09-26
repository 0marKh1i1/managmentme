import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class LocationUtils {
  static Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('location_services_disabled'.tr);
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('location_permissions_denied'.tr);
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('location_permissions_permanently_denied'.tr);
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}
