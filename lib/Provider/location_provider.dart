import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationProvider extends ChangeNotifier {
  String _cityName = 'Mendeteksi...';
  String _fullAddress = 'Mendeteksi lokasi...';
  double? _latitude;
  double? _longitude;

  String get cityName => _cityName;
  String get fullAddress => _fullAddress;
  double? get latitude => _latitude;
  double? get longitude => _longitude;

  Future<void> fetchLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _cityName = 'GPS Mati';
        _fullAddress = 'GPS Mati';
        notifyListeners();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _cityName = 'Izin Ditolak';
          _fullAddress = 'Izin lokasi ditolak';
          notifyListeners();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _cityName = 'Izin Ditolak';
        _fullAddress = 'Izin lokasi ditolak permanen';
        notifyListeners();
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      _latitude = position.latitude;
      _longitude = position.longitude;

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        _cityName = '${place.subAdministrativeArea ?? place.locality ?? 'Unknown'}, Indonesia';
        _fullAddress = '${place.street ?? ''}, ${place.subLocality ?? ''}, ${place.subAdministrativeArea ?? ''}';
      }

      notifyListeners();
    } catch (e) {
      _cityName = 'Gagal Deteksi';
      _fullAddress = 'Gagal mendeteksi lokasi';
      notifyListeners();
    }
  }
}