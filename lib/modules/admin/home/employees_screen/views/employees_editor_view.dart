import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managementme/modules/admin/home/employees_screen/controllers/employees_editor_controller.dart';

class EmployeesEditorView extends StatelessWidget {
  const EmployeesEditorView({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final controller = Get.find<EmployeesEditorController>();

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
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "edit_employee".tr,
                        style: const TextStyle(fontSize: 28),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: cs.surfaceDim,
                          ),
                          child: Icon(Icons.close, color: cs.onSurface, size: 26),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8,),
                  Divider(
                    color: cs.surfaceDim,
                    thickness: 2,
                  ),
                ],
              ),

              TextField(
                controller: controller.nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  labelText: 'employee_name'.tr,
                ),
              ),
              TextField(
                controller: controller.emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  labelText: 'employee_email'.tr,
                ),
              ),
              TextField(
                controller: controller.phoneController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  labelText: 'employee_phone'.tr,
                ),
              ),
              TextField(
                controller: controller.branchController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  labelText: 'employee_branch'.tr,
                ),
              ),

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
  }
}
