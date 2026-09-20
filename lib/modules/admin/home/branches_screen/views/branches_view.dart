import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:managementme/core/constants/app_themes.dart';
import 'package:managementme/core/models/branch_model.dart';
import 'package:managementme/modules/admin/home/branches_screen/controllers/branches_controller.dart';
import 'package:managementme/modules/admin/home/branches_screen/views/branches_editor_view.dart';

class BranchesView extends StatelessWidget {
  const BranchesView({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final double topSafeHeight = MediaQuery.paddingOf(context).top + 15;
    final double bottomSafeHeight = MediaQuery.paddingOf(context).bottom + 15;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () {showBranchesEditorView(context);},
        child: const Icon(Icons.add, size: 40),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: topSafeHeight, left: 24, right: 24),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: cs.surface,
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: cs.onSurface,
                      size: 26,
                    ),
                  ),
                ),
                Spacer(),
                Text(
                  "employees_list".tr,
                  style: TextStyle(
                    fontSize: 18,
                    color: cs.onSurface,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: cs.surface,
                    ),
                    child: Icon(
                      Icons.filter_list,
                      color: cs.onSurface,
                      size: 32,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
                color: cs.surface,
              ),
              child: GetBuilder<BranchesController>(
                builder: (controller) {
                  if (controller.isLoading) {
                    return SizedBox(
                      height: 750,
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  }
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.branchesList.length,
                          itemBuilder: (context, index) {
                            final branch = controller.branchesList[index];
                            return _buildEmployeeCard(context, branch);
                          },
                        ),
                        SizedBox(height: bottomSafeHeight),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeCard(BuildContext context, BranchModel branch) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () {showBranchesEditorView(context , branch: branch);},
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: AppThemes.cardShadowColor,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    branch.name + "branch".tr,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: cs.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
