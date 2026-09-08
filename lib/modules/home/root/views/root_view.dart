import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:managementme/modules/home/home_screen/views/home_view.dart';
import 'package:managementme/modules/home/root/controllers/root_controller.dart';
import 'package:managementme/modules/settings/settings_screen/views/settings_view.dart';

class RootView extends GetView<RootController> {
  const RootView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const Home(),
      const SettingsView(),
    ];

    return Scaffold(
      extendBody: true, 
      body: PageView(
        controller: controller.pageController,
        onPageChanged: controller.onPageChanged,
        physics: controller.scrollPhysics.value,
        children: pages,
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }
Widget _buildBottomNav(BuildContext context) {
    final istDark = Theme.of(context).brightness != Brightness.dark;
    
    const glassColor = Color(0xFF90A4AE);
        
    final activeTextColor = istDark ? Colors.black : Colors.white;
    final activeIconColor = activeTextColor;
    final inactiveColor =  activeIconColor;

    return Container(
      margin: const EdgeInsets.only(left: 50, right: 50, bottom: 20),
      height: 75,
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
            decoration: BoxDecoration(
              color: glassColor.withValues(alpha: 0.25), 
              borderRadius: BorderRadius.circular(32), 
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1.2,
              ),
            ),
            child: SafeArea(
              bottom: false, 
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 12.0,
                  bottom: 12.0,
                  left: 16.0,
                  right: 16.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(
                      0,
                      'home'.tr,
                      Icons.home_outlined,
                      Icons.home,
                      activeTextColor,
                      activeIconColor,
                      inactiveColor,
                    ),
                    _buildNavItem(
                      1,
                      'profile'.tr,
                      Icons.person_outline,
                      Icons.person,
                      activeTextColor,
                      activeIconColor,
                      inactiveColor,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildNavItem(
    int index,
    String label,
    dynamic iconOutlined,
    dynamic iconFilled,
    Color activeTextColor,
    Color activeIconColor,
    Color inactiveColor,
  ) {
    return Obx(() {
      final isSelected = controller.selectedIndex.value == index;
      final color = isSelected ? activeTextColor : inactiveColor;
      final iconColor = isSelected ? activeIconColor : inactiveColor;
      final iconData = isSelected ? iconFilled : iconOutlined;

      return GestureDetector(
        onTap: () => controller.changePage(index),
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: 58,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (iconData is IconData) ...{
                Icon(iconData, color: iconColor, size: 24),
              } else if (iconData is String) ...{
                SvgPicture.asset(
                  iconData,
                  semanticsLabel: label,
                  colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                ),
              },
              const SizedBox(height: 4),
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
            ],
          ),
        ),
      );
    });
  }
}