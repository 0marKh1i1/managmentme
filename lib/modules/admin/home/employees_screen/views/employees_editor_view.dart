import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managementme/core/models/branch_model.dart';
import 'package:managementme/core/models/user_model.dart';
import 'package:managementme/core/widgets/check_in_indicator.dart';
import 'package:managementme/core/widgets/custom_text_field.dart';
import 'package:managementme/core/widgets/role_toggle_switch.dart';
import 'package:managementme/modules/admin/home/employees_screen/controllers/employees_controller.dart';
import 'package:managementme/modules/admin/home/employees_screen/controllers/employees_editor_controller.dart';

void showEmployeesEditorView(BuildContext context, {UserModel? user}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.55),
    builder: (_) => EmployeesEditorView(user: user),
  );
}

class EmployeesEditorView extends StatelessWidget {
  final UserModel? user;
  const EmployeesEditorView({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return GetBuilder<EmployeesEditorController>(
      init: EmployeesEditorController()..initWith(user),
      builder: (controller) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.25,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    SingleChildScrollView(
                      controller: scrollController,
                      physics: const ClampingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                        child: Column(
                          children: [
                            Container(
                              width: 40,
                              height: 4,
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: cs.onSurfaceVariant.withValues(
                                  alpha: 0.4,
                                ),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
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
                                      controller.isLoacked
                                          ? Icons.lock
                                          : Icons.lock_open,
                                      color: cs.onSurface,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
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
                            const SizedBox(height: 8),
                            Divider(color: cs.surfaceDim, thickness: 2),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                            16,
                            16,
                            16,
                            MediaQuery.of(context).viewInsets.bottom +
                                MediaQuery.paddingOf(context).bottom +
                                24,
                          ),
                          child: Column(
                            spacing: 16,
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundImage:
                                    (controller.employee != null &&
                                        controller.employee!.photoUrl != null &&
                                        controller
                                            .employee!
                                            .photoUrl!
                                            .isNotEmpty)
                                    ? NetworkImage(
                                        controller.employee!.photoUrl!,
                                      )
                                    : const AssetImage(
                                        'assets/images/profile.png',
                                      ),
                              ),
                              CustomTextField(
                                controller: controller.emailController,
                                labletText: 'employee_email'.tr,
                                hintText: 'enter_employee_email'.tr,
                                isEnabled: false,
                              ),
                              CustomTextField(
                                controller: controller.nameController,
                                labletText: 'employee_name'.tr,
                                hintText: 'enter_employee_name'.tr,
                                isEnabled: controller.isEnabled,
                              ),
                              CustomTextField(
                                controller: controller.phoneController,
                                labletText: 'employee_phone'.tr,
                                hintText: 'enter_employee_phone'.tr,
                                isEnabled: controller.isEnabled,
                              ),
                              DropdownMenu<BranchModel>(
                                initialSelection: controller.branch,
                                enabled: controller.isEnabled,
                                label: Text('enter_employee_branch'.tr),
                                inputDecorationTheme: InputDecorationTheme(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      16.0,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                    borderSide: const BorderSide(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                    borderSide: const BorderSide(
                                      color: Colors.blue,
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                                onSelected: (BranchModel? value) {
                                  controller.setBranch(value);
                                },
                                dropdownMenuEntries:
                                    Get.find<EmployeesController>().branchesList
                                        .map<DropdownMenuEntry<BranchModel>>((
                                          BranchModel value,
                                        ) {
                                          return DropdownMenuEntry<BranchModel>(
                                            value: value,
                                            label: value.name,
                                          );
                                        })
                                        .toList(),
                              ),
                              IgnorePointer(
                                ignoring: controller.isLoacked,
                                child: RoleToggleSwitch(
                                  selectedRole: controller.selectedRole,
                                  setRole: controller.setRole,
                                ),
                              ),
                              IgnorePointer(
                                ignoring: controller.isLoacked,
                                child: InkWell(
                                  onTap: (() => controller.toggleIsCheckIn()),
                                  child: CheckInIndicator(
                                    controller.isCheckIn,
                                    size: 24,
                                  ),
                                ),
                              ),
                              Divider(color: cs.surfaceDim, thickness: 2),

                              MaterialButton(
                                splashColor: Colors.transparent,
                                onPressed: (controller.isEnabled
                                    ? () => controller.saveChanges()
                                    : null),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: cs.primary,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 40,
                                    vertical: 6,
                                  ),
                                  child: controller.isSaving
                                      ? CircularProgressIndicator(
                                          color: cs.onPrimary,
                                        )
                                      : Text(
                                          "save".tr,
                                          style: TextStyle(fontSize: 24),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
