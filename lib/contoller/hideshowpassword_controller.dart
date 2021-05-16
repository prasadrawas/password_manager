import 'package:get/get.dart';

class HideShowPassword extends GetxController {
  bool showPassword = true;
  @override
  void onInit() {
    // TODO: implement onInit
    showPassword = true;
    super.onInit();
  }

  updateStatus() {
    showPassword = !showPassword;
    update();
  }
}
