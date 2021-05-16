import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:password_manager/contoller/add_form_controller.dart';
import 'package:password_manager/contoller/authentication_controller.dart';
import 'package:password_manager/contoller/hideshowpassword_controller.dart';
import 'package:password_manager/contoller/random_password.dart';
import 'package:password_manager/contoller/url_controller.dart';
import 'package:password_manager/lifecycle_manager.dart';
import 'package:password_manager/model/credential_model.dart';
import 'package:password_manager/utils/databasehelper.dart';
import 'package:password_manager/utils/encryption.dart';
import 'package:password_manager/utils/pairs.dart';
import 'package:password_manager/utils/snack_bar.dart';
import 'package:password_manager/view/auth/authenticate.dart';
import 'package:password_manager/view/dashboard.dart';
import 'package:password_manager/widgets.dart';

class CredentialUserInput extends StatelessWidget {
  final TextEditingController _titlecontroller = new TextEditingController();
  static TextEditingController webController = new TextEditingController();
  final TextEditingController _usernameController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<Pairs> _textController = [];
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
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
                                'Login Credentials',
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
                              child: GetBuilder<URLContoller>(
                                  builder: (controller) {
                                return TextFormField(
                                  keyboardType: TextInputType.text,
                                  controller: _titlecontroller,
                                  textCapitalization: TextCapitalization.words,
                                  onChanged: (s) async {
                                    controller.updateUrl(s);
                                  },
                                  validator: (s) {
                                    if (s.contains('.') ||
                                        s.contains('http') ||
                                        s.isEmpty) {
                                      return 'Invalid Website Title';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      hintText: 'Title',
                                      labelText: 'Website Title',
                                      suffixIcon: Icon(Icons.language)),
                                );
                              }),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GetBuilder<URLContoller>(
                                  builder: (controller) {
                                return TextFormField(
                                  controller: webController,
                                  keyboardType: TextInputType.url,
                                  validator: (s) {
                                    if (s.isEmpty) return 'Invalid URL';
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      hintText: 'https://',
                                      labelText: 'URL',
                                      suffixIcon: Icon(Icons.language)),
                                );
                              }),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: _usernameController,
                                validator: (s) {
                                  if (s.isEmpty) {
                                    return 'Invalid username';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    hintText: 'Username/ID',
                                    labelText: 'Website Username',
                                    suffixIcon: Icon(Icons.account_circle)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GetBuilder<HideShowPassword>(
                                  builder: (controller) {
                                return TextFormField(
                                  obscureText: controller.showPassword,
                                  controller: _passwordController,
                                  onTap: () {},
                                  validator: (s) {
                                    if (s.isEmpty) {
                                      return 'Invalid password';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    hintText: '* * * * *',
                                    labelText: 'Password',
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          controller.updateStatus();
                                        },
                                        icon: controller.showPassword
                                            ? Icon(Icons.remove_red_eye)
                                            : Icon(
                                                Icons.remove_red_eye_outlined)),
                                  ),
                                );
                              }),
                            ),
                            InkWell(
                                borderRadius: BorderRadius.circular(10),
                                onTap: () {
                                  Get.defaultDialog(
                                      title: 'Generate Password',
                                      content: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: GetBuilder<RandomPassword>(
                                                  // init: RandomPassword(),
                                                  builder: (controller) {
                                                return Text(
                                                  controller.password,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18,
                                                  ),
                                                );
                                              }),
                                            ),
                                          ),
                                          GetBuilder<RandomPassword>(
                                              // init: RandomPassword(),
                                              builder: (controller) {
                                            return Slider(
                                              value: controller.range,
                                              onChanged: (s) {
                                                controller.updateRange(s);
                                              },
                                              min: 1,
                                              max: 30,
                                            );
                                          }),
                                          GetBuilder<RandomPassword>(
                                              // init: RandomPassword(),
                                              builder: (controller) {
                                            return Text(
                                              'Length : ${(controller.range).toInt()}',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w300,
                                                fontSize: height * 0.018,
                                              ),
                                            );
                                          }),
                                        ],
                                      ),
                                      actions: [
                                        GetBuilder<RandomPassword>(
                                            builder: (controller) {
                                          return ElevatedButton(
                                              onPressed: () {
                                                Clipboard.setData(
                                                    new ClipboardData(
                                                        text: controller
                                                            .password));
                                                Get.back();
                                                MySnackBar.getSnackBar('Copied',
                                                    'Copied to Clipboard');
                                              },
                                              child: Text('Copy Password'));
                                        }),
                                      ]);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text('Generate Password'),
                                )),
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
                                      Credentials cred = new Credentials(
                                          null,
                                          webController.text
                                                  .toLowerCase()
                                                  .trim() +
                                              "/favicon.ico",
                                          _titlecontroller.text.trim(),
                                          webController.text
                                              .toLowerCase()
                                              .trim(),
                                          _usernameController.text,
                                          Encryption.encryptText(
                                              _passwordController.text),
                                          getExtras(_textController));
                                      await helper.insertCredential(cred);
                                      MySnackBar.getSnackBar(
                                          'Successful', 'Saved Successfully.');
                                      await Future.delayed(
                                          Duration(seconds: 1));
                                      LifecycleManager
                                          .lifeCycleManager.addFormController
                                          .clearAll();
                                      Get.offAll(() => Dashboard(),
                                          transition: Transition.rightToLeft);
                                    } catch (e) {
                                      MySnackBar.getSnackBar(
                                          'Failed', e.toString());
                                    } finally {
                                      webController.clear();
                                    }
                                  }
                                },
                                child: Text('Save Credentials'),
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
