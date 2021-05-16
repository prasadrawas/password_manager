import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:get/get.dart';
import 'package:password_manager/contoller/loading_controller.dart';
import 'package:password_manager/model/user_model.dart';
import 'package:password_manager/utils/databasehelper.dart';
import 'package:password_manager/utils/encryption.dart';
import 'package:password_manager/utils/snack_bar.dart';
import 'package:password_manager/view/auth/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Email extends StatelessWidget {
  final String _pin;
  final TextEditingController _editingController = TextEditingController();
  Email(this._pin);
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
                  'Email',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: height * 0.018,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: width * 0.05, right: width * 0.05, top: 10),
                child: TextFormField(
                  controller: _editingController,
                  keyboardType: TextInputType.emailAddress,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Your Email Address',
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
              child: GetBuilder<LoadingController>(builder: (controller) {
                return ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xFF1461e3))),
                  onPressed: controller.isLoading
                      ? null
                      : () async {
                          if (validateEmail(_editingController.text)) {
                            controller.updateLoading();
                            await new DatabaseHelper().createUser(new User(
                                1,
                                Encryption.encryptText(_pin),
                                _editingController.text.toLowerCase().trim()));
                            SharedPreferences pref =
                                await SharedPreferences.getInstance();
                            pref.setBool('user', true);
                            controller.updateLoading();
                            Get.offAll(() => Login());
                          } else {
                            MySnackBar.getSnackBar(
                                'Invalid', 'Please Enter Valid Email Address');
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
                          'Next',
                          style: TextStyle(color: Colors.white),
                        ),
                );
              }),
            ),
          ],
        ),
        elevation: 0,
      ),
    );
  }

  bool validateEmail(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }
}
