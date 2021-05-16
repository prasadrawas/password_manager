import 'package:get/get.dart';

class DashboardController extends GetxController {
  int index = 0;

  @override
  void onInit() {
    index = 0;
    super.onInit();
  }

  updateIndex(int i) {
    index = i;
    update();
  }
}
