import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:password_manager/contoller/authentication_controller.dart';
import 'package:password_manager/lifecycle_manager.dart';
import 'package:password_manager/utils/databasehelper.dart';
import 'package:password_manager/utils/encryption.dart';
import 'package:password_manager/utils/fingerprint_auth.dart';
import 'package:password_manager/utils/pairs.dart';
import 'package:password_manager/utils/snack_bar.dart';
import 'package:password_manager/view/auth/authenticate.dart';
import 'package:password_manager/view/dashboard.dart';
import 'package:password_manager/widgets.dart';

class AccountDetails extends StatelessWidget {
  final int _id;
  AccountDetails(this._id);
  final _textEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FingerprintAuth _auth = FingerprintAuth();
  final DatabaseHelper _helper = DatabaseHelper();
  String _extra = '';
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return GetBuilder<AuthController>(builder: (controller) {
      return controller.isAuthenticate == false
          ? Authenticate()
          : Scaffold(
              body: SafeArea(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: FutureBuilder(
                    future: _helper.getAccountById(_id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      _extra = snapshot.data['extra'];
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: height * 0.020,
                                top: height * 0.035,
                                bottom: height * 0.035,
                                right: height * 0.020),
                            child: ListTile(
                              leading: FadeInImage(
                                image: NetworkImage(snapshot.data['image']),
                                placeholder:
                                    AssetImage("assets/images/loading.png"),
                                height: height * 0.050,
                                imageErrorBuilder:
                                    (context, error, stacktrace) {
                                  return Icon(
                                    Icons.language,
                                    color: Colors.black54,
                                    size: height * 0.035,
                                  );
                                },
                              ),
                              title: Text(
                                snapshot.data['bank'],
                                style: Theme.of(context).textTheme.headline4,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Divider(
                            height: 1,
                            color: Colors.black54,
                          ),
                          GetListTile(
                              height,
                              'Bank Name',
                              snapshot.data['bank'],
                              Icon(Icons.account_balance),
                              context),
                          GetListTile(height, 'Bank URL', snapshot.data['url'],
                              Icon(Icons.language_outlined), context),
                          GetListTile(
                              height,
                              'Account Number',
                              Encryption.decryptText(
                                  snapshot.data['accountNumber']),
                              Icon(Icons.account_balance_outlined),
                              context),
                          GetListTile(
                              height,
                              'IFSC Code',
                              snapshot.data['ifsc'],
                              Icon(Icons.credit_card),
                              context),
                          GetListTile(
                              height,
                              'Account Holder Name',
                              snapshot.data['name'],
                              Icon(Icons.account_circle),
                              context),
                          GetListTile(
                              height,
                              'Phone Number',
                              snapshot.data['phoneNumber'],
                              Icon(Icons.call),
                              context),
                          ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount:
                                  snapshot.data['extra'].split(';').length - 1,
                              itemBuilder: (context, index) {
                                var arr = snapshot.data['extra'].split(';');
                                var t = arr[index].split(':').first;
                                var s = arr[index].split(':').last;
                                return GetListTile(
                                    height, t, s, Icon(Icons.info), context);
                              }),
                          Center(
                            child: ElevatedButton.icon(
                                onPressed: () {
                                  addNewField();
                                },
                                icon:
                                    Icon(Icons.plus_one, size: height * 0.016),
                                label: Text('Add new field')),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Center(
                              child: Text(
                                'Long Press to Copy to Clipboard',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: height * 0.016,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Center(
                              child: Text(
                                'Double Tap to See Hidden Details',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: height * 0.016,
                                ),
                              ),
                            ),
                          )
                        ],
                      );
                    },
                  ),
                ),
              ),
              bottomNavigationBar: BottomAppBar(
                color: Colors.transparent,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: width - 100,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.red)),
                          onPressed: () async {
                            LifecycleManager.decider = false;
                            if (await _auth.authenticateFingerprint()) {
                              Get.defaultDialog(
                                  title: 'Delete Credential',
                                  content: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.blue,
                                          size: height * 0.045,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'Do your really want to Delete ? ',
                                          style: TextStyle(
                                            fontSize: height * 0.019,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  textCancel: 'No',
                                  textConfirm: 'Yes',
                                  confirmTextColor: Colors.white,
                                  onConfirm: () {
                                    try {
                                      deleteCard(_id);
                                      Get.offAll(() => Dashboard(),
                                          transition: Transition.rightToLeft);
                                    } catch (e) {
                                      Get.back();
                                      MySnackBar.getSnackBar(
                                          'Failed', 'Unable to delete it');
                                    }
                                  },
                                  onCancel: () {});
                            }
                            LifecycleManager.decider = true;
                          },
                          child: Text(
                            'Delete',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                elevation: 0,
              ),
            );
    });
  }

  Widget GetListTile(height, title, subtitle, icon, BuildContext context) {
    return InkWell(
      onDoubleTap: () async {
        GetDialogBox(title, subtitle);
      },
      onLongPress: () async {
        Clipboard.setData(new ClipboardData(text: subtitle));
        MySnackBar.getSnackBar('Copied', '$title Copied to Keyboard');
      },
      child: ListTile(
        leading: icon,
        title: Text(
          title,
          style: TextStyle(
            color: Colors.black87,
            fontSize: height * 0.022,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: Colors.black87,
            fontSize: height * 0.0160,
            fontWeight: FontWeight.w300,
          ),
        ),
        trailing: IconButton(
          onPressed: () async {
            LifecycleManager.decider = false;
            if (await _auth.authenticateFingerprint()) {
              _textEditingController.text = subtitle;
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
                      DatabaseHelper helper = DatabaseHelper();
                      if (title == 'Bank Name') {
                        await helper.updateAccountBankName(
                            _id, _textEditingController.text.trim());
                        Get.back();
                        MySnackBar.getSnackBar(
                            'Success', '$title updated successfully.');
                      } else if (title == 'Account Number') {
                        await helper.updateAccountNumber(
                            _id,
                            Encryption.encryptText(
                                _textEditingController.text.trim()));
                        Get.back();
                        MySnackBar.getSnackBar(
                            'Success', '$title updated successfully.');
                      } else if (title == 'IFSC Code') {
                        await helper.updateAccountNIFSC(
                            _id, _textEditingController.text.trim());
                        Get.back();
                        MySnackBar.getSnackBar(
                            'Success', '$title updated successfully.');
                      } else if (title == 'Account Holder Name') {
                        await helper.updateAccountHolderName(
                            _id, _textEditingController.text.trim());
                        Get.back();
                        MySnackBar.getSnackBar(
                            'Success', '$title updated successfully.');
                      } else if (title == 'Phone Number') {
                        await helper.updateAccountPhoneNumber(
                            _id, _textEditingController.text.trim());
                        Get.back();
                        MySnackBar.getSnackBar(
                            'Success', '$title updated successfully.');
                      } else if (title == 'Bank URL') {
                        await helper.updateAccountUrl(
                            _id, _textEditingController.text.trim());
                        Get.back();
                        MySnackBar.getSnackBar(
                            'Success', '$title updated successfully.');
                      } else {
                        await helper.updateAccountExtras(
                            _id,
                            seperateExtras(_extra, title,
                                _textEditingController.text.trim()));
                        Get.back();
                        MySnackBar.getSnackBar(
                            'Success', '$title updated successfully.');
                      }
                      _textEditingController.clear();
                    }
                  });
            }
            LifecycleManager.decider = true;
          },
          icon: Icon(
            Icons.edit,
            size: height * 0.023,
          ),
        ),
      ),
    );
  }

  deleteCard(int id) async {
    DatabaseHelper helper = new DatabaseHelper();
    helper.deleteAccount(id);
  }

  GetTextField(String title) {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: _textEditingController,
      validator: (s) {
        if (s.trim().isEmpty) {
          return 'Invalid';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: '',
        labelText: title,
      ),
    );
  }

  addNewField() {
    final titleController = TextEditingController();
    final answerController = TextEditingController();
    Get.defaultDialog(
      title: 'Add new Field',
      content: Container(
        child: Column(
          children: [
            TextFormField(
              controller: titleController,
              textCapitalization: TextCapitalization.words,
              validator: (s) {
                if (s.trim().isEmpty) {
                  return 'Invalid';
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: '',
                labelText: 'Title',
              ),
            ),
            TextFormField(
              controller: answerController,
              validator: (s) {
                if (s.trim().isEmpty) {
                  return 'Invalid';
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: '',
                labelText: 'Answer',
              ),
            ),
            SizedBox(height: 13),
            ElevatedButton(
                onPressed: () {
                  try {
                    String ex = _extra;
                    ex += titleController.text.trim() +
                        ":" +
                        answerController.text.trim() +
                        ";";
                    DatabaseHelper helper = DatabaseHelper();
                    helper.updateAccountExtras(_id, ex);
                    Get.back();
                    MySnackBar.getSnackBar(
                        'Added', 'Field added successfully.');
                  } catch (e) {
                    Get.back();
                    MySnackBar.getSnackBar('Failed', e.toString());
                  }
                },
                child: Text('Save')),
          ],
        ),
      ),
    );
  }
}
