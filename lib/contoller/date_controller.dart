import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_manager/view/user_inputs/card_user_input.dart';

class DateController extends GetxController {
  String date = '';
  @override
  void onInit() {
    date = '';
    CardUserInput.dateController.clear();
    super.onInit();
  }

  updateDate(String d) {
    if (d.length == 2) {
      date = d + " / ";
      CardUserInput.dateController.text = date;
      CardUserInput.dateController.selection =
          TextSelection.fromPosition(TextPosition(offset: date.length));
    } else if (d.length == 5) {
      date = d.substring(0, 2);
      CardUserInput.dateController.text = date;
      CardUserInput.dateController.selection =
          TextSelection.fromPosition(TextPosition(offset: date.length));
    }
    update();
  }
}
