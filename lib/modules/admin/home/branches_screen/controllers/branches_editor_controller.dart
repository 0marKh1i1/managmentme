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

  BranchModel? branch;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController fenceRadiusController = TextEditingController();

  GoogleMapController? mapController;
  CameraPosition initialPosition = const CameraPosition(
    target: LatLng(31.9539, 35.9106),
    zoom: 14,
  );
  LatLng? selectedLocation;
  LatLng? _cameraCenter;
  bool isPickingLocation = false;

  TimeOfDay selectedTime = const TimeOfDay(hour: 9, minute: 0);
  Duration selectedWorkingHours = const Duration(hours: 8);


  Duration get _checkInDuration =>
      Duration(hours: selectedTime.hour, minutes: selectedTime.minute);

  String _fmt(Duration d) {
    final total = d.inMinutes % (24 * 60);
    final h = (total ~/ 60).toString().padLeft(2, '0');
    final m = (total % 60).toString().padLeft(2, '0');
    return '$h:$m';
  }

  String get workingHoursText => _fmt(selectedWorkingHours);
  String get firstCheckOutText => _fmt(_checkInDuration + selectedWorkingHours);


  @override
  void onInit() {
    super.onInit();
    fenceRadiusController.addListener(update);
  }

  void initWith(BranchModel? branch) {
    this.branch = branch;
    isPickingLocation = false;

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
      selectedWorkingHours = branch.workingHours;
      isNew = false;
    } else {
      nameController.clear();
      fenceRadiusController.clear();
      selectedLocation = null;
      initialPosition = const CameraPosition(
        target: LatLng(31.9539, 35.9106),
        zoom: 14,
      );
      selectedTime = const TimeOfDay(hour: 9, minute: 0);
      selectedWorkingHours = const Duration(hours: 8);
      isNew = true;
    }

    _cameraCenter = initialPosition.target;
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
    mapController = null;
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

  Set<Circle> get circles {
    final radius = double.tryParse(fenceRadiusController.text);
    if (selectedLocation == null ||
        radius == null ||
        radius <= 0 ||
        isPickingLocation) {
      return {};
    }

    return {
      Circle(
        circleId: const CircleId('fence'),
        center: selectedLocation!,
        radius: radius,
        fillColor: Colors.blue.withValues(alpha: 0.15),
        strokeColor: Colors.blue,
        strokeWidth: 2,
      ),
    };
  }

  void onCameraMove(CameraPosition position) {
    _cameraCenter = position.target;
  }

  void animateToLocation() {
    if (selectedLocation != null) {
      mapController?.animateCamera(CameraUpdate.newLatLng(selectedLocation!));
    }
  }

  void startPickingLocation() {
    isPickingLocation = true;
    if (selectedLocation != null) {
      _cameraCenter = selectedLocation;
    }
    animateToLocation();
    update();
  }

  void confirmLocation() {
    selectedLocation = _cameraCenter ?? selectedLocation;
    isPickingLocation = false;
    update();
  }

  void cancelPickingLocation() {
    if (!isPickingLocation) return;
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

  Future<void> pickWorkingHours(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: selectedWorkingHours.inHours,
        minute: selectedWorkingHours.inMinutes % 60,
      ),
      helpText: 'working_hours'.tr,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      ),
    );

    if (picked != null) {
      selectedWorkingHours = Duration(
        hours: picked.hour,
        minutes: picked.minute,
      );
      update();
    }
  }


  Future<void> saveChanges() async {
    if (isSaving) return;

    if (isPickingLocation) {
      toast('error'.tr, 'confirm_or_cancel_location'.tr);
      return;
    }
    if (!formKey.currentState!.validate()) return;
    if (selectedLocation == null) {
      toast('error'.tr, 'select_location'.tr);
      return;
    }
    if (selectedWorkingHours == Duration.zero) {
      toast('error'.tr, 'working_hours_required'.tr);
      return;
    }

    final radius = double.parse(fenceRadiusController.text);
    final name = nameController.text.trim();
    final location = GeoPoint(
      selectedLocation!.latitude,
      selectedLocation!.longitude,
    );
    final checkInTime = _checkInDuration;

    isSaving = true;
    update();

    try {
      if (branch == null) {
        await BranchesRepo.createBranch(
          BranchModel(
            id: "",
            name: name,
            location: location,
            fenceRadius: radius,
            lastCheckInTime: checkInTime,
            workingHours: selectedWorkingHours,
          ),
        );
      } else {
        await BranchesRepo.updatBranch(
          branch!.copyWith(
            name: name,
            location: location,
            fenceRadius: radius,
            lastCheckInTime: checkInTime,
            workingHours: selectedWorkingHours,
          ),
        );
      }
      if (isClosed) return;
      Get.find<BranchesController>().fetchBranches();
      Get.back();
    } catch (e) {
      debugPrint(e.toString());
      toast('error'.tr, e.toString());
      isSaving = false;
      if (!isClosed) update();
    }
  }
}