import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managementme/core/constants/app_themes.dart';
import 'package:managementme/core/constants/globals.dart';
import 'package:managementme/core/constants/routes.dart';
import 'package:managementme/core/servicesAndControllers/theme_controller.dart';
import 'package:managementme/core/servicesAndControllers/save_data_service.dart';
import 'package:managementme/modules/auth/services/auth_service.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:managementme/core/servicesAndControllers/localization_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();

  await Get.putAsync(() => SaveDataService().init());
  await Get.putAsync(() => AuthService().init());
  
  Get.put(LocalizationService());
  Get.put(ThemeController());

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = Get.find<AuthService>().getUser() != null;

    return GetBuilder<ThemeController>(
      builder: (tController) {
        return GetMaterialApp(
          title: 'managementme',
          debugShowCheckedModeBanner: false,
          theme: AppThemes.lightTheme,
          darkTheme: AppThemes.darkTheme,
          themeMode: tController.themeMode,
          scaffoldMessengerKey: scaffoldMessengerKey,
          translations: LocalizationService.translations,
          locale: LocalizationService.locale,
          fallbackLocale: LocalizationService.fallbackLocale,
          localizationsDelegates: LocalizationService.localizationsDelegates,
          supportedLocales: LocalizationService.supportedLocales,
          initialRoute:  isLoggedIn ? "/root" : "/",
          getPages: appRoutes,
        );
      },
    );
  }
}
  