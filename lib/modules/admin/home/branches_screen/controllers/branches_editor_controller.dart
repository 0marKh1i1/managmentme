import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:managementme/core/models/branch_model.dart';
import 'package:managementme/core/widgets/toast.dart';
import 'package:managementme/modules/admin/home/branches_screen/controllers/branches_controller.dart';
import 'package:managementme/modules/admin/home/branches_screen/repo/branches_repo.dart';

class BranchesEditorController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool _isLocked = true;
  bool get isLoacked => _isLocked;
  bool get isEnabled => !_isLocked;

  bool isNew = false;
  bool isSaving = false;

  late BranchModel? branch;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController fenceRadiusController = TextEditingController();

  GoogleMapController? mapController;
  var initialPosition = CameraPosition(
    target: LatLng(31.9539, 35.9106),
    zoom: 14,
  );
  LatLng? selectedLocation;
  LatLng? _cameraCenter;
  bool isPickingLocation = false;

  TimeOfDay selectedTime = TimeOfDay(hour: 9 , minute: 0);

  void initWith(BranchModel? branch) {
    this.branch = branch;
    if (branch != null) {
      nameController.text = branch.name;
      fenceRadiusController.text = branch.fenceRadius.toString();
      selectedLocation = LatLng(
        branch.location.latitude,
        branch.location.longitude,
      );
      initialPosition = CameraPosition(target: selectedLocation!, zoom: 14);
      selectedTime = TimeOfDay(
        hour: branch.lastCheckInTime.inHours,
        minute: branch.lastCheckInTime.inMinutes % 60,
      );
      isNew = false;
    } else {
      nameController.clear();
      fenceRadiusController.clear();
      selectedLocation = null;
      initialPosition = const CameraPosition(
        target: LatLng(31.9539, 35.9106),
        zoom: 14,
      );
      isNew = true;
    }
    fenceRadiusController.addListener(update);
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(initialPosition),
    );
    update();
  }

  @override
  void onClose() {
    fenceRadiusController.removeListener(update);
    nameController.dispose();
    fenceRadiusController.dispose();
    super.onClose();
  }

  Set<Marker> get markers => (selectedLocation == null || isPickingLocation)
      ? {}
      : {
          Marker(
            markerId: const MarkerId('branch'),
            position: selectedLocation!,
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueAzure,
            ),
          ),
        };

  void onCameraMove(CameraPosition position) {
    _cameraCenter = position.target;
  }

  Set<Circle> get circles {
    final center = isPickingLocation ? _cameraCenter : selectedLocation;
    final radius = double.tryParse(fenceRadiusController.text);
    if (center == null || radius == null || radius <= 0 || isPickingLocation) {
      return {};
    }

    return {
      Circle(
        circleId: const CircleId('fence'),
        center: center,
        radius: radius,
        fillColor: Colors.blue.withValues(alpha: 0.15),
        strokeColor: Colors.blue,
        strokeWidth: 2,
      ),
    };
  }

  void onCameraIdle() {
    if (!isPickingLocation) update();
  }

  void animateToLocation() {
    if (selectedLocation != null) {
      mapController?.animateCamera(CameraUpdate.newLatLng(selectedLocation!));
    }
  }

  void startPickingLocation() {
    isPickingLocation = true;
    animateToLocation();
    update();
  }

  void confirmLocation() {
    selectedLocation = _cameraCenter;
    isPickingLocation = false;
    update();
  }

  void cancelPickingLocation() {
    isPickingLocation = false;
    update();
    animateToLocation();
  }

  void setIsLoacked(bool b) {
    _isLocked = b;
    if (b) cancelPickingLocation();
    update();
  }

  bool toggleLock() {
    setIsLoacked(!_isLocked);
    return isLoacked;
  }

  Future<void> pickTime(BuildContext context) async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (newTime != null) {
      selectedTime = newTime;
      update();
    }
  }

  void saveChanges() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    BranchModel updatedBranch;
    isSaving = true;
    update();

    try {
      if (branch == null) {
        await BranchesRepo.createBranch(
          BranchModel(
            id: "",
            name: nameController.text,
            location: GeoPoint(
              selectedLocation!.latitude,
              selectedLocation!.longitude,
            ),
            fenceRadius: double.tryParse(fenceRadiusController.text)!,
            lastCheckInTime:  Duration(hours: selectedTime.hour, minutes: selectedTime.minute),
          ),
        );
      } else {
        updatedBranch = branch!.copyWith(
          name: nameController.text,
          location: GeoPoint(
            selectedLocation!.latitude,
            selectedLocation!.longitude,
          ),
          fenceRadius: double.tryParse(fenceRadiusController.text)!,
        );
        await BranchesRepo.updatBranch(updatedBranch);
      }
      if (isClosed) return;
      Get.find<BranchesController>().fetchBranches();
      Get.back();
    } catch (e) {
      debugPrint(e.toString());
      toast('error'.tr, e.toString());
      isSaving = false;
      update();
    }
  }
}
