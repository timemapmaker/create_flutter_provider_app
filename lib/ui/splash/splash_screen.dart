import 'dart:async';
import 'package:flutter/material.dart';
import 'package:noteapp/routes.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Center(
                    child: Text(
                      "timemap",
                      style: TextStyle(
                        fontSize: Theme.of(context).textTheme.headline3.fontSize,
                      ),
                    )),
              ],
            )));
  }

  startTimer() {
    var duration = Duration(milliseconds: 3000);
    return Timer(duration, redirect);
  }

  redirect() async {
    Navigator.of(context).pushReplacementNamed(Routes.home);
  }
}
