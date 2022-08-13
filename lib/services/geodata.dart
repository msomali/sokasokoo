import 'package:flutter/services.dart' show rootBundle;

Future<String> getRegions() {
  return rootBundle.loadString('assets/geo/regions.json');
}

Future<String> getDistricts() {
  return rootBundle.loadString('assets/geo/districts.json');
}

Future<String> getWards() {
  return rootBundle.loadString('assets/geo/wards.json');
}
