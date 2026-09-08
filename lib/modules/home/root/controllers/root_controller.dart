import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RootController extends GetxController {
  final selectedIndex = 1.obs;
  late PageController pageController;
  
  final scrollPhysics = Rx<ScrollPhysics>(const ScrollPhysics()); 

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: selectedIndex.value);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void changePage(int index) async {
    if (selectedIndex.value == index) return;
    
    if (pageController.hasClients && pageController.position.hasContentDimensions) {
      
      scrollPhysics.value = const ClampingScrollPhysics();
      
      double targetExtent = index * pageController.position.viewportDimension;
      
      await pageController.animateTo(
        targetExtent,
        duration: const Duration(milliseconds: 300), 
        curve: Curves.easeInOut,
      );
      
      scrollPhysics.value = const PageScrollPhysics();
    } else {
      selectedIndex.value = index;
      pageController.jumpToPage(index);
    }
  }

  void onPageChanged(int index) {
    if (selectedIndex.value != index) {
      selectedIndex.value = index;
    }
  }
}
