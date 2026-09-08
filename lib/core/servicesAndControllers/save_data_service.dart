import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SaveDataService extends GetxService {
  late SharedPreferences sharedPreferences;
  Future<SaveDataService> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
    return this;
  }

  Future<void> savePrefrence<T>(String k, T val) async {
    if (val is String) {
      sharedPreferences.setString(k, val);
    } else if (val is int) {
      sharedPreferences.setInt(k, val);
    } else if (val is double) {
      sharedPreferences.setDouble(k, val);
    } else if (val is bool) {
      sharedPreferences.setBool(k, val);
    } else {
      Exception(
        "save data service error: can only save (string, int, double, bool) and nothing else",
      );
    }
  }

  T? getPrefrence<T>(String k) {
    if (T == String) {
      return sharedPreferences.getString(k) as T?;
    } else if (T == int) {
      return sharedPreferences.getInt(k) as T?;
    } else if (T == double) {
      return sharedPreferences.getDouble(k) as T?;
    } else if (T == bool) {
      return sharedPreferences.getBool(k) as T?;
    } else {
      Exception(
        "save data service error: can only save (string, int, double, bool) and nothing else",
      );
      return null;
    }
  }
}
