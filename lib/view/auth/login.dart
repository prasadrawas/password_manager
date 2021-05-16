import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_manager/contoller/loading_controller.dart';
import 'package:password_manager/lifecycle_manager.dart';
import 'package:password_manager/utils/databasehelper.dart';
import 'package:password_manager/utils/encryption.dart';
import 'package:password_manager/utils/fingerprint_auth.dart';
import 'package:password_manager/utils/mail.dart';
import 'package:password_manager/utils/snack_bar.dart';
import 'package:password_manager/view/dashboard.dart';
import 'package:pinput/pin_put/pin_put.dart';

class Login extends StatelessWidget {
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  final _manager = LifecycleManager();
  int _status = 0;
  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Colors.blueAccent),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  _biometricAuth() async {
    _status = 1;
    if (await new FingerprintAuth().mainAuthenticateFingerprint()) {
      login(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    if (_status == 0) _biometricAuth();
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
                  'Enter Pin to Login',
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
                  onSubmit: (String pin) async {
                    login(1);
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
              child: GetBuilder<LoadingController>(builder: (controller) {
                return TextButton(
                  onPressed: () async {
                    if (await Mail.checkInternetConnection()) {
                      controller.updateLoading();
                      Mail.forgotPassword(controller);
                    } else {
                      MySnackBar.getSnackBar(
                          'Invalid', 'Please check your Internet Connection');
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
                          'Forgot Pin ?',
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
                  login(1);
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

  login(int id) async {
    if (id == 0) {
      _manager.authController.updateAuthStatus();
      Get.offAll(() => Dashboard(), transition: Transition.rightToLeft);
    } else {
      DatabaseHelper helper = await DatabaseHelper();
      if (_pinPutController.text.length < 4) {
        MySnackBar.getSnackBar('Invalid', 'Pin Enter 4 Digit Pin');
      } else if (await helper
          .loginUser(Encryption.encryptText(_pinPutController.text))) {
        _manager.authController.updateAuthStatus();
        Get.offAll(() => Dashboard(), transition: Transition.rightToLeft);
      } else {
        MySnackBar.getSnackBar('Invalid', 'Incorrect Pin');
      }
    }
  }
}
