import 'package:get/get.dart';
import 'package:password_manager/view/user_inputs/credential_user_input.dart';

class URLContoller extends GetxController {
  String url = 'https://';

  updateUrl(String u) {
    url = 'https://' + u.toLowerCase();
    CredentialUserInput.webController.text = url + '.com';
    update();
  }
}
