import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:get/route_manager.dart';
import 'package:managementme/core/constants/app_themes.dart';
import 'package:managementme/modules/admin/home/home_screen/controllers/home_controller.dart';
import 'package:managementme/modules/admin/home/root/controllers/root_controller.dart';
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
      body: Column(
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
                          InkWell(
                            onTap: () {
                              Get.find<RootController>().changePage(1);
                            },
                            child: Container(
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
                                          color: AppThemes.homeHeaderTextColor,
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
                           () {Get.toNamed('/admin/branches');},
                          ),
                          Spacer(),
                          _headerItem(
                            'employees'.tr,
                            'assets/images/home/employees.svg',
                            () {Get.toNamed('/admin/employees');},
                          ),
                          Spacer(),
                          _headerItem(
                            'attendance'.tr,
                            'assets/images/home/attendance.svg',
                            () {Get.toNamed('/admin/attendance');},
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Text(
                    'employee_dashboard'.tr,
                    style: TextStyle(
                      color: cs.onPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: GetBuilder<HomeController>(
                          builder: (controller) {
                            if (controller.isLoading) {
                              return SizedBox(
                                height: 750,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                            return Column(
                              spacing: 16,
                              children: [
                                _buildStatItem(
                                  context,
                                  'total_employees'.tr,
                                  controller.employees.length,
                                ),
                                _buildStatItem(
                                  context,
                                  'present_employees'.tr,
                                  controller.presentEmployees,
                                ),
                                _buildStatItem(
                                  context,
                                  'absent_employees'.tr,
                                  controller.absentEmployees,
                                ),
                                _buildStatItem(
                                  context,
                                  'late_employees'.tr,
                                  controller.lateEmployeesCount,
                                ),
                                _buildStatItem(
                                  context,
                                  'checked_out_employees'.tr,
                                  controller.getCheckedOutEmployees(),
                                ),
                                _buildStatItem(
                                  context,
                                  'employees_outside_work_area'.tr,
                                  controller.getOutsideWorkAreaEmployees(),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      SizedBox(height: bottomSafeHeight),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerItem(String label, String svgPath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          SvgPicture.asset(svgPath, width: 60, height: 60),
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

  Widget _buildStatItem(BuildContext ctxt, String label, int value) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(ctxt).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      width: double.infinity,
      height: 95,
      child: Stack(
        children: [
          Positioned(
            top: 8,
            left: 16,
            child: InkWell(
              onTap: (){

              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: Theme.of(ctxt).colorScheme.onSurface,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(
                    height: 32,
                    child:  Icon(Icons.chevron_right, size: 32,color: Theme.of(ctxt).colorScheme.primary,),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 28,
            bottom: 8,
            child: Text(
              '$value',
              style: TextStyle(
                color: Theme.of(ctxt).colorScheme.onSurface,
                fontSize: 40,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
