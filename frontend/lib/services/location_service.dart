import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';

class LocationService {
  final String apiKey = "6974dce81efd48fb9783e02cfdbb1fb8";

  Future<Position> getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
  }

  Future<String?> getDistrictFromPosition(Position position) async {
    final url = Uri.parse(
        'https://api.geoapify.com/v1/geocode/reverse?lat=${position.latitude}&lon=${position.longitude}&apiKey=$apiKey');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['features'] != null && data['features'].isNotEmpty) {
          final properties = data['features'][0]['properties'];

          return properties['district'] ??
              properties['state_district'] ??
              properties['county'] ??
              properties['state'] ??
              properties['city'] ??
              properties['suburb'] ??
              properties['town'] ??
              properties['village'];
        }
      } else {
        throw Exception('Failed to fetch district: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching district from Geoapify API: $e');
    }
    return null;
  }
}
