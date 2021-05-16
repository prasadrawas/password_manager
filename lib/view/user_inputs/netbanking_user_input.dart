import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:password_manager/contoller/add_form_controller.dart';
import 'package:password_manager/contoller/authentication_controller.dart';
import 'package:password_manager/lifecycle_manager.dart';
import 'package:password_manager/model/netbanking_model.dart';
import 'package:password_manager/utils/databasehelper.dart';
import 'package:password_manager/utils/encryption.dart';
import 'package:password_manager/utils/pairs.dart';
import 'package:password_manager/utils/snack_bar.dart';
import 'package:password_manager/view/auth/authenticate.dart';
import 'package:password_manager/widgets.dart';

import '../dashboard.dart';

class NetbankingUserInput extends StatelessWidget {
  final _bankNameController = TextEditingController();
  final _userID = TextEditingController();
  final _corporateID = TextEditingController();
  final _bankUrl = TextEditingController();
  final _loginPass = TextEditingController();
  final _profilePass = TextEditingController();
  final _transactionPass = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<Pairs> _textController = [];
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    _bankUrl.text = "https://";
    return GetBuilder<AuthController>(builder: (controller) {
      return controller.isAuthenticate == false
          ? Authenticate()
          : Scaffold(
              body: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: SafeArea(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                'Net Banking',
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: height * 0.040,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: width * 0.2,
                                  right: width * 0.2,
                                  top: height * 0.010,
                                  bottom: height * 0.010),
                              child: Divider(
                                height: height * 0.020,
                                color: Color(0xFF1461e3),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                controller: _bankNameController,
                                textCapitalization: TextCapitalization.words,
                                onChanged: (s) async {},
                                validator: (s) {
                                  if (s.isEmpty) {
                                    return 'Invalid Bank Name';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    hintText: 'Name',
                                    labelText: 'Bank Name',
                                    suffixIcon: Icon(Icons.account_balance)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                keyboardType: TextInputType.url,
                                controller: _bankUrl,
                                onChanged: (s) async {},
                                validator: (s) {
                                  return null;
                                },
                                decoration: InputDecoration(
                                    hintText: 'https://',
                                    labelText: 'URL',
                                    suffixIcon: Icon(Icons.language)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: _userID,
                                validator: (s) {
                                  return null;
                                },
                                decoration: InputDecoration(
                                    hintText: 'ID',
                                    labelText: 'User ID',
                                    suffixIcon: Icon(Icons.account_circle)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: _corporateID,
                                textCapitalization: TextCapitalization.words,
                                validator: (s) {
                                  return null;
                                },
                                decoration: InputDecoration(
                                    hintText: 'ID',
                                    labelText: 'Corporate ID',
                                    suffixIcon: Icon(Icons.account_circle)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                controller: _loginPass,
                                validator: (s) {
                                  return null;
                                },
                                decoration: InputDecoration(
                                  counterText: "",
                                  hintText: '* * * *',
                                  labelText: 'Login Password',
                                  suffixIcon: IconButton(
                                      onPressed: () {}, icon: Icon(Icons.lock)),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                controller: _profilePass,
                                validator: (s) {
                                  return null;
                                },
                                decoration: InputDecoration(
                                  counterText: "",
                                  hintText: '* * * *',
                                  labelText: 'Profile Password',
                                  suffixIcon: IconButton(
                                      onPressed: () {}, icon: Icon(Icons.lock)),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                controller: _transactionPass,
                                validator: (s) {
                                  return null;
                                },
                                decoration: InputDecoration(
                                  counterText: "",
                                  hintText: '* * * *',
                                  labelText: 'Transaction Password',
                                  suffixIcon: IconButton(
                                      onPressed: () {}, icon: Icon(Icons.lock)),
                                ),
                              ),
                            ),
                            GetBuilder<AddFormController>(
                                builder: (controller) {
                              return ListView(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                children: [
                                  ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: controller.forms.length,
                                    itemBuilder: (_, index) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          controller.forms[index],
                                          Container(
                                            padding: EdgeInsets.only(
                                                right: height * 0.020),
                                            child: ElevatedButton.icon(
                                              style: ElevatedButton.styleFrom(
                                                primary: Colors.white,
                                              ),
                                              icon: Icon(
                                                Icons.delete,
                                                color: Colors.black54,
                                              ),
                                              onPressed: () {
                                                if (controller.forms.length >
                                                    0) {
                                                  controller.deleteForm(index);
                                                }
                                                if (_textController.length >
                                                    0) {
                                                  _textController
                                                      .removeAt(index);
                                                }
                                              },
                                              label: Text(
                                                'Delete',
                                                style: TextStyle(
                                                  color: Colors.black54,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                  addFormButton(controller, () {
                                    _textController.add(Pairs(
                                        TextEditingController(),
                                        TextEditingController()));
                                    controller.addForm(ExtraFieldForm(
                                        _textController[
                                            _textController.length - 1]));
                                  }, height, 'Add another field'),
                                ],
                              );
                            }),
                            Padding(
                              padding: const EdgeInsets.all(40),
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    try {
                                      _userID.text.isEmpty
                                          ? _userID.text = 'None'
                                          : null;
                                      _corporateID.text.isEmpty
                                          ? _corporateID.text = 'None'
                                          : null;
                                      _loginPass.text.isEmpty
                                          ? _loginPass.text = 'None'
                                          : null;
                                      _profilePass.text.isEmpty
                                          ? _profilePass.text = 'None'
                                          : null;
                                      _transactionPass.text.isEmpty
                                          ? _transactionPass.text = 'None'
                                          : null;
                                      DatabaseHelper helper = DatabaseHelper();
                                      NetBankingModel account =
                                          new NetBankingModel(
                                              null,
                                              _bankNameController.text.trim(),
                                              _bankUrl.text.trim(),
                                              Encryption.encryptText(
                                                  _userID.text.trim()),
                                              Encryption.encryptText(
                                                  _corporateID.text.trim()),
                                              Encryption.encryptText(
                                                  _loginPass.text.trim()),
                                              Encryption.encryptText(
                                                  _profilePass.text.trim()),
                                              Encryption.encryptText(
                                                  _transactionPass.text.trim()),
                                              getExtras(_textController));

                                      await helper.insertNetBanking(account);
                                      MySnackBar.getSnackBar(
                                          'Successful', 'Saved Successfully.');
                                      await Future.delayed(
                                          Duration(seconds: 1));
                                      LifecycleManager
                                          .lifeCycleManager.addFormController
                                          .clearAll();
                                      Get.offAll(() => Dashboard(),
                                          transition: Transition.rightToLeft,
                                          duration:
                                              Duration(microseconds: 200));
                                    } catch (e) {
                                      MySnackBar.getSnackBar(
                                          'Failed', e.toString());
                                    }
                                  }
                                },
                                child: Text('Save Account'),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
    });
  }
}
