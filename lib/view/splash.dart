import 'package:flutter/material.dart';
import 'package:password_manager/main.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: width,
              height: height * 0.40,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/app_logo.png',
                    height: height * 0.080,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Password Manager',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: height * 0.017,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: width,
              height: height * 0.40,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  'From Prasad',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: height * 0.018,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
