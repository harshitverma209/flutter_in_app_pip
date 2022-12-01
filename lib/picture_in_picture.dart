import 'package:flutter/material.dart';
import 'package:flutter_in_app_pip/pip_material_app.dart';

class PictureInPicture {
  static bool isActive = false;
  static GlobalKey<PiPMaterialAppState> pipKey = GlobalKey();
  static void stopPiP() {
    pipKey.currentState?.changeOverlay();
    isActive = false;
  }

  static void startPiP({required Widget pipWidget}) {
    pipKey.currentState?.changeOverlay(overlay: pipWidget);
    isActive = true;
  }

  static void updatePiPWindowSize(
      {required double height, required double width}) {
    pipKey.currentState?.updatePiPWindowSize(height: height, width: width);
  }
}
