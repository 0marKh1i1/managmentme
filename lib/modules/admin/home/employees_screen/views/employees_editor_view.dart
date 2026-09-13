import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managementme/core/models/user_model.dart';
import 'package:managementme/core/widgets/check_in_indicator.dart';
import 'package:managementme/core/widgets/custom_text_field.dart';
import 'package:managementme/modules/admin/home/employees_screen/controllers/employees_editor_controller.dart';

void showEmployeesEditorView(BuildContext context, {UserModel? user}) {
  final controller = Get.put(
    EmployeesEditorController(),
    tag: UniqueKey().toString(),
  );

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.55),
    builder: (_) => EmployeesEditorView(controller: controller),
  ).whenComplete(
    () => Get.delete<EmployeesEditorController>(
      tag: controller.hashCode.toString(),
      force: true,
    ),
  );
}

class EmployeesEditorView extends StatelessWidget {
  final EmployeesEditorController controller;
  const EmployeesEditorView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return GetBuilder<EmployeesEditorController>(
      init: controller,
      builder: (controller) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              padding: EdgeInsets.fromLTRB(
                16,
                16,
                16,
                MediaQuery.of(context).viewInsets.bottom +
                    MediaQuery.paddingOf(context).bottom +
                    24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 16,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "edit_employee".tr,
                            style: const TextStyle(fontSize: 24),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () => controller.toggleLock(),
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: cs.surfaceDim,
                              ),
                              child: Icon(
                                controller.isLoacked? Icons.lock : Icons.lock_open,
                                color: cs.onSurface,
                                size: 20,
                              ),
                            ),
                          ),
                          SizedBox(width: 15),
                          GestureDetector(
                            onTap: () => Get.back(),
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: cs.surfaceDim,
                              ),
                              child: Icon(
                                Icons.close,
                                color: cs.onSurface,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Divider(color: cs.surfaceDim, thickness: 2),
                    ],
                  ),

                  CustomTextField(
                    controller: controller.nameController,
                    labletText: 'employee_name'.tr,
                    hintText: 'enter_employee_name'.tr,
                    isEnabled: controller.isEnabled,
                  ),
                  CustomTextField(
                    controller: controller.emailController,
                    labletText: 'employee_email'.tr,
                    hintText: 'enter_employee_email'.tr,
                    isEnabled: controller.isEnabled,
                  ),
                  CustomTextField(
                    controller: controller.phoneController,
                    labletText: 'employee_phone'.tr,
                    hintText: 'enter_employee_phone'.tr,
                    isEnabled: controller.isEnabled,
                  ),
                  CustomTextField(
                    controller: controller.branchController,
                    labletText: 'employee_branch'.tr,
                    hintText: 'enter_employee_branch'.tr,
                    isEnabled: controller.isEnabled,
                  ),
                  CheckInIndicator(controller.employee),

                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => controller.saveChanges(),
                    child: Text("save".tr),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
