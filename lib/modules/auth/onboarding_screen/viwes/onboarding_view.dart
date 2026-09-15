import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class OnBoarding extends StatelessWidget {
  const OnBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final heroImage = 'assets/images/hero.png';

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          Expanded(
            flex: 60,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.15),
                border: Border(
                  bottom: BorderSide(
                    color: cs.onSurface.withValues(alpha: 0.2),
                    width: 2,
                  ),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Center(
                  child: Image.asset(
                    heroImage,
                    semanticLabel: 'onBoarding Image',
                    width: 351,
                    height: 297,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 40,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Spacer(),
                    Text(
                      'onboarding_title'.tr,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'onboarding_subtitle'.tr,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 1.2,
                        color: cs.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    const Spacer(flex: 2),
                    MaterialButton(
                      onPressed: () {
                        Get.toNamed("/signup");
                      },
                      height: 56,
                      elevation: 0,
                      color: cs.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        "create_account_button".tr,
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: cs.onPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    MaterialButton(
                      onPressed: () {
                        Get.toNamed("/login");
                      },
                      height: 56,
                      elevation: 0,
                      color: cs.onSurface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        "log_in_button".tr,
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: cs.surface,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
