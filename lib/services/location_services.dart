import 'package:date_format/date_format.dart';
import 'package:geolocator/geolocator.dart';
import 'package:knowme/models/lat_laong.dart';

class LocationServices {
  static Future<LatLng?> getLocation() async {
    await Geolocator.requestPermission();
    final permission = await Geolocator.checkPermission();
    if (permission != LocationPermission.denied && permission != LocationPermission.deniedForever) {
      final position = await Geolocator.getCurrentPosition();
      final latLng = LatLng(lat: position.latitude, lng: position.longitude);
      return latLng;
    }

    return null;
  }
}
