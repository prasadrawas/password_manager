import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_manager/utils/snack_bar.dart';
import 'package:password_manager/view/auth/email.dart';
import 'package:pinput/pin_put/pin_put.dart';

class Confirm extends StatelessWidget {
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  final String _pin;
  Confirm(this._pin);

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Colors.blueAccent),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/images/app_logo.png',
                  height: height * 0.08,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Confirm Pin',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: height * 0.016,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: width * 0.2, right: width * 0.2, top: height * 0.05),
                child: PinPut(
                  fieldsCount: 4,
                  autofocus: true,
                  onSubmit: (String pin) {
                    validatePin();
                  },
                  focusNode: _pinPutFocusNode,
                  controller: _pinPutController,
                  submittedFieldDecoration: _pinPutDecoration.copyWith(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  selectedFieldDecoration: _pinPutDecoration,
                  followingFieldDecoration: _pinPutDecoration.copyWith(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(
                      color: Colors.blueAccent.withOpacity(.8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Color(0xFF1461e3))),
                onPressed: () {
                  Get.back();
                },
                child: Text(
                  'Previous',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Color(0xFF1461e3))),
                onPressed: () {
                  validatePin();
                },
                child: Text(
                  'Next',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        elevation: 0,
      ),
    );
  }

  validatePin() {
    if (_pinPutController.text.length < 4) {
      MySnackBar.getSnackBar('Invalid', 'Please Enter 4 Digit Pin');
    } else {
      if (_pin == _pinPutController.text) {
        Get.to(() => Email(_pin), transition: Transition.rightToLeft);
      } else {
        MySnackBar.getSnackBar('Invalid', 'Please Enter Valid Pin');
      }
    }
  }
}
