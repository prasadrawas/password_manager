import 'package:get/get.dart';

class LoadingController extends GetxController {
  bool isLoading = false;
  @override
  void onInit() {
    isLoading = false;
    super.onInit();
  }

  updateLoading() {
    isLoading = !isLoading;
    update();
  }
}
