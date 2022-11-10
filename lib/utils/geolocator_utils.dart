import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:radency_internship_project_2/models/location.dart';

class GeolocatorUtils {
  Future<Position> determinePosition() async {
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
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Future<ExpenseLocation> convertCoordinatesToExpenseLocation(
      {@required double latitude, @required double longitude, @required String languageCode}) async {
    String _newAddress = '';

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude, localeIdentifier: languageCode);
      if (placemarks[0].locality != '') {
        _newAddress += placemarks[0].locality;
      } else {
        if (placemarks[0].country != '') {
          _newAddress += placemarks[0].country;
        }
        if (placemarks[0].administrativeArea != '') {
          _newAddress += ", " + placemarks[0].administrativeArea;
        }
      }

      if (placemarks[0].thoroughfare != '' && placemarks[0].thoroughfare != 'Unnamed Road') {
        _newAddress += ", " + placemarks[0].thoroughfare;
        if (placemarks[0].subThoroughfare != '') {
          _newAddress += ", " + placemarks[0].subThoroughfare;
        }
      } else {
        if (placemarks[0].subLocality != '') {
          _newAddress += ", " + placemarks[0].subLocality;
        }
      }
    } catch (e) {
      print('_convertCoordinatesToExpenseLocation: placemarks error $e');
    }

    return ExpenseLocation(address: _newAddress, latitude: latitude, longitude: longitude);
  }
}