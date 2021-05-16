import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_manager/contoller/loading_controller.dart';
import 'package:password_manager/utils/mail.dart';
import 'package:password_manager/utils/snack_bar.dart';
import 'package:password_manager/view/auth/create.dart';
import 'package:pinput/pin_put/pin_put.dart';

class Forgot extends StatelessWidget {
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  final String _pin;

  Forgot(this._pin);
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
                  height: height * 0.1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Verify PIN',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: height * 0.018,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: width * 0.2, right: width * 0.2, top: height * 0.05),
                child: PinPut(
                  fieldsCount: 4,
                  onSubmit: (String pin) {},
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
              Padding(
                padding: EdgeInsets.only(
                    left: width * 0.2, right: width * 0.2, top: 10),
                child: Text(
                  'Resend PIN is sent to your Email. Please check your Email.',
                  style: TextStyle(
                    fontSize: height * 0.018,
                  ),
                ),
              )
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
              child: GetBuilder<LoadingController>(builder: (controller) {
                return TextButton(
                  onPressed: () async {
                    if (await Mail.checkInternetConnection()) {
                      Mail.forgotPassword(controller);
                    } else {
                      MySnackBar.getSnackBar('Connection Error',
                          'Please check your Internet Connection');
                    }
                  },
                  child: controller.isLoading
                      ? SizedBox(
                          height: height * 0.015,
                          width: height * 0.015,
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Resend',
                          style: TextStyle(
                            fontSize: height * 0.019,
                            color: Color(0xFF1461e3),
                          ),
                        ),
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Color(0xFF1461e3))),
                onPressed: () {
                  verifyPin();
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

  verifyPin() {
    if (_pinPutController.text != _pin) {
      MySnackBar.getSnackBar(
          'Invalid', 'You have entered wrong pin, Please try again.');
    } else {
      Get.offAll(Create());
    }
  }
}
