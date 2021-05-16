import 'package:flutter/material.dart';
import 'package:password_manager/lifecycle_manager.dart';
import 'package:password_manager/utils/databasehelper.dart';
import 'package:password_manager/utils/encryption.dart';
import 'package:password_manager/utils/fingerprint_auth.dart';
import 'package:password_manager/utils/snack_bar.dart';
import 'package:pinput/pin_put/pin_put.dart';

class Authenticate extends StatelessWidget {
  final _manager = LifecycleManager();
  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Colors.blueAccent),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  _biometricAuth() async {
    LifecycleManager.status = 1;
    if (await new FingerprintAuth().mainAuthenticateFingerprint()) {
      login(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    LifecycleManager.decider = false;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    if (LifecycleManager.status == 0) _biometricAuth();
    return WillPopScope(
      onWillPop: () async {
        MySnackBar.getSnackBar('Restricted', 'Cannot go back.');
        return false;
      },
      child: Scaffold(
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
                    'Enter Pin to Authenticate',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: height * 0.018,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: width * 0.2,
                      right: width * 0.2,
                      top: height * 0.05),
                  child: PinPut(
                    fieldsCount: 4,
                    onSubmit: (String pin) async {
                      login(1);
                    },
                    focusNode: LifecycleManager.pinFocusNode,
                    controller: LifecycleManager.pinController,
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
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
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
      ),
    );
  }

  login(int id) async {
    if (id == 0) {
      LifecycleManager.decider = true;
      _manager.authController.updateAuthStatus();
    } else {
      DatabaseHelper helper = await DatabaseHelper();
      if (LifecycleManager.pinController.text.length < 4) {
        MySnackBar.getSnackBar('Invalid', 'Pin Enter 4 Digit Pin');
      } else if (await helper.loginUser(
          Encryption.encryptText(LifecycleManager.pinController.text))) {
        LifecycleManager.decider = true;
        _manager.authController.updateAuthStatus();
      } else {
        MySnackBar.getSnackBar('Failed', 'Incorrect Pin');
      }
    }
  }
}
