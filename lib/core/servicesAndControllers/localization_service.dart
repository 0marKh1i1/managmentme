import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:managementme/core/constants/app_translations.dart';
import 'package:managementme/core/servicesAndControllers/save_data_service.dart';

class LocalizationService extends GetxService {
  static final AppTranslations translations = AppTranslations();

  static const fallbackLocale = Locale('en', 'US');

  static const localizationsDelegates = [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static const supportedLocales = [Locale('en', 'US'), Locale('ar', 'SA')];

  static Locale get locale {
    final lang = Get.find<SaveDataService>().getPrefrence<String>('lang');
    if (lang == 'ar') return const Locale('ar', 'SA');
    if (lang == 'en') return const Locale('en', 'US');
    return Get.deviceLocale ?? fallbackLocale;
  }

  void toggleLanguage(String langCode) {
    if (langCode == 'ar') {
      Get.updateLocale(const Locale('ar', 'SA'));
    } else {
      Get.updateLocale(const Locale('en', 'US'));
    }
    Get.find<SaveDataService>().savePrefrence('lang', langCode);
  }
}
