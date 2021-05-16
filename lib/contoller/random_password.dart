import 'package:get/get.dart';

class RandomPassword extends GetxController {
  String password = '';
  double range = 8;
  List<String> list = [];
  @override
  void onInit() {
    super.onInit();
    range = 8.0;
    list = [
      'A',
      'B',
      'C',
      'D',
      'E',
      'F',
      'G',
      'H',
      'I',
      'J',
      'K',
      'L',
      'M',
      'N',
      'O',
      'P',
      'Q',
      'R',
      'S',
      'T',
      'U',
      'V',
      'W',
      'X',
      'Y',
      'Z',
      'a',
      'b',
      'c',
      'd',
      'e',
      'f',
      'g',
      'h',
      'i',
      'j',
      'k',
      'l',
      'm',
      'n',
      'o',
      'p',
      'q',
      'r',
      's',
      't',
      'u',
      'v',
      'w',
      'x',
      'y',
      'z',
      '!',
      '@',
      '#',
      '%',
      '^',
      '&',
      '*',
      '(',
      ')',
      '_',
      '-',
      '+',
      '=',
      '{',
      '[',
      '}',
      ']',
      '|',
      ':',
      ';',
      '<',
      ',',
      '>',
      '.',
      '?',
      '/'
    ];
    password = '';
  }

  updateRange(index) {
    range = (index.ceil()).toDouble();
    generatePassword(range.toInt());
    update();
  }

  generatePassword(int length) {
    password = '';
    for (int i = 1; i <= length; i++) {
      password += (list..shuffle()).first;
    }
    update();
  }
}
