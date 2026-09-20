import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:managementme/core/constants/app_themes.dart';
import 'package:managementme/core/models/attendance_model.dart';
import 'package:managementme/modules/admin/home/attendance_screen/controllers/attendance_controller.dart';
import 'package:managementme/modules/admin/home/attendance_screen/views/attendance_editor_view.dart';
import 'package:intl/intl.dart';

class AttendanceView extends StatelessWidget {
  const AttendanceView({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final double topSafeHeight = MediaQuery.paddingOf(context).top + 15;
    final double bottomSafeHeight = MediaQuery.paddingOf(context).bottom + 15;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAttendanceEditorView(context);
        },
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
                  "attendance_list".tr,
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
              child: GetBuilder<AttendanceController>(
                builder: (controller) {
                  if (controller.isLoading) {
                    return SizedBox(
                      height: 750,
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  }
                  
                  if (controller.attendancesList.isEmpty) {
                    return Center(
                      child: Text("no_attendance_records".tr),
                    );
                  }
                  
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.attendancesList.length,
                          itemBuilder: (context, index) {
                            final attendance = controller.attendancesList[index];
                            return _buildAttendanceCard(context, attendance, controller);
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

  Widget _buildAttendanceCard(BuildContext context, AttendanceModel attendance, AttendanceController controller) {
    final cs = Theme.of(context).colorScheme;
    final user = controller.getUser(attendance.userId);
    final branch = controller.getBranch(attendance.branchId);
    
    final userName = user?.name ?? 'unknown_user'.tr;
    final branchName = branch?.name ?? 'unknown_branch'.tr;
    
    final dateStr = DateFormat('yyyy/MM/dd').format(attendance.date);
    final checkInStr = attendance.checkInTime != null 
        ? DateFormat('HH:mm').format(attendance.checkInTime!) 
        : '--:--';
    final checkOutStr = attendance.checkOutTime != null 
        ? DateFormat('HH:mm').format(attendance.checkOutTime!) 
        : '--:--';
        
    return InkWell(
      onTap: () {
        showAttendanceEditorView(context, attendance: attendance);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: cs.surfaceDim,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: AppThemes.cardShadowColor,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  userName,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface,
                  ),
                ),
                Text(
                  dateStr,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.business, size: 16, color: cs.onSurfaceVariant),
                SizedBox(width: 4),
                Text(
                  branchName,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'check_in'.tr,
                      style: GoogleFonts.inter(fontSize: 12, color: cs.onSurfaceVariant),
                    ),
                    Text(
                      checkInStr,
                      style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'check_out'.tr,
                      style: GoogleFonts.inter(fontSize: 12, color: cs.onSurfaceVariant),
                    ),
                    Text(
                      checkOutStr,
                      style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
