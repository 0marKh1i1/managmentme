import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managementme/core/models/branch_model.dart';
import 'package:managementme/core/widgets/custom_text_field.dart';
import 'package:managementme/core/widgets/toast.dart';
import 'package:managementme/modules/admin/home/branches_screen/controllers/branches_editor_controller.dart';

void showBranchesEditorView(BuildContext context, {BranchModel? branch}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.55),
    builder: (_) => BranchesEditorView(branch: branch),
  );
}

class BranchesEditorView extends StatelessWidget {
  final BranchModel? branch;
  const BranchesEditorView({super.key, this.branch});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return GetBuilder<BranchesEditorController>(
      init: BranchesEditorController()..initWith(branch),
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
                                  "edit_branch".tr,
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
                          child: Form(
                            key: controller.formKey,
                            child: Column(
                              spacing: 16,
                              children: [
                                CustomTextField(
                                  controller: controller.nameController,
                                  labletText: 'branch_name'.tr,
                                  hintText: 'enter_branch_name'.tr,
                                  isEnabled: (controller.isEnabled),
                                  validator: (value) {
                                    if ((controller.isNew && controller.isEnabled) && (value == null || value.trim().isEmpty)) {
                                      return 'required_field'.tr;
                                    }
                                    return null;
                                  },
                                ),
                                CustomTextField(
                                  controller: controller.lastCheckInController,
                                  labletText: 'branch_last_check_in_time'.tr,
                                  hintText: 'enter_last_check_in_time'.tr,
                                  isEnabled: (controller.isEnabled),
                                  validator: (value) {
                                    if ((controller.isNew && controller.isEnabled) && (value == null || value.trim().isEmpty)) {
                                      return 'required_field'.tr;
                                    }
                                    return null;
                                  },
                                ),
                                CustomTextField(
                                  controller: controller.fenceRadiusController,
                                  labletText: 'branch_fence_radius'.tr,
                                  hintText: 'enter_branch_fence_radius'.tr,
                                  isEnabled: (controller.isEnabled),
                                  validator: (value) {
                                    if ((controller.isNew && controller.isEnabled) && (value == null || value.trim().isEmpty)) {
                                      return 'required_field'.tr;
                                    }
                                    return null;
                                  },
                                ),
                               MaterialButton(
                                child: Text("dasdsaj"),
                                onPressed: (){
                                toast("title","");
                               })
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
