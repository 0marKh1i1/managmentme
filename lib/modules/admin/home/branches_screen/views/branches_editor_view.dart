import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:managementme/core/models/branch_model.dart';
import 'package:managementme/core/widgets/custom_text_field.dart';
import 'package:managementme/modules/admin/home/branches_screen/controllers/branches_editor_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
                                Container(
                                  decoration: BoxDecoration(
                                    color: cs.surfaceDim,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 8,
                                  ),
                                  child: CustomTextField(
                                    controller: controller.nameController,
                                    labletText: 'branch_name'.tr,
                                    hintText: 'enter_branch_name'.tr,
                                    isEnabled: (controller.isEnabled),
                                    validator: (value) {
                                      if ((controller.isNew &&
                                              controller.isEnabled) &&
                                          (value == null ||
                                              value.trim().isEmpty)) {
                                        return 'required_field'.tr;
                                      }
                                      return null;
                                    },
                                  ),
                                ),

                                InkWell(
                                  onTap: controller.isEnabled
                                      ? () {
                                          controller.pickTime(context);
                                        }
                                      : null,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: cs.surfaceDim,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(
                                      vertical: 16,
                                      horizontal: 16,
                                    ),
                                    child: Opacity(
                                      opacity: controller.isEnabled ? 1 : 0.5,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'last_check_in_time'.tr,
                                                style: TextStyle(fontSize: 22),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            spacing: 8,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                style: TextStyle(fontSize: 32),
                                                controller.selectedTime.format(context),
                                              ),
                                              Icon(Icons.access_time, size: 32),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                InkWell(
                                  onTap: controller.isEnabled
                                      ? () => controller.pickWorkingHours(
                                          context,
                                        )
                                      : null,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: cs.surfaceDim,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                      horizontal: 16,
                                    ),
                                    child: Opacity(
                                      opacity: controller.isEnabled ? 1 : 0.5,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'working_hours'.tr,
                                            style: const TextStyle(
                                              fontSize: 22,
                                            ),
                                          ),
                                          Text(
                                            '${'first_check_out_time'.tr}: ${controller.firstCheckOutText}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: cs.onSurfaceVariant,
                                            ),
                                          ),
                                          Row(
                                            spacing: 8,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                controller.workingHoursText,
                                                style: const TextStyle(
                                                  fontSize: 32,
                                                ),
                                              ),
                                              const Icon(
                                                Icons.hourglass_bottom,
                                                size: 32,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: SizedBox(
                                    height: 200,
                                    width: double.infinity,
                                    child: Stack(
                                      children: [
                                        GoogleMap(
                                          onMapCreated: (c) =>
                                              controller.mapController = c,
                                          initialCameraPosition:
                                              controller.initialPosition,
                                          onCameraMove: controller.onCameraMove,
                                          markers: controller.markers,
                                          circles: controller.circles,
                                          gestureRecognizers: {
                                            Factory<
                                              OneSequenceGestureRecognizer
                                            >(() => EagerGestureRecognizer()),
                                          },
                                        ),
                                        if (controller.isPickingLocation)
                                          const IgnorePointer(
                                            child: Center(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                  bottom: 40,
                                                ),
                                                child: Icon(
                                                  Icons.location_pin,
                                                  size: 40,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                            ),
                                          ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(4),
                                              child: IconButton(
                                                onPressed: () => controller
                                                    .animateToLocation(),
                                                icon: Icon(
                                                  Icons.gps_fixed,
                                                  size: 32,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (!controller.isPickingLocation)
                                  SizedBox(
                                    width: double.infinity,
                                    child: OutlinedButton.icon(
                                      onPressed: controller.isEnabled
                                          ? controller.startPickingLocation
                                          : null,
                                      icon: const Icon(Icons.edit_location_alt),
                                      label: Text('change_location'.tr),
                                    ),
                                  )
                                else
                                  Row(
                                    spacing: 12,
                                    children: [
                                      Expanded(
                                        child: OutlinedButton(
                                          onPressed:
                                              controller.cancelPickingLocation,
                                          child: Text('cancel'.tr),
                                        ),
                                      ),
                                      Expanded(
                                        child: FilledButton(
                                          onPressed: controller.confirmLocation,
                                          child: Text('confirm_location'.tr),
                                        ),
                                      ),
                                    ],
                                  ),

                                Container(
                                  decoration: BoxDecoration(
                                    color: cs.surfaceDim,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 8,
                                  ),
                                  child: CustomTextField(
                                    controller:
                                        controller.fenceRadiusController,
                                    labletText: 'branch_fence_radius'.tr,
                                    hintText: 'enter_branch_fence_radius'.tr,
                                    type: TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                    formatter: <TextInputFormatter>[
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d*\.?\d*'),
                                      ),
                                    ],
                                    isEnabled: (controller.isEnabled),
                                    validator: (value) {
                                      if ((controller.isNew &&
                                              controller.isEnabled) &&
                                          (value == null ||
                                              value.trim().isEmpty)) {
                                        return 'required_field'.tr;
                                      }
                                      return null;
                                    },
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