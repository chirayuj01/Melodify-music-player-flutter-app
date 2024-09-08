import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:moodhub/Core/Configs/Theme/App_colors.dart';
import 'package:moodhub/presentation/root/pages/root.dart';
import '../../intro/pages/GetStarted.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  double opacity = 0.0;
  double scale = 0.8;
  bool showShadow = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();


    Timer(Duration(milliseconds: 100), () {
      setState(() {
        opacity = 1.0;
        scale = 1.0;
      });
    });


    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _controller.addListener(() {
      setState(() {
        showShadow = _controller.value > 0.5;
      });
    });


    Timer(Duration(milliseconds: 400), () {
      _controller.repeat(reverse: true);
    });


    Timer(Duration(seconds: 6), () async {
      _controller.stop();

      final User? user = FirebaseAuth.instance.currentUser;
      final route = user != null
          ? MaterialPageRoute(
        builder: (context) => RootPage(user.email!),
      )
          : MaterialPageRoute(
        builder: (context) => GetStartedPage(),
      );

      Navigator.pushReplacement(context, route);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedOpacity(
          opacity: opacity,
          duration: Duration(seconds: 3),
          curve: Curves.bounceInOut,
          child: AnimatedScale(
            scale: scale,
            duration: Duration(seconds: 2),
            curve: Curves.easeInOutBack,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo_melodify.png',
                  height: 70,
                  width: 60,
                  color: App_Colors.primary,
                ),
                SizedBox(width: 10),
                Text(
                  'Melodify',
                  style: TextStyle(
                    color: App_Colors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 45,
                    decoration: TextDecoration.none,
                    shadows: showShadow
                        ? [
                      BoxShadow(
                        color: App_Colors.primary.withOpacity(0.8),
                        blurRadius: 20,
                        spreadRadius: 5,
                      )
                    ]
                        : [],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
