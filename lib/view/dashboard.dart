import 'dart:io';
import 'dart:math';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:password_manager/contoller/authentication_controller.dart';
import 'package:password_manager/contoller/dashboard_controller.dart';
import 'package:password_manager/contoller/random_password.dart';
import 'package:password_manager/lifecycle_manager.dart';
import 'package:password_manager/utils/databasehelper.dart';
import 'package:password_manager/utils/encryption.dart';
import 'package:password_manager/utils/fingerprint_auth.dart';
import 'package:password_manager/utils/snack_bar.dart';
import 'package:password_manager/view/auth/authenticate.dart';
import 'package:password_manager/view/auth/user_profile.dart';
import 'package:password_manager/view/dashboard_view/user_account.dart';
import 'package:password_manager/view/dashboard_view/user_card.dart';
import 'package:password_manager/view/dashboard_view/user_credential.dart';
import 'package:password_manager/view/dashboard_view/user_mobilebanking.dart';
import 'package:password_manager/view/user_inputs/bank_user_input.dart';
import 'package:password_manager/view/user_inputs/card_user_input.dart';
import 'package:password_manager/view/user_inputs/credential_user_input.dart';
import 'package:password_manager/view/user_inputs/mobilebanking_user_input.dart';
import 'package:password_manager/view/user_inputs/netbanking_user_input.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pinput/pin_put/pin_put.dart';

import 'dashboard_view/user_netbanking.dart';

