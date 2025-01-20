import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  /// Determine the current position of the device.
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  /// Determine the name of the current location based on coordinates.
  Future<String?> determineLocationName() async {
    Position position = await determinePosition();

    try {
      // Use geocoding to reverse the coordinates.
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;

        // Combine fields for more accurate location details.
        String locationName = [
          place.subLocality, // Specific area, if available.
          place.locality, // City or area name.
          // State or region.
         
        ].where((element) => element != null && element.isNotEmpty).join(', ');

        return locationName.isNotEmpty ? locationName : "Unknown locality";
      } else {
        return "No placemarks found.";
      }
    } catch (e) {
      print('Error while determining location name: $e');
      return null;
    }
  }
}
