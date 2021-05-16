import 'package:flutter/material.dart';

class Pairs {
  TextEditingController title;
  TextEditingController answer;
  Pairs(this.title, this.answer);
}

String getExtras(List<Pairs> controllers) {
  var extra = '';
  for (int i = 0; i < controllers.length; i++) {
    extra += controllers[i].title.text.trim();
    extra = extra + ':' + controllers[i].answer.text.trim() + ";";
  }
  return extra;
}

String seperateExtras(String ex, String title, controllerText) {
  if (ex != '') {
    int start = ex.indexOf(title);
    int end = start;
    while (ex[end] != ';') {
      end++;
    }
    ex = ex.replaceRange(start, end, title + ":" + controllerText);
  }
  return ex;
}