class Dashboard extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _textEditingController =
      new TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  Map<dynamic, String> _headers = {
    0: 'Login Credentials',
    1: 'Debit/Credit Cards',
    2: 'Bank Accounts',
    3: 'Net Banking',
    4: 'Mobile Banking',
  };

  Map<dynamic, Widget> _views = {
    0: UserCredential(),
    1: UserCard(),
    2: UserAccount(),
    3: UserNetBanking(),
    4: UserMobileBanking()
  };

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return GetBuilder<AuthController>(builder: (controller) {
      return controller.isAuthenticate == false
          ? Authenticate()
          : Scaffold(
              key: _scaffoldKey,
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.white,
              drawer: GetBuilder<DashboardController>(
                builder: (controller) {
                  return Drawer(
                    child: ListView(
                      children: [
                        DrawerHeader(
                          child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/app_logo.png',
                                    height: height * 0.065,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text('Password Manager',
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5),
                                ],
                              )),
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.lock_rounded,
                            color: controller.index == 0 ? Colors.white : null,
                          ),
                          title: Text(
                            'Login Credentials',
                            style: TextStyle(
                              color:
                                  controller.index == 0 ? Colors.white : null,
                            ),
                          ),
                          onTap: () {
                            controller.updateIndex(0);
                            Get.back();
                          },
                          tileColor:
                              controller.index == 0 ? Color(0xFF1461e3) : null,
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.credit_card_outlined,
                            color: controller.index == 1 ? Colors.white : null,
                          ),
                          title: Text(
                            'Card Details',
                            style: TextStyle(
                                color: controller.index == 1
                                    ? Colors.white
                                    : null),
                          ),
                          onTap: () {
                            controller.updateIndex(1);
                            Get.back();
                          },
                          tileColor:
                              controller.index == 1 ? Color(0xFF1461e3) : null,
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.account_balance,
                            color: controller.index == 2 ? Colors.white : null,
                          ),
                          title: Text(
                            'Bank Details',
                            style: TextStyle(
                                color: controller.index == 2
                                    ? Colors.white
                                    : null),
                          ),
                          onTap: () {
                            controller.updateIndex(2);
                            Get.back();
                          },
                          tileColor:
                              controller.index == 2 ? Color(0xFF1461e3) : null,
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.desktop_windows_outlined,
                            color: controller.index == 3 ? Colors.white : null,
                          ),
                          title: Text(
                            'Net Banking',
                            style: TextStyle(
                                color: controller.index == 3
                                    ? Colors.white
                                    : null),
                          ),
                          onTap: () {
                            controller.updateIndex(3);
                            Get.back();
                          },
                          tileColor:
                              controller.index == 3 ? Color(0xFF1461e3) : null,
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.phone_android,
                            color: controller.index == 4 ? Colors.white : null,
                          ),
                          title: Text(
                            'Mobile Banking',
                            style: TextStyle(
                                color: controller.index == 4
                                    ? Colors.white
                                    : null),
                          ),
                          onTap: () {
                            controller.updateIndex(4);
                            Get.back();
                          },
                          tileColor:
                              controller.index == 4 ? Color(0xFF1461e3) : null,
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.security,
                          ),
                          title: Text(
                            'Generate Password',
                          ),
                          onTap: () {
                            Get.back();
                            Get.defaultDialog(
                                title: 'Generate Password',
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
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
                                          Clipboard.setData(new ClipboardData(
                                              text: controller.password));
                                          Get.back();
                                          MySnackBar.getSnackBar(
                                              'Copied', 'Copied to Clipboard');
                                        },
                                        child: Text('Copy Password'));
                                  }),
                                ]);
                          },
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.get_app,
                          ),
                          title: Text(
                            'Export DB',
                          ),
                          onTap: () async {
                            LifecycleManager.decider = false;
                            Get.back();
                            if (await FingerprintAuth()
                                .authenticateFingerprint()) {
                              getStoragePermission().then((status) async {
                                try {
                                  File file = new File(
                                      await new DatabaseHelper()
                                          .getDatabasePath());
                                  String fname = 'db';
                                  int random = Random().nextInt(100000);
                                  fname += "_$random";
                                  final dir = await Directory(
                                          '/storage/emulated/0/Password Manager/$fname')
                                      .create(recursive: true);

                                  File newFile = await file.copy(dir.path +
                                      '/${file.path.split('/').last}');

                                  GetDialogBox(
                                    'Exported',
                                    Icon(
                                      Icons.verified,
                                      color: Colors.blue,
                                      size: height * 0.045,
                                    ),
                                    height * 0.019,
                                    'Database Exported Successfully inside Password Manger Folder',
                                  );
                                } catch (e) {
                                  GetDialogBox(
                                    'Failed',
                                    Icon(
                                      Icons.error,
                                      color: Colors.red,
                                      size: height * 0.045,
                                    ),
                                    height * 0.019,
                                    e.toString(),
                                  );
                                }
                              });
                            }
                            LifecycleManager.decider = true;
                          },
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.app_settings_alt,
                          ),
                          title: Text(
                            'Import DB',
                          ),
                          onTap: () async {
                            LifecycleManager.decider = false;
                            Get.back();
                            if (await new FingerprintAuth()
                                .authenticateFingerprint()) {
                              getStoragePermission().then(
                                (status) async {
                                  Get.defaultDialog(
                                    title: 'Enter Pin',
                                    content: Form(
                                      key: _formKey,
                                      child: Column(
                                        children: [
                                          GetTextField(),
                                        ],
                                      ),
                                    ),
                                    textCancel: 'Cancel',
                                    onCancel: () {
                                      _textEditingController.clear();
                                    },
                                    textConfirm: 'Import',
                                    confirmTextColor: Colors.white,
                                    onConfirm: () async {
                                      if (_formKey.currentState.validate()) {
                                        try {
                                          File db = new File(
                                              await new DatabaseHelper()
                                                  .getDatabasePath());

                                          FilePickerResult result =
                                              await FilePicker.platform
                                                  .pickFiles();
                                          File file;
                                          if (result != null) {
                                            file =
                                                File(result.files.single.path);
                                            if (file.path.endsWith('.db')) {
                                              db.writeAsBytes(
                                                  await file.readAsBytes(),
                                                  mode: FileMode.write,
                                                  flush: true);
                                              Get.back();
                                              GetDialogBox(
                                                  'Imported',
                                                  Icon(
                                                    Icons.verified,
                                                    color: Colors.blue,
                                                    size: height * 0.045,
                                                  ),
                                                  height * 0.019,
                                                  'Database Imported Successfully.');
                                              new DatabaseHelper()
                                                  .updateUserPin(
                                                      Encryption.encryptText(
                                                          _textEditingController
                                                              .text));
                                              LifecycleManager.decider = true;
                                            } else {
                                              Get.back();
                                              MySnackBar.getSnackBar(
                                                  'Failed', 'Invalid File');
                                              LifecycleManager.decider = true;
                                            }
                                          }
                                        } catch (e) {
                                          Get.back();
                                          MySnackBar.getSnackBar('Failed',
                                              'Error : ${e.toString()}');
                                          LifecycleManager.decider = true;
                                        } finally {
                                          _textEditingController.clear();
                                          LifecycleManager.decider = true;
                                        }
                                      }
                                    },
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
              body: SafeArea(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: height * 0.015,
                          bottom: height * 0.025,
                        ),
                        child: GetBuilder<DashboardController>(
                            // init: DashboardController(),
                            builder: (controller) {
                          return ListTile(
                            title: Text(_headers[controller.index],
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.headline5),
                            leading: IconButton(
                              onPressed: () {
                                _scaffoldKey.currentState.openDrawer();
                              },
                              icon: Icon(
                                Icons.segment,
                                size: height * 0.030,
                              ),
                            ),
                            trailing: IconButton(
                              onPressed: () async {
                                Get.to(() => UserProfile(),
                                    transition: Transition.rightToLeft);
                              },
                              icon: Image.asset('assets/images/icon.png'),
                            ),
                          );
                        }),
                      ),
                      //Password(),
                      GetBuilder<DashboardController>(
                          // init: DashboardController(),
                          builder: (controller) {
                        return Expanded(
                          child: _views[controller.index],
                        );
                      })
                    ],
                  ),
                ),
              ),
              floatingActionButton: SpeedDial(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.add,
                  color: Color(0xFF1461e3),
                ),
                children: [
                  SpeedDialChild(
                    backgroundColor: Colors.white,
                    child: Center(
                      child: Icon(
                        Icons.lock_rounded,
                        color: Color(0xFF1461e3),
                        size: 15,
                      ),
                    ),
                    label: 'Login Credential',
                    labelBackgroundColor: Colors.white,
                    labelStyle: TextStyle(fontSize: height * 0.018),
                    onTap: () {
                      Get.to(() => CredentialUserInput(),
                          transition: Transition.rightToLeft);
                    },
                  ),
                  SpeedDialChild(
                    backgroundColor: Colors.white,
                    child: Center(
                      child: Icon(
                        Icons.credit_card,
                        color: Color(0xFF1461e3),
                        size: 15,
                      ),
                    ),
                    label: 'Cards',
                    labelBackgroundColor: Colors.white,
                    labelStyle: TextStyle(fontSize: height * 0.018),
                    onTap: () {
                      Get.to(() => CardUserInput(),
                          transition: Transition.rightToLeft);
                    },
                  ),
                  SpeedDialChild(
                    backgroundColor: Colors.white,
                    child: Center(
                      child: Icon(
                        Icons.account_balance,
                        color: Color(0xFF1461e3),
                        size: 15,
                      ),
                    ),
                    label: 'Bank Details',
                    labelBackgroundColor: Colors.white,
                    labelStyle: TextStyle(fontSize: height * 0.018),
                    onTap: () {
                      Get.to(() => BankUserInput(),
                          transition: Transition.rightToLeft);
                    },
                  ),
                  SpeedDialChild(
                    backgroundColor: Colors.white,
                    child: Center(
                      child: Icon(
                        Icons.desktop_windows_outlined,
                        color: Color(0xFF1461e3),
                        size: 15,
                      ),
                    ),
                    label: 'Net Banking',
                    labelBackgroundColor: Colors.white,
                    labelStyle: TextStyle(fontSize: height * 0.018),
                    onTap: () {
                      Get.to(() => NetbankingUserInput(),
                          transition: Transition.rightToLeft);
                    },
                  ),
                  SpeedDialChild(
                    backgroundColor: Colors.white,
                    child: Center(
                      child: Icon(
                        Icons.phone_android,
                        color: Color(0xFF1461e3),
                        size: 15,
                      ),
                    ),
                    label: 'Mobile Banking',
                    labelBackgroundColor: Colors.white,
                    labelStyle: TextStyle(fontSize: height * 0.018),
                    onTap: () {
                      Get.to(() => MobileBankingUserInput(),
                          transition: Transition.rightToLeft);
                    },
                  ),
                ],
              ));
    });
  }

  getAllCards() async {
    print(await new DatabaseHelper().getAllCards());
  }

  Future<Permission> getStoragePermission() async {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      await Permission.storage.request();
    } else if (status.isDenied) {
      await Permission.storage.request();
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
  }

  GetDialogBox(title, icon, size, message) {
    Get.defaultDialog(
        title: title,
        content: Column(
          children: [
            Padding(padding: const EdgeInsets.all(8.0), child: icon),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                message,
                style: TextStyle(
                  fontSize: size,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ],
        ),
        textCancel: 'Cancel',
        textConfirm: 'Close',
        confirmTextColor: Colors.white,
        onConfirm: () {
          Get.back();
        },
        onCancel: () {
          Get.back();
        });
  }

  GetTextField() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: PinPut(
        fieldsCount: 4,
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
      ),
    );
  }

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Colors.blueAccent),
      borderRadius: BorderRadius.circular(15.0),
    );
  }
}
