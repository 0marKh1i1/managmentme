import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:managementme/core/models/branch_model.dart';
import 'package:managementme/core/models/user_model.dart';
import 'package:managementme/modules/settings/settings_screen/repo/settings_repo.dart';
import 'package:managementme/modules/settings/settings_screen/widgets/edit_name_dialog.dart';
import 'package:managementme/modules/settings/settings_screen/widgets/image_picker_sheet.dart';
import 'package:managementme/modules/settings/settings_screen/widgets/logout_dialog.dart';
import 'package:managementme/core/widgets/toast.dart';
import 'package:managementme/core/servicesAndControllers/localization_service.dart';
import 'dart:async';

class SettingsController extends GetxController {
  UserModel? currentUser;
  bool isUploadingImage = false;
  bool isUpdatingName = false;
  BranchModel? branch;
  String get branchName => (branch?.name ?? 'unkown'.tr) + 'branch'.tr;

  final ImagePicker _imagePicker = ImagePicker();

  StreamSubscription? _userSub;

  @override
  void onInit() {
    super.onInit();
    _bindUserStream();
  }

  void _bindUserStream() {
    _userSub?.cancel();
    _userSub = SettingsRepo.getUserStream().listen((user) {
      currentUser = user;
      if (currentUser != null) {
        _fetchBranch(currentUser?.branchId ?? "");
      }
      update();
    });
  }

  Future<void> refreshData() async {
    _bindUserStream();
  }

  void showEditNameDialog() {
    Get.dialog(
      EditNameDialog(
        initialName: currentUser?.name ?? '',
        onSave: (newName) => saveName(newName),
      ),
    );
  }

  Future<void> _fetchBranch(String branchID) async {
    if (branchID.isEmpty) return;
    branch = await SettingsRepo.getBranch(branchID);
    debugPrint('$branchName this is the branch **************************************************');
    update();
  }

  Future<void> saveName(String newName) async {
    final trimmedName = newName.trim();
    if (trimmedName.isEmpty) {
      toast('Error', 'name_empty_error'.tr);
      return;
    }
    if (trimmedName == currentUser?.name) {
      if (Get.isDialogOpen == true) Get.back();
      return;
    }
    isUpdatingName = true;
    update();
    try {
      await SettingsRepo.updateName(trimmedName);
      if (Get.isDialogOpen == true) Get.back();
      toast('Success', 'name_updated_successfully'.tr);
    } catch (e) {
      toast(
        'Error',
        "${'failed_to_update_name'.tr}: ${e.toString().replaceAll('Exception: ', '')}",
      );
    } finally {
      isUpdatingName = false;
      update();
    }
  }

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
      await SettingsRepo.updateProfileImage(image);
      toast('Success', 'profile_photo_updated'.tr);
    } catch (e) {
      toast(
        'Error',
        "${'failed_to_update_photo'.tr}: ${e.toString().replaceAll('Exception: ', '')}",
      );
    } finally {
      isUploadingImage = false;
      update();
    }
  }

  Future<void> removeImage() async {
    try {
      isUploadingImage = true;
      update();
      await SettingsRepo.removeProfileImage();
      toast('Success', 'profile_photo_removed'.tr);
    } catch (e) {
      toast(
        'Error',
        "${'failed_to_remove_photo'.tr}: ${e.toString().replaceAll('Exception: ', '')}",
      );
    } finally {
      isUploadingImage = false;
      update();
    }
  }

  void toggleLanguage(String langCode) {
    Get.find<LocalizationService>().toggleLanguage(langCode);
    update();
  }

  void showLogoutDialog() {
    Get.dialog(const LogoutDialog());
  }

  Future<void> logout() async {
    Get.back();
    Get.delete<SettingsController>();
    await SettingsRepo.logout();
  }

  @override
  void onClose() {
    _userSub?.cancel();
    super.onClose();
  }
}
