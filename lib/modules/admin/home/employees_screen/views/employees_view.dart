import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/route_manager.dart';
import 'package:get/utils.dart';
import 'package:managementme/core/models/user_model.dart';
import 'package:managementme/core/widgets/user_card.dart';
import 'package:managementme/modules/admin/home/home_screen/controllers/home_controller.dart';

class EmployeesView extends StatelessWidget {
  const EmployeesView({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final double topSafeHeight = MediaQuery.paddingOf(context).top + 15;
    final double bottomSafeHeight = MediaQuery.paddingOf(context).bottom + 15;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
              child: GetBuilder<HomeController>(
                builder: (controller) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.employees.length,
                          itemBuilder: (context, index) {
                            final employee = controller.employees[index];
                            return _buildEmployeeCard(employee);
                          },
                        ),
                        SizedBox(height: bottomSafeHeight),
                      ],
                    ),
                  );
                }
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeCard(UserModel employee) {
    return UserCard(user: employee);
  }
}
