import 'package:get/get.dart';

class AddFormController extends GetxController {
  List<dynamic> forms = [];

  deleteForm(index) {
    forms.removeAt(index);
    update();
  }

  addForm(form) {
    forms.add(form);
    update();
  }

  clearAll() {
    forms.clear();
    update();
  }
}
