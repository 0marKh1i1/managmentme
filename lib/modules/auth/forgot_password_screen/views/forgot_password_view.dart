import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managementme/core/widgets/custom_text_field.dart';
import 'package:managementme/modules/auth/forgot_password_screen/controllers/forgot_password_controller.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

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
                    child: GetBuilder<ForgotPasswordController>(
                      init: ForgotPasswordController(),
                      builder: (controller) {
                        return Form(
                          key: controller.formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 24),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (Get.global(null).currentState?.canPop() ?? false) {
                                        Get.back();
                                      }
                                    },
                                    child: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.primary, size: 24),
                                  ),
                                  const SizedBox(width: 24),
                                  Text(
                                    "forgot_password".tr,
                                    style: GoogleFonts.inter(
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal,
                                      color: Theme.of(context).colorScheme.onSurface,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 50),
                              Text(
                                "forgot_password_instruction".tr,
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 60),
                              CustomTextField(
                                controller: controller.email,
                                hintText: "email".tr,
                                prefixIcon: Icons.email_outlined,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'email_empty_error'.tr;
                                  }
                                  return null;
                                },
                              ),
                              const Spacer(),
                              const SizedBox(height: 24),
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
                                child: MaterialButton(
                                  onPressed: controller.isLoading ? null : () async {
                                    await controller.submit();
                                  },
                                  height: 52,
                                  minWidth: double.infinity,
                                  color: Theme.of(context).colorScheme.primary,
                                  disabledColor: Colors.grey,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 0,
                                  child: controller.isLoading 
                                    ? SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Theme.of(context).colorScheme.onPrimary))
                                    : Text(
                                        "submit_button".tr,
                                        style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: Theme.of(context).colorScheme.onPrimary,
                                        ),
                                      ),
                                ),
                              ),
                              const SizedBox(height: 32),
                            ],
                          ),
                        );
                      }
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
