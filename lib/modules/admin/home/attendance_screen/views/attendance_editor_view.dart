import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managementme/core/models/attendance_model.dart';
import 'package:managementme/core/models/branch_model.dart';
import 'package:managementme/core/models/user_model.dart';
import 'package:managementme/core/widgets/custom_text_field.dart';
import 'package:managementme/modules/admin/home/attendance_screen/controllers/attendance_controller.dart';
import 'package:managementme/modules/admin/home/attendance_screen/controllers/attendance_editor_controller.dart';
import 'package:intl/intl.dart';

void showAttendanceEditorView(
  BuildContext context, {
  AttendanceModel? attendance,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.55),
    builder: (_) => AttendanceEditorView(attendance: attendance),
  );
}

class AttendanceEditorView extends StatelessWidget {
  final AttendanceModel? attendance;
  const AttendanceEditorView({super.key, this.attendance});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final attCtrl = Get.find<AttendanceController>();

    return GetBuilder<AttendanceEditorController>(
      init: AttendanceEditorController()..initWith(attendance),
      builder: (controller) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.3,
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
                                  controller.isNew
                                      ? "add_attendance".tr
                                      : "edit_attendance".tr,
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
                                      controller.isLocked
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
                          child: Form(
                            key: controller.formKey,
                            child: Column(
                              spacing: 16,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: cs.surfaceDim,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 4,
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<UserModel>(
                                      isExpanded: true,
                                      hint: Text('select_user'.tr),
                                      value: controller.selectedUser,
                                      items: attCtrl.usersMap.values.map((
                                        UserModel user,
                                      ) {
                                        return DropdownMenuItem<UserModel>(
                                          value: user,
                                          child: Text(user.name),
                                        );
                                      }).toList(),
                                      onChanged:
                                          (controller.isEnabled &&
                                              controller.isNew)
                                          ? (UserModel? newValue) {
                                              if (newValue != null) {
                                                controller.selectUser(newValue);
                                              }
                                            }
                                          : null,
                                    ),
                                  ),
                                ),

                                Container(
                                  decoration: BoxDecoration(
                                    color: cs.surfaceDim,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 4,
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<BranchModel>(
                                      isExpanded: true,
                                      hint: Text('select_branch'.tr),
                                      value: controller.selectedBranch,
                                      items: attCtrl.branchesMap.values.map((
                                        BranchModel branch,
                                      ) {
                                        return DropdownMenuItem<BranchModel>(
                                          value: branch,
                                          child: Text(branch.name),
                                        );
                                      }).toList(),
                                      onChanged: controller.isEnabled
                                          ? (BranchModel? newValue) {
                                              if (newValue != null) {
                                                controller.selectBranch(
                                                  newValue,
                                                );
                                              }
                                            }
                                          : null,
                                    ),
                                  ),
                                ),

                                InkWell(
                                  onTap:
                                      (controller.isEnabled && controller.isNew)
                                      ? () => controller.pickDate(context)
                                      : null,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: cs.surfaceDim,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.all(16),
                                    child: Opacity(
                                      opacity: controller.isEnabled ? 1 : 0.5,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'date'.tr,
                                            style: const TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            DateFormat(
                                              'yyyy/MM/dd',
                                            ).format(controller.selectedDate),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                InkWell(
                                  onTap: controller.isEnabled
                                      ? () =>
                                            controller.pickCheckInTime(context)
                                      : null,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: cs.surfaceDim,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.all(16),
                                    child: Opacity(
                                      opacity: controller.isEnabled ? 1 : 0.5,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'check_in_time'.tr,
                                            style: const TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            controller.checkInTime?.format(
                                                  context,
                                                ) ??
                                                '--:--',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                InkWell(
                                  onTap: controller.isEnabled
                                      ? () =>
                                            controller.pickCheckOutTime(context)
                                      : null,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: cs.surfaceDim,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.all(16),
                                    child: Opacity(
                                      opacity: controller.isEnabled ? 1 : 0.5,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'check_out_time'.tr,
                                            style: const TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            controller.checkOutTime?.format(
                                                  context,
                                                ) ??
                                                '--:--',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                Container(
                                  decoration: BoxDecoration(
                                    color: cs.surfaceDim,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 4,
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<AttendanceStatus>(
                                      isExpanded: true,
                                      hint: Text('status'.tr),
                                      value: controller.selectedStatus,
                                      items: AttendanceStatus.values.map((
                                        AttendanceStatus status,
                                      ) {
                                        return DropdownMenuItem<
                                          AttendanceStatus
                                        >(
                                          value: status,
                                          child: Text(status.name.tr),
                                        );
                                      }).toList(),
                                      onChanged: controller.isEnabled
                                          ? (AttendanceStatus? newValue) {
                                              if (newValue != null) {
                                                controller.selectStatus(
                                                  newValue,
                                                );
                                              }
                                            }
                                          : null,
                                    ),
                                  ),
                                ),

                                Container(
                                  decoration: BoxDecoration(
                                    color: cs.surfaceDim,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 8,
                                  ),
                                  child: CustomTextField(
                                    controller: controller.notesController,
                                    labletText: 'notes'.tr,
                                    hintText: 'enter_notes'.tr,
                                    isEnabled: controller.isEnabled,
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
