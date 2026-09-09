import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:managementme/core/constants/app_themes.dart';
import 'package:managementme/modules/home/home_screen/controllers/home_controller.dart';
import 'package:managementme/modules/settings/settings_screen/controllers/settings_controller.dart';

class Home extends GetView<HomeController> {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final double topSafeHeight = MediaQuery.paddingOf(context).top + 15;
    final double bottomSafeHeight = MediaQuery.paddingOf(context).bottom + 15;
    final profileController = Get.find<SettingsController>();
    final photoUrl = profileController.currentUser?.photoUrl ?? '';
    final isUploading = profileController.isUploadingImage;

    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppThemes.homeHeaderColor,
                    border: Border(
                      bottom: BorderSide(
                        color: AppThemes.homeHeaderTextColor.withAlpha(150),
                        width: 2,
                      ),
                    ),
                  ),
                  padding: EdgeInsets.only(top: topSafeHeight),
                  height: 225,
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Image.asset(
                          'assets/images/home/buildings.png',
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Row(
                              children: [
                                Text(
                                  'home_page'.tr,
                                  style: TextStyle(
                                    color: AppThemes.homeHeaderTextColor,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Spacer(),
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppThemes.homeHeaderTextColor,
                                      width: 2,
                                    ),
                                  ),
                                  child: ClipOval(
                                    child: isUploading
                                        ? Container(
                                            color: AppThemes.homeHeaderTextColor
                                                .withValues(alpha: 0.2),
                                            child: CircularProgressIndicator(
                                              color:
                                                  AppThemes.homeHeaderTextColor,
                                            ),
                                          )
                                        : photoUrl.isNotEmpty
                                        ? Image.network(
                                            photoUrl,
                                            fit: BoxFit.cover,
                                            errorBuilder: (ctx, e, st) =>
                                                Image.asset(
                                                  'assets/images/profile.png',
                                                  fit: BoxFit.contain,
                                                ),
                                          )
                                        : Image.asset(
                                            'assets/images/profile.png',
                                            fit: BoxFit.contain,
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
                            child: Row(
                              children: [
                                _headerItem(
                                  'branches'.tr,
                                  'assets/images/home/branches.svg',
                                  () {},
                                ),
                                Spacer(),
                                _headerItem(
                                  'employees'.tr,
                                  'assets/images/home/employees.svg',
                                      () {},
                                ),
                                Spacer(),
                                _headerItem(
                                  'attendance'.tr,
                                  'assets/images/home/attendance.svg',
                                      () {},
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  height: 750,
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  decoration: BoxDecoration(
                    color: cs.primary,
                    borderRadius: BorderRadius.circular(24),
                  ),
                    child: Column(
                      children: [
                        Text(
                            'employee_dashboard'.tr,
                            style: TextStyle(
                              color: cs.onPrimary,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                      ],
                    ),
                  ),
                SizedBox(height: bottomSafeHeight),
              ],
            ),
        ),
    );
  }
  Widget _headerItem(String label, String svgPath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          SvgPicture.asset(
            svgPath,
            width: 60,
            height: 60,
          ),
          Text(
            label,
            style: TextStyle(
              color: AppThemes.homeHeaderTextColor,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
