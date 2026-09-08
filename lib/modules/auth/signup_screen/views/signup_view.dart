import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managementme/modules/auth/signup_screen/controllers/signup_controller.dart';
import 'package:managementme/core/widgets/custom_text_field.dart';

class SignUp extends GetView<SignupController> {
  const SignUp({super.key});

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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Get.offAllNamed("/onBoarding");
                                },
                                child: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.primary, size: 24),
                              ),
                              const SizedBox(width: 24),
                              Text(
                                "create_account".tr,
                                style: GoogleFonts.inter(
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),
                          SizedBox(
                            width: double.infinity,
                            child: Text.rich(
                              textAlign: TextAlign.center, 
                              TextSpan(
                                text: 'signup_welcome_title'.tr,
                                style: GoogleFonts.inter(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                                children: <InlineSpan>[
                                  TextSpan(
                                    text: "\n${'signup_welcome_subtitle'.tr}",
                                    style: GoogleFonts.inter(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface.withValues(alpha: 0.8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          CustomTextField(
                            controller: controller.username,
                            hintText: 'display_name'.tr,
                            prefixIcon: Icons.person_outline,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'username_empty_error'.tr;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
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
                          Obx(() => CustomTextField(
                            controller: controller.pass,
                            hintText: 'password'.tr,
                            prefixIcon: Icons.lock_outline,
                            obscureText: controller.hidePass.value,
                            onChanged: controller.updatePasswordStr,
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.hidePass.value ? Icons.visibility_off : Icons.visibility,
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                              ),
                              onPressed: controller.togglePass,
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
                          )),
                          const SizedBox(height: 20),
                          Obx(() => CustomTextField(
                            controller: controller.confirmPass,
                            hintText: 'confirm_password'.tr,
                            prefixIcon: Icons.lock_outline,
                            obscureText: controller.hideConfirmPass.value,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'confirm_password_empty_error'.tr;
                              }
                              if (value != controller.passwordstr) {
                                return 'passwords_do_not_match_error'.tr;
                              }
                              return null;
                            },
                          )),
                          
                          const SizedBox(height: 50),
                          Text.rich(
                            textAlign: TextAlign.center,
                            TextSpan(
                              text: 'terms_agreement'.tr,
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
                                height: 1.4,
                              ),
                              children: [
                                TextSpan(
                                  text: 'terms_of_use'.tr,
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                                const TextSpan(text: ' '),
                                TextSpan(text: 'and'.tr),
                                const TextSpan(text: ' '),
                                TextSpan(
                                  text: 'privacy_policy'.tr,
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).shadowColor.withValues(alpha: 0.08),
                                  offset: const Offset(0, 4),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: Obx(() => MaterialButton(
                              onPressed: controller.isLoading.value ? null : (() async => (await controller.onSignupButton())),
                              height: 52,
                              minWidth: double.infinity,
                              color: Theme.of(context).colorScheme.primary,
                              disabledColor: Colors.grey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                              child: controller.isLoading.value 
                                ? SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Theme.of(context).colorScheme.onPrimary))
                                : Text(
                                    "create_account_button".tr,
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Theme.of(context).colorScheme.onPrimary,
                                    ),
                                  ),
                            )),
                          ),
                          const SizedBox(height: 50),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    "already_have_account_prompt".tr,
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  GestureDetector(
                                    onTap: () {
                                      Get.offNamed("/login");
                                    },
                                    child: Text(
                                      "login_here_prompt".tr,
                                      style: GoogleFonts.inter(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).colorScheme.primary,
                                        decoration: TextDecoration.underline,
                                        decorationColor: Theme.of(context).colorScheme.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
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
