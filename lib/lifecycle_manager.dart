import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_manager/contoller/authentication_controller.dart';
import 'package:password_manager/contoller/dashboard_controller.dart';
import 'package:password_manager/contoller/date_controller.dart';
import 'package:password_manager/contoller/date_controller2.dart';
import 'package:password_manager/contoller/hideshowpassword_controller.dart';
import 'package:password_manager/contoller/loading_controller.dart';
import 'package:password_manager/contoller/random_password.dart';
import 'package:password_manager/contoller/search_controller.dart';
import 'package:password_manager/contoller/url_controller.dart';

import 'contoller/add_form_controller.dart';

class LifecycleManager extends StatefulWidget {
  final Widget child;
  static bool decider = true;

  static final TextEditingController pinController =
      new TextEditingController();
  static final FocusNode pinFocusNode = new FocusNode();
  final AuthController authController = Get.put(AuthController());
  static int status = 0;
  final HideShowPassword _hideshowpassword = Get.put(HideShowPassword());
  final DateController _dateController = Get.put(DateController());
  final DateController2 _dateController2 = Get.put(DateController2());
  final LoadingController _loadingController = Get.put(LoadingController());
  final URLContoller _urlContoller = Get.put(URLContoller());
  final RandomPassword _randomPassword = Get.put(RandomPassword());
  DashboardController _dashboardController = Get.put(DashboardController());
  final SearchController _searchController = Get.put(SearchController());
  final AddFormController addFormController = Get.put(AddFormController());
  static LifecycleManager lifeCycleManager = LifecycleManager();
  LifecycleManager({Key key, this.child}) : super(key: key);
  @override
  _LifecycleManagerState createState() => _LifecycleManagerState();
}

class _LifecycleManagerState extends State<LifecycleManager>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    LifecycleManager.lifeCycleManager.addFormController.clearAll();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (LifecycleManager.decider == true && state == AppLifecycleState.paused) {
      if (widget.authController.isAuthenticate == true)
        widget.authController.updateAuthStatus();

      LifecycleManager.status = 0;
      LifecycleManager.decider == true;
      LifecycleManager.pinController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
