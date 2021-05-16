import 'package:get/get.dart';

class AuthController extends GetxController{
  bool isAuthenticate=false;
  void updateAuthStatus(){
    isAuthenticate=!isAuthenticate;
    update();
  }
}