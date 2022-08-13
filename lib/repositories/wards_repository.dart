import 'dart:convert';

import 'package:sokasokoo/models/wards.dart';
import 'package:sokasokoo/services/geodata.dart';

class WardsRepository {
  WardsRepository._();

  static final WardsRepository _instance = WardsRepository._();

  factory WardsRepository() {
    return _instance;
  }

  Future<List<Features>> fetchWards() async {
    try {
      var data = await getWards();
      var payload = json.decode(data);
      return Wards.fromJson(payload).features;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<String>> fetchWardsString() async {
    try {
      var data = await getWards();
      var payload = json.decode(data);
      var wards = Wards.fromJson(payload).features;

      var values = wards.map((e) => e.ward.toString()).toList();
      return values;
    } catch (e) {
      rethrow;
    }
  }
}
