import 'dart:io';
import 'dart:math';
import 'package:get/get.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:password_manager/utils/databasehelper.dart';
import 'package:password_manager/view/auth/forgot.dart';

class Mail {
  static void forgotPassword(controller) async {
    Random random = new Random();
    int randomNumber = random.nextInt(9000);
    randomNumber += 1000;
    try {
      DatabaseHelper helper = DatabaseHelper();
      var result = await helper.fetchUsers();
      sendPasswordResetMail(result[0]['email'], randomNumber, controller);
    } catch (e) {
      controller.updateLoading();
      Get.snackbar('Failed', 'Unable to send PIN');
    }
  }

  static checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    } catch (e) {
      return false;
    }
  }

  static void sendPasswordResetMail(String email, int pin, controller) async {
    final String username = 'gusfringe.lospollos@gmail.com';
    final String password = 'Nanjibhai@69';

    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username, 'Password Manager')
      ..recipients.add(email)
      ..subject = 'Reset Password'
      ..html = generateEmailHTML(pin);

    try {
      Get.offAll(Forgot(pin.toString()), transition: Transition.rightToLeft);
      final sendReport = await send(message, smtpServer);
      controller.updateLoading();
    } on MailerException catch (e) {
      controller.updateLoading();
      Get.snackbar('Email Send Faied', e.toString());
    }
  }

  static String generateEmailHTML(int pin) {
    return '''
<!doctype html>
<html lang="en-US">

<head>
    <meta content="text/html; charset=utf-8" http-equiv="Content-Type" />
    <title>Reset Password Email Template</title>
    <meta name="description" content="Reset Crypthrone Password">
    <style type="text/css">
        a:hover {text-decoration: underline !important;}
    </style>
</head>

<body marginheight="0" topmargin="0" marginwidth="0" style="margin: 0px; background-color: #f2f3f8;" leftmargin="0">
    <!--100% body table-->
    <table cellspacing="0" border="0" cellpadding="0" width="100%" bgcolor="#f2f3f8"
        style="@import url(https://fonts.googleapis.com/css?family=Rubik:300,400,500,700|Open+Sans:300,400,600,700); font-family: 'Open Sans', sans-serif;">
        <tr>
            <td>
                <table style="background-color: #f2f3f8; max-width:670px;  margin:0 auto;" width="100%" border="0"
                    align="center" cellpadding="0" cellspacing="0">
                    <tr>
                        <td style="height:80px;">&nbsp;</td>
                    </tr>
                   
                    <tr>
                        <td style="height:20px;">&nbsp;</td>
                    </tr>
                    <tr>
                        <td>
                            <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0"
                                style="max-width:670px;background:#fff; border-radius:3px; text-align:center;-webkit-box-shadow:0 6px 18px 0 rgba(0,0,0,.06);-moz-box-shadow:0 6px 18px 0 rgba(0,0,0,.06);box-shadow:0 6px 18px 0 rgba(0,0,0,.06);">
                                <tr>
                                    <td style="height:40px;">&nbsp;</td>
                                </tr>
                                <tr>
                                    <td style="padding:0 35px;">
                                        <h1 style="color:#1e1e2d; font-weight:500; margin:0;font-size:32px;font-family:'Rubik',sans-serif;">You have
                                            requested to reset your password</h1>
                                        <span
                                            style="display:inline-block; vertical-align:middle; margin:29px 0 26px; border-bottom:1px solid #cecece; width:100px;"></span>
                                        <p style="color:#455056; font-size:15px;line-height:24px; margin:0;">
                                            We cannot simply send you your old pin. A unique pin to reset your
                                            pin has been generated for you. To reset your password, use following pin.nn
                                        
                                        </p>
                                        <p>
                                          <b>Pin : </b> $pin
                                        </p>
                                       
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height:40px;">&nbsp;</td>
                                </tr>
                            </table>
                        </td>
                    <tr>
                        <td style="height:20px;">&nbsp;</td>
                    </tr>
                   
                    <tr>
                        <td style="height:80px;">&nbsp;</td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    <!--/100% body table-->
</body>

</html>
      ''';
  }
}
