import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:managementme/modules/employee/home/home_screen/controllers/home_controller.dart';

class Home extends GetView<HomeController> {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final double topSafeHeight = MediaQuery.paddingOf(context).top + 15;
    final double bottomSafeHeight = MediaQuery.paddingOf(context).bottom + 15;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: cs.primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
              height: 300,
            ),
            Column(
              children: [
                SizedBox(height: topSafeHeight),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 8),
                    Row(
                      children: [
                        SizedBox(width: 25),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Let’s Clock-In!".tr,
                              style: GoogleFonts.inter(
                                color: cs.onPrimary,
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "Don’t miss your clock in schedule".tr,
                              style: GoogleFonts.inter(
                                color: cs.onPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        Image.asset(
                          'assets/images/home/clock_wing.png',
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: 8),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 24),
                Column(
                  children: [
                    GetBuilder<HomeController>(
                      builder: (controller) {
                        return Container(
                          height: 275,
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: cs.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 24,
                          ),
                          child: Column(
                            spacing: 20,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Amman Branch Working Hours:",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight(800),
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    "8",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight(800),
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: Row(
                                  spacing: 8,
                                  children: [
                                    _buildTimeCard(
                                      context,
                                      "Check-In Time",
                                      "08:40 AM",
                                    ),
                                    _buildTimeCard(
                                      context,
                                      "Check-Out Time",
                                      "05:40 PM",
                                    ),
                                  ],
                                ),
                              ),
                              MaterialButton(
                                onPressed: () {},
                                color: cs.primary,
                                height: 48,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Center(
                                  child: Text(
                                    "Clock In",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    ),
                  ],
                ),
                SizedBox(height: bottomSafeHeight),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeCard(BuildContext context, String label, String time) {
    final cs = Theme.of(context).colorScheme;

    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: cs.surfaceTint,
          border: Border.all(
            color: cs.onSurface.withAlpha(100),
            strokeAlign: BorderSide.strokeAlignOutside,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.watch_later, color: cs.onSurface, size: 16),
                SizedBox(width: 4),
                Text(
                  label,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(time, style: TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}
