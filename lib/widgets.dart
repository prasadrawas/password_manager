import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:password_manager/utils/pairs.dart';
import 'package:password_manager/utils/snack_bar.dart';

GetDialogBox(title, contentText) {
  Get.defaultDialog(
    title: title,
    content: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            contentText,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 18,
            ),
          ),
        ),
      ],
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
            onPressed: () {
              Clipboard.setData(new ClipboardData(text: contentText));
              Get.back();
              MySnackBar.getSnackBar('Copied', 'Copied to Clipboard');
            },
            child: Text('Copy $title')),
      )
    ],
  );
}

Widget addFormButton(controller, onPressed, height, btnTitle) {
  return Padding(
    padding: EdgeInsets.all(height * 0.020),
    child: ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        primary: Colors.grey.shade100,
      ),
      label: Text(
        btnTitle,
        style: TextStyle(color: Colors.black87),
      ),
      icon: Icon(
        Icons.add_circle_outline,
        color: Colors.black87,
      ),
    ),
  );
}

Widget ExtraFieldForm(Pairs p) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      children: [
        Expanded(
          child: TextFormField(
            keyboardType: TextInputType.text,
            controller: p.title,
            textCapitalization: TextCapitalization.words,
            validator: (s) {
              if (s.trim().length == 0) return 'Invalid';
              return null;
            },
            decoration: InputDecoration(
              counterText: "",
              hintText: '',
              labelText: 'Title',
            ),
          ),
        ),
        SizedBox(
          width: 5,
        ),
        Expanded(
          child: TextFormField(
            keyboardType: TextInputType.text,
            controller: p.answer,
            validator: (s) {
              if (s.trim().length == 0) return 'Invalid';
              return null;
            },
            decoration: InputDecoration(
              counterText: "",
              hintText: '',
              labelText: 'Answer',
            ),
          ),
        ),
      ],
    ),
  );
}
