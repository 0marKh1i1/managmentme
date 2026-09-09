import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:managementme/core/constants/app_themes.dart';
import 'package:managementme/modules/home/home_screen/controllers/home_controller.dart';

class Home extends GetView<HomeController> {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final double statusBarHeight = MediaQuery.paddingOf(context).top + 15;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(24, statusBarHeight, 24, 24),
                height: 200,
                color: AppThemes.homeHeaderColor,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Home',
                          style: TextStyle(
                            color: cs.onSurface,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
