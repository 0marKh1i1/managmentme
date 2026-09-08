import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:managementme/modules/home/home_screen/controllers/home_controller.dart';
import 'package:managementme/modules/profile/profile_screen/models/user_model.dart';
import 'package:managementme/modules/profile/profile_screen/repo/profile_repo.dart';
import 'package:managementme/modules/profile/profile_screen/widgets/edit_name_dialog.dart';
import 'package:managementme/modules/profile/profile_screen/widgets/image_picker_sheet.dart';
import 'package:managementme/modules/profile/profile_screen/widgets/logout_dialog.dart';
import 'package:managementme/core/widgets/toast.dart';
import 'package:managementme/core/servicesAndControllers/localization_service.dart';
import 'dart:async';

class ProfileController extends GetxController {
  UserModel? currentUser;
  int totalTasks = 0;
  bool isUploadingImage = false;
  bool isUpdatingName = false;

  final nameController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

  StreamSubscription? _userSub;

  @override
  void onInit() {
    super.onInit();
    _userSub = ProfileRepo.getUserStream().listen((user) {
      currentUser = user;
      update();
    });
  }



  void updateTasksCount(int count) {
    totalTasks = count;
    update();
  }

  /// Shows a dialog to edit the user's display name.
  void showEditNameDialog() {
    nameController.text = currentUser?.name ?? '';
    Get.dialog(const EditNameDialog());
  }

  Future<void> saveName() async {
    final newName = nameController.text.trim();
    if (newName.isEmpty) {
      toast('name_empty_error'.tr);
      return;
    }
    if (newName == currentUser?.name) {
      Get.back();
      return;
    }
    isUpdatingName = true;
    update();
    try {
      await ProfileRepo.updateName(newName);
      Get.back();
      toast('name_updated_successfully'.tr);
    } catch (e) {
      toast("${'failed_to_update_name'.tr}: ${e.toString().replaceAll('Exception: ', '')}");
    } finally {
      isUpdatingName = false;
      update();
    }
  }

  /// Shows a bottom sheet to pick a new profile image.
  void showImagePickerSheet() {
    Get.bottomSheet(const ImagePickerBottomSheet());
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );
      if (image == null) return;
      isUploadingImage = true;
      update();
      await ProfileRepo.updateProfileImage(image);
      toast('profile_photo_updated'.tr);
    } catch (e) {
      toast("${'failed_to_update_photo'.tr}: ${e.toString().replaceAll('Exception: ', '')}");
    } finally {
      isUploadingImage = false;
      update();
    }
  }

  Future<void> removeImage() async {
    try {
      isUploadingImage = true;
      update();
      await ProfileRepo.removeProfileImage();
      toast('profile_photo_removed'.tr);
    } catch (e) {
      toast("${'failed_to_remove_photo'.tr}: ${e.toString().replaceAll('Exception: ', '')}");
    } finally {
      isUploadingImage = false;
      update();
    }
  }

  void toggleLanguage(String langCode) {
    Get.find<LocalizationService>().toggleLanguage(langCode);
    update();
  }

  /// Shows a confirmation dialog then logs the user out.
  void showLogoutDialog() {
    Get.dialog(const LogoutDialog());
  }

  Future<void> logout() async {
    Get.back();
    await ProfileRepo.logout();
  }

  @override
  void onClose() {
    _userSub?.cancel();
    nameController.dispose();
    super.onClose();
  }
}
