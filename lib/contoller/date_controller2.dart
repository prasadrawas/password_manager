import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_manager/view/details_section/card_details.dart';

class DateController2 extends GetxController {
  String date = '';
  @override
  void onInit() {
    date = '';
    CardDetails.textEditingController.clear();
    super.onInit();
  }

  updateDate(String d) {
    if (d.length == 2) {
      date = d + " / ";
      CardDetails.textEditingController.text = date;
      CardDetails.textEditingController.selection =
          TextSelection.fromPosition(TextPosition(offset: date.length));
    } else if (d.length == 5) {
      date = d.substring(0, 2);
      CardDetails.textEditingController.text = date;
      CardDetails.textEditingController.selection =
          TextSelection.fromPosition(TextPosition(offset: date.length));
    }
    update();
  }
}
