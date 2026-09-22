import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:managementme/core/constants/app_themes.dart';
import 'package:managementme/core/models/user_model.dart';
import 'package:managementme/modules/admin/home/home_screen/views/home_view.dart'as admin_home;
import 'package:managementme/modules/employee/home/home_screen/views/home_view.dart'as employee_home;
import 'package:managementme/modules/auth/services/auth_service.dart';
import 'package:managementme/modules/root/controllers/root_controller.dart';
import 'package:managementme/modules/settings/settings_screen/views/settings_view.dart';

class RootView extends GetView<RootController> {
  const RootView({super.key});

  @override
  Widget build(BuildContext context) {
    UserType role =
        Get.find<AuthService>().currentUser.value?.role ?? UserType.employee;
    final List<Widget> pages = role == UserType.admin
        ? [const admin_home.Home(), const SettingsView()]
        : [const employee_home.Home(), const SettingsView()];
    final List<Widget> items = role == UserType.admin ? [
        _buildNavItem( index: 0, context: context, iconOutlined: Icons.home_outlined, iconFilled: Icons.home, ),
        _buildNavItem( index: 1, context: context, iconOutlined: Icons.person_outline, iconFilled: Icons.person, ),
    ] : [
        _buildNavItem( index: 0, context: context, iconOutlined: Icons.home_outlined, iconFilled: Icons.home, ),
        _buildNavItem( index: 1, context: context, iconOutlined: Icons.person_outline, iconFilled: Icons.person, ),
    ];
    return Scaffold(
      extendBody: true,
      body: PageView(
        controller: controller.pageController,
        onPageChanged: controller.onPageChanged,
        physics: controller.scrollPhysics.value,
        children: pages,
      ),
      bottomNavigationBar: _buildBottomNav(context, pages.length, items),
    );
  }

  Widget _buildBottomNav(BuildContext context, int len, List<Widget> items) {
    double horizontalMargin = max(90 - (len * 10), 10);
    return Container(
      margin: EdgeInsets.only(
        left: horizontalMargin,
        right: horizontalMargin,
        bottom: 20,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18.0, sigmaY: 18.0),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
              color: AppThemes.glassColor.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: AppThemes.glassBorderColor.withValues(alpha: 0.2),
                width: 1.2,
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 8,
                  bottom: 8,
                  left: 12,
                  right: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: items,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
    Widget _buildNavItem({
    required int index,
    required BuildContext context,
    required dynamic iconOutlined,
    required dynamic iconFilled,
    String? label,
  }) {
    return Obx(() {
      final isSelected = controller.selectedIndex.value == index;
      final color = Theme.of(context).colorScheme.onSurface;
      final iconData = isSelected ? iconFilled : iconOutlined;
      final bool justIcon = (label == null || label.isEmpty);
      
      return Expanded(  
        child: GestureDetector(
          onTap: () => controller.changePage(index),
          behavior: HitTestBehavior.opaque, 
          child: Column(
            mainAxisSize: MainAxisSize.min, 
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 32, 
                alignment: Alignment.center,
                child: iconData is IconData
                    ? Icon(iconData, color: color, size: justIcon ? 32 : 24)
                    : SvgPicture.asset(
                        iconData.toString(),
                        semanticsLabel: label,
                        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                      ),
              ),
              if (!justIcon) ...{
                Text(
                  label,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: color,
                    letterSpacing: 0.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              },
            ],
          ),
        ),
      );
    });
  }


}
