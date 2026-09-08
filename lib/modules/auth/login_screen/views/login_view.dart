import 'package:managementme/modules/auth/login_screen/controllers/login_controller.dart';
import 'package:managementme/core/widgets/custom_text_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Login extends GetView<LoginController> {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: IntrinsicHeight(
                    child: Form(
                      key: controller.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Get.offAllNamed("/onBoarding");
                                },
                                child: Icon(
                                  Icons.arrow_back,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 24),
                              Text(
                                "log_in".tr,
                                style: GoogleFonts.inter(
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          const SizedBox(height: 50),
                          SizedBox(
                            width: double.infinity,
                            child: Text.rich(
                              textAlign: TextAlign.center,
                              TextSpan(
                                text: 'login_head'.tr,
                                style: GoogleFonts.inter(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                                children: <InlineSpan>[
                                  TextSpan(
                                    text: "\n${'login_welcome'.tr}",
                                    style: GoogleFonts.inter(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withValues(alpha: 0.8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 60),
                          CustomTextField(
                            controller: controller.email,
                            hintText: 'email_address'.tr,
                            prefixIcon: Icons.email_outlined,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'email_empty_error'.tr;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          Obx(
                            () => CustomTextField(
                              controller: controller.pass,
                              hintText: 'password'.tr,
                              prefixIcon: Icons.lock_outline,
                              obscureText: controller.hidePass.value,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  controller.hidePass.value
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Theme.of(context).colorScheme.onSurface
                                      .withValues(alpha: 0.7),
                                ),
                                onPressed: controller.togglepass,
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'password_empty_error'.tr;
                                }
                                if (value.length < 6) {
                                  return 'password_length_error'.tr;
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {
                                Get.toNamed("/forgotPassword");
                              },
                              child: Text(
                                "forgot_password_prompt".tr,
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.outlineVariant,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),

                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(
                                    context,
                                  ).shadowColor.withValues(alpha: 0.08),
                                  offset: const Offset(0, 4),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: Obx(
                              () => MaterialButton(
                                onPressed: controller.isLoading.value
                                    ? null
                                    : (() async =>
                                          (await controller.onLoginButton())),
                                height: 52,
                                minWidth: double.infinity,
                                color: (Theme.of(context).colorScheme.primary),
                                disabledColor: Colors.grey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                                child: controller.isLoading.value
                                    ? SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: CircularProgressIndicator(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onPrimary,
                                        ),
                                      )
                                    : Text(
                                        "log_in_button".tr,
                                        style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onPrimary,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          Spacer(),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    "no_account_prompt".tr,
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withValues(alpha: 0.8),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  GestureDetector(
                                    onTap: () {
                                      Get.offNamed("/signup");
                                    },
                                    child: Text(
                                      "create_account_prompt".tr,
                                      style: GoogleFonts.inter(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.outlineVariant,
                                        decoration: TextDecoration.underline,
                                        decorationColor: Theme.of(
                                          context,
                                        ).colorScheme.outlineVariant,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 80),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
