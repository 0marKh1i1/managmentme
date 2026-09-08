import 'package:managementme/core/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:managementme/modules/auth/signup_screen/controllers/signup_controller.dart';

class RoleToggleSwitch extends StatelessWidget {
  final SignupController controller;

  const RoleToggleSwitch({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;

    return Container(
      height: 50,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Obx(
        () => Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => controller.setRole(UserType.customer),
                child: Container(
                  decoration: BoxDecoration(
                    color: controller.selectedRole.value == UserType.customer
                        ? cs.primary
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow:
                        controller.selectedRole.value == UserType.customer
                        ? [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : [],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'customer_role'.tr,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: controller.selectedRole.value == UserType.customer
                          ? cs.onPrimary
                          : cs.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => controller.setRole(UserType.driver),
                child: Container(
                  decoration: BoxDecoration(
                    color: controller.selectedRole.value == UserType.driver
                        ? cs.primary
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: controller.selectedRole.value == UserType.driver
                        ? [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : [],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'driver_role'.tr,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: controller.selectedRole.value == UserType.driver
                          ? cs.onPrimary
                          : cs.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
