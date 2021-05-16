import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:password_manager/contoller/add_form_controller.dart';
import 'package:password_manager/contoller/authentication_controller.dart';
import 'package:password_manager/lifecycle_manager.dart';
import 'package:password_manager/model/account_model.dart';
import 'package:password_manager/utils/databasehelper.dart';
import 'package:password_manager/utils/encryption.dart';
import 'package:password_manager/utils/fingerprint_auth.dart';
import 'package:password_manager/utils/pairs.dart';
import 'package:password_manager/utils/snack_bar.dart';
import 'package:password_manager/view/auth/authenticate.dart';
import 'package:password_manager/view/dashboard.dart';
import 'package:password_manager/widgets.dart';

class BankUserInput extends StatelessWidget {
  final TextEditingController _bankNameController = new TextEditingController();
  final TextEditingController _accountNumberController =
      new TextEditingController();
  final TextEditingController _bankUrl = new TextEditingController();
  final TextEditingController _ifscNumberController =
      new TextEditingController();
  final TextEditingController _holderNameController =
      new TextEditingController();
  final TextEditingController _phoneNumber = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<Pairs> _textController = [];
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    _bankUrl.text='https://';
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
                                'Account Information',
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
                                  if (s.trim().isEmpty) {
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
                                keyboardType: TextInputType.number,
                                controller: _accountNumberController,
                                validator: (s) {
                                  if (s.trim().length < 1) {
                                    return 'Invalid Account Number';
                                  }
                                  return null;
                                },
                                onChanged: (num) {},
                                decoration: InputDecoration(
                                  counterText: "",
                                  hintText: 'xxxx xxxx xxxx xxxx',
                                  labelText: 'Account Number',
                                  suffixIcon: IconButton(
                                      onPressed: () {},
                                      icon: Icon(Icons.credit_card_rounded)),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: _ifscNumberController,
                                textCapitalization:
                                    TextCapitalization.characters,
                                validator: (s) {
                                  return null;
                                },
                                decoration: InputDecoration(
                                    hintText: 'IFSC',
                                    labelText: 'IFSC Code',
                                    suffixIcon: Icon(Icons.description)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: _holderNameController,
                                textCapitalization: TextCapitalization.words,
                                validator: (s) {
                                  if (s.trim().isEmpty) {
                                    return 'Invalid name';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    hintText: 'Name',
                                    labelText: 'Account Holder Name',
                                    suffixIcon: Icon(Icons.account_circle)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                maxLength: 10,
                                controller: _phoneNumber,
                                validator: (s) {
                                  return null;
                                },
                                decoration: InputDecoration(
                                  counterText: "",
                                  hintText: 'Number',
                                  labelText: 'Phone Number',
                                  suffixIcon: IconButton(
                                      onPressed: () {}, icon: Icon(Icons.call)),
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
                                      DatabaseHelper helper = DatabaseHelper();
                                      _ifscNumberController.text.isEmpty? _ifscNumberController.text='None':null;
                                      _holderNameController.text.isEmpty? _holderNameController.text='None':null;
                                      _phoneNumber.text.isEmpty? _phoneNumber.text='None':null;
                                      AccountModel account = new AccountModel(
                                          null,
                                          _bankNameController.text.trim(),
                                          Encryption.encryptText(
                                              _accountNumberController.text
                                                  .trim()),
                                          _ifscNumberController.text.trim(),
                                          _holderNameController.text.trim(),
                                          _phoneNumber.text.trim(),
                                          _bankUrl.text.trim(),
                                          _bankUrl.text.trim() + '/favicon.ico',
                                          getExtras(_textController));
                                      await helper.insertAccount(account);
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
