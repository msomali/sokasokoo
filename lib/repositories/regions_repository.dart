import 'dart:convert';

import 'package:sokasokoo/models/regions.dart';
import 'package:sokasokoo/services/geodata.dart';

class RegionRepository {
  RegionRepository._();

  static final RegionRepository _instance = RegionRepository._();

  factory RegionRepository() {
    return _instance;
  }

  Future<List<String>> fetchRegions() async {
    try {
      var data = await getRegions();
      var payload = json.decode(data);
      return Regions.fromJson(payload).features;
    } catch (e) {
      rethrow;
    }
  }
}
