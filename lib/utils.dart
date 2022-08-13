import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  static final levels = ['U20', 'U17', 'U15', 'U13', 'U11', 'U9'];
  static String getFormattedDate(String date) {
    var localDate = DateTime.parse(date).toLocal();

    /// inputFormat - format getting from api or other func.
    /// e.g If 2021-05-27 9:34:12.781341 then format must be yyyy-MM-dd HH:mm
    /// If 27/05/2021 9:34:12.781341 then format must be dd/MM/yyyy HH:mm
    var inputFormat = DateFormat('yyyy-MM-dd HH:mm');
    var inputDate = inputFormat.parse(localDate.toString());

    /// outputFormat - convert into format you want to show.
    var outputFormat = DateFormat('dd/MM/yyyy');
    var outputDate = outputFormat.format(inputDate);

    return outputDate.toString();
  }

  static int getAge(String birthdate) {
    var birthDate = DateTime.tryParse(birthdate);
    final now = DateTime.now();

    int differenceInAge = now.year - birthDate!.year;

    return differenceInAge;
  }

  static String? getLevel(age) {
    if (age <= 9) {
      return levels[5];
    } else if (age > 9 && age <= 11) {
      return levels[4];
    } else if (age > 11 && age <= 13) {
      return levels[3];
    } else if (age > 13 && age <= 15) {
      return levels[2];
    } else if (age > 15 && age <= 17) {
      return levels[1];
    } else if (age > 17 && age <= 19) {
      return levels[0];
    } else {
      return 'U30';
    }
  }
}

class SharedPrefs {
  SharedPreferences? preferences;

  Future<void> initializePreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  static setUser(String email) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('email', email);
  }

  static getUser() async {
    var prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    return email;
  }

  static removeUser() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.remove('email');
  }
}
