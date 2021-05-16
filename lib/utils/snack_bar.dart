import 'package:get/get.dart';

class MySnackBar {
  static getSnackBar(title, message) {
    return Get.rawSnackbar(
      title: title,
      message: message,
      duration: Duration(seconds: 1),
    );
  }
}
