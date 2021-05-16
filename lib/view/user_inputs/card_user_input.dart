import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:password_manager/contoller/add_form_controller.dart';
import 'package:password_manager/contoller/authentication_controller.dart';
import 'package:password_manager/contoller/date_controller.dart';
import 'package:password_manager/contoller/hideshowpassword_controller.dart';
import 'package:password_manager/lifecycle_manager.dart';
import 'package:password_manager/model/card_model.dart';
import 'package:password_manager/utils/databasehelper.dart';
import 'package:password_manager/utils/encryption.dart';
import 'package:password_manager/utils/pairs.dart';
import 'package:password_manager/utils/snack_bar.dart';
import 'package:password_manager/view/auth/authenticate.dart';
import 'package:password_manager/view/dashboard.dart';
import 'package:password_manager/widgets.dart';

class CardUserInput extends StatelessWidget {
  final TextEditingController _bankNameController = new TextEditingController();
  final TextEditingController _urlController = new TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _holderNameController = TextEditingController();
  final TextEditingController _cvvController = new TextEditingController();
  static TextEditingController dateController = new TextEditingController();
  static TextEditingController _pinController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<Pairs> _textController = [];
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    _urlController.text='https://';
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
                                'Card Details',
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
                                controller: _urlController,
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
                                maxLength: 16,
                                controller: _cardNumberController,
                                validator: (s) {
                                  if (s.trim().length < 16) {
                                    return 'Invalid Card Number';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  counterText: "",
                                  hintText: 'xxxx xxxx xxxx xxxx',
                                  labelText: 'Card Number',
                                  suffixIcon: Icon(Icons.credit_card_rounded),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: _holderNameController,
                                textCapitalization: TextCapitalization.words,
                                validator: (s) {
                                  if (s.isEmpty) {
                                    return 'Invalid name';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    hintText: 'Name',
                                    labelText: 'Card Holder Name',
                                    suffixIcon: Icon(Icons.account_circle)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GetBuilder<DateController>(
                                init: DateController(),
                                builder: (controller) {
                                  return TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: dateController,
                                    validator: (s) {
                                      if (s.trim().length < 7) {
                                        return 'Invalid Date';
                                      }
                                      return null;
                                    },
                                    onChanged: (date) {
                                      controller.updateDate(date);
                                    },
                                    maxLength: 7,
                                    decoration: InputDecoration(
                                        counterText: "",
                                        hintText: 'MM / YY',
                                        labelText: 'Valid Through',
                                        suffixIcon:
                                            Icon(Icons.calendar_today_rounded)),
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GetBuilder<HideShowPassword>(
                                init: HideShowPassword(),
                                builder: (controller) {
                                  return TextFormField(
                                    keyboardType: TextInputType.number,
                                    obscureText: controller.showPassword,
                                    maxLength: 3,
                                    controller: _cvvController,
                                    validator: (s) {
                                      if (s.trim().length < 3) {
                                        return 'Invalid CVV';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      counterText: "",
                                      hintText: '* * *',
                                      labelText: 'CVV',
                                      suffixIcon: IconButton(
                                          onPressed: () {
                                            controller.updateStatus();
                                          },
                                          icon: controller.showPassword
                                              ? Icon(Icons.remove_red_eye)
                                              : Icon(Icons
                                                  .remove_red_eye_outlined)),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GetBuilder<HideShowPassword>(
                                init: HideShowPassword(),
                                builder: (controller) {
                                  return TextFormField(
                                    keyboardType: TextInputType.number,
                                    obscureText: controller.showPassword,
                                    maxLength: 4,
                                    controller: _pinController,
                                    validator: (s) {
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      counterText: "",
                                      hintText: '* * * *',
                                      labelText: 'Pin',
                                      suffixIcon: IconButton(
                                          onPressed: () {
                                            controller.updateStatus();
                                          },
                                          icon: controller.showPassword
                                              ? Icon(Icons.remove_red_eye)
                                              : Icon(Icons
                                                  .remove_red_eye_outlined)),
                                    ),
                                  );
                                },
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
                                      _cvvController.text.isEmpty ? _cvvController.text='None':null;
                                      _pinController.text.isEmpty ? _pinController.text='None':null;
                                      _holderNameController.text.isEmpty ? _holderNameController.text='None':null;
                                      DatabaseHelper helper = DatabaseHelper();
                                      CreditCard card = CreditCard(
                                          null,
                                          _bankNameController.text.trim(),
                                          _urlController.text.trim(),
                                          _urlController.text + "/favicon.ico",
                                          Encryption.encryptText(
                                              _cardNumberController.text
                                                  .trim()),
                                          _holderNameController.text.trim(),
                                          dateController.text,
                                          Encryption.encryptText(
                                              _cvvController.text),
                                          Encryption.encryptText(
                                              _pinController.text),
                                          getExtras(_textController));
                                      await helper.insertCard(card);
                                      MySnackBar.getSnackBar(
                                          'Successful', 'Saved Successfully.');

                                      await Future.delayed(
                                          Duration(seconds: 1));
                                      _cardNumberController.clear();
                                      dateController.clear();
                                      _pinController.clear();
                                      _cardNumberController.clear();
                                      dateController.clear();
                                      _pinController.clear();
                                      LifecycleManager
                                          .lifeCycleManager.addFormController
                                          .clearAll();
                                      Get.offAll(() => Dashboard(),
                                          transition: Transition.rightToLeft,
                                          duration:
                                              Duration(milliseconds: 200));
                                    } catch (e) {
                                      MySnackBar.getSnackBar(
                                          'Failed', e.toString());
                                    }
                                  }
                                },
                                child: Text('Save Card'),
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
