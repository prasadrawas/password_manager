import 'package:get/get.dart';

class SearchController extends GetxController {
  bool isSearching = false;
  @override
  void onInit() {
    isSearching = false;
    super.onInit();
  }

  startSearching() {
    isSearching = true;
    update();
  }

  stopSearching() {
    isSearching = false;
    update();
  }
}
