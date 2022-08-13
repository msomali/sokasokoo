import 'package:flutter/material.dart';
import 'package:sokasokoo/models/user.dart';
import 'package:sokasokoo/repositories/api.dart';
import 'package:sokasokoo/repositories/districts_repository.dart';
import 'package:sokasokoo/repositories/regions_repository.dart';
import 'package:sokasokoo/repositories/wards_repository.dart';

class UserProvider extends ChangeNotifier {
  late User currentUser;
  String? currentId;
  List<User> listOfUsers = [];
  List<String> regions = [];
  List<String> districts = [];
  List<String> wards = [];

  List<User> users = [];
  var isLoading = false;

  String fileType = 'Link';

  void setUser(User user) {
    currentUser = user;
    currentId = user.sId;
    notifyListeners();
  }

  void setCurrentId(String id) {
    currentId = id;
    notifyListeners();
  }

  void changeProfileImage(String image) {
    currentUser.profileImage = image;
    notifyListeners();
  }

  void setUserFileType(type) {
    fileType = type;
    notifyListeners();
  }

  void setUsers(payload) {
    users.clear();
    users.addAll(payload);
    notifyListeners();
  }

  void setLoading(payload) {
    isLoading = payload;
    notifyListeners();
  }

  void fetchUser() async {
    setLoading(true);
    try {
      List<User> data = await Api().fetchUsers();
      users.clear();
      users.addAll(data);
      users.shuffle();
      notifyListeners();
    } catch (e) {
      users.addAll([]);
      notifyListeners();
    } finally {
      setLoading(false);
    }
  }

  void fetchRegions() async {
    try {
      var data = await RegionRepository().fetchRegions();
      regions = data;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  void fetchDistricts() async {
    try {
      var data = await DistrictsRepository().fetchDistrictsString();
      districts = data;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  void fetchWards() async {
    try {
      var data = await WardsRepository().fetchWardsString();
      wards = data;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  void onSearch(String text) async {
    if (text.isEmpty) {
      return;
    }

    try {
      setLoading(true);
      List<User> data = await Api().searchUsers(text);
      users.clear();
      users.addAll(data);
      notifyListeners();
    } catch (e) {
      users.addAll([]);
      notifyListeners();
    } finally {
      setLoading(false);
    }
  }
}
