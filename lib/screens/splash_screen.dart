import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});


  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      context.go("/onboard");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.tealAccent,
      child: Container(
        child: Image.asset("assets/logo.png"),
      ),
    );
  }
}