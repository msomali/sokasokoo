import 'dart:convert';

import 'package:sokasokoo/models/districts.dart';
import 'package:sokasokoo/models/regions.dart';
import 'package:sokasokoo/services/geodata.dart';

class DistrictsRepository {
  DistrictsRepository._();

  static final DistrictsRepository _instance = DistrictsRepository._();

  factory DistrictsRepository() {
    return _instance;
  }

  Future<List<Features>> fetchDistricts() async {
    try {
      var data = await getDistricts();
      var payload = json.decode(data);

      return Districts.fromJson(payload).features;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<String>> fetchDistrictsString() async {
    try {
      var data = await getDistricts();
      var payload = json.decode(data);
      var values = Districts.fromJson(payload).features;

      var computedValues = values.map((e) => e.district.toString()).toList();
      return computedValues;
    } catch (e) {
      rethrow;
    }
  }
}
