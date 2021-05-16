import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_manager/contoller/authentication_controller.dart';
import 'package:password_manager/utils/databasehelper.dart';
import 'package:password_manager/utils/encryption.dart';
import 'package:password_manager/utils/fingerprint_auth.dart';
import 'package:password_manager/utils/snack_bar.dart';
import 'package:password_manager/view/auth/authenticate.dart';
import 'package:pinput/pin_put/pin_put.dart';

class UserProfile extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _textEditingController = TextEditingController();
  final DatabaseHelper _helper = DatabaseHelper();

  final FocusNode _pinPutFocusNode = FocusNode();
  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Colors.blueAccent),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return GetBuilder<AuthController>(
      builder: (controller) {
        return controller.isAuthenticate == false
            ? Authenticate()
            : Scaffold(
                body: SafeArea(
                  child: FutureBuilder(
                    future: _helper.getUserData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      print(snapshot.data);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(height * 0.070),
                            child: Center(
                                child: Icon(
                              Icons.account_circle,
                              size: height * 0.080,
                            )),
                          ),
                          Divider(),
                          GetListTile('Email', snapshot.data['email'],
                              Icon(Icons.mail)),
                          GetListTile('Pin', '* * * *', Icon(Icons.lock)),
                        ],
                      );
                    },
                  ),
                ),
                bottomNavigationBar: Container(
                  height: height * 0.060,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: height * 0.040),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.android_rounded,
                              size: height * 0.018,
                              color: Colors.black54,
                            ),
                            SizedBox(
                              width: height * 0.020,
                            ),
                            Text(
                              'App Developer',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: height * 0.018,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: height * 0.010,
                      ),
                      Text(
                        'Prasad Rawas',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: height * 0.015,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              );
      },
    );
  }

  GetListTile(title, subtitle, icon) {
    return ListTile(
      leading: icon,
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: IconButton(
          onPressed: () async {
            if (await new FingerprintAuth().authenticateFingerprint()) {
              Get.defaultDialog(
                  title: 'Edit $title',
                  content: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        GetTextField(title),
                      ],
                    ),
                  ),
                  textCancel: 'Cancel',
                  onCancel: () {
                    _textEditingController.clear();
                  },
                  textConfirm: 'Edit',
                  confirmTextColor: Colors.white,
                  onConfirm: () async {
                    if (_formKey.currentState.validate()) {
                      try {
                        DatabaseHelper helper = DatabaseHelper();
                        title == 'Email'
                            ? helper.updateUserEmail(
                                _textEditingController.text.trim())
                            : helper.updateUserPin(Encryption.encryptText(
                                _textEditingController.text.trim()));

                        Get.back();
                        MySnackBar.getSnackBar(
                            'Invalid', '$title updated Successfully.');
                      } catch (e) {
                        Get.back();
                        MySnackBar.getSnackBar('Invalid', e.toString());
                      } finally {
                        _textEditingController.clear();
                      }
                    }
                  });
            }
          },
          icon: Icon(Icons.edit)),
    );
  }

  GetTextField(title) {
    if (title == 'Email') {
      return TextFormField(
        keyboardType: TextInputType.emailAddress,
        controller: _textEditingController,
        validator: (s) {
          if (s.isEmpty) {
            return 'Invalid $title';
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: '$title',
          labelText: '$title',
        ),
      );
    } else if (title == 'Pin') {
      return PinPut(
        fieldsCount: 4,
        onSubmit: (String pin) {},
        autofocus: true,
        focusNode: _pinPutFocusNode,
        controller: _textEditingController,
        validator: (s) {
          if (s.length < 4) return 'Invalid Pin';
          return null;
        },
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
      );
    }
  }
}
