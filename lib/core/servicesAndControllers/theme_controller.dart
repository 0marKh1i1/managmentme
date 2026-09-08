import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managementme/core/servicesAndControllers/save_data_service.dart';

class ThemeController extends GetxController {
  ThemeMode _themeMode = ThemeMode.system;
  int _themeModeInt = 0;

  ThemeMode get themeMode => _themeMode;

  int get themeModeInt => (_themeModeInt);

  SaveDataService savedata = Get.find<SaveDataService>();

  @override
  ThemeController onInit() {
    super.onInit();
    int savedTheme = savedata.getPrefrence<int>("themeMode") ?? 0;

    if (savedTheme >= 0 && savedTheme < ThemeMode.values.length) {
      _themeMode = ThemeMode.values[savedTheme];
      _themeModeInt = _themeMode.index;
    } else {
      _themeMode = ThemeMode.system;
    }
    _themeModeInt = _themeMode.index;

    Get.changeThemeMode(_themeMode);
    update();
    return this;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    _themeModeInt = mode.index;

    await savedata.savePrefrence<int>("themeMode", mode.index);
    Get.changeThemeMode(_themeMode);
    update();
  }

  Future<void> setThemeModeInt(int modeInt) async {
    if (modeInt >= 0 && modeInt < ThemeMode.values.length) {
      _themeMode = ThemeMode.values[modeInt];
    } else {
      _themeMode = ThemeMode.system;
    }

    _themeModeInt = modeInt;
    await savedata.savePrefrence<int>("themeMode", modeInt);
    Get.changeThemeMode(_themeMode);
    update();
  }
}
