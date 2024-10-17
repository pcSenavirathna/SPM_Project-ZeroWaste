import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatelessWidget {
  final Color primaryGreen = const Color(0xFF069349);

  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return OnBoardingSlider(
      finishButtonText: 'Register',
      onFinish: () {
        context.go("/user/register");
      },
      finishButtonStyle: FinishButtonStyle(
        backgroundColor: primaryGreen,
      ),
      skipTextButton: Text(
        'Skip',
        style: TextStyle(
          fontSize: 16,
          color: primaryGreen,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: Text(
        'Login',
        style: TextStyle(
          fontSize: 16,
          color: primaryGreen,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailingFunction: () {
        context.go("/user/login");
      },
      controllerColor: primaryGreen,
      totalPage: 3,
      headerBackgroundColor: Colors.white,
      pageBackgroundColor: Colors.white,
      background: [
        Image.asset(
          'assets/logo.png',
          height: screenHeight * 0.3,
          width: screenWidth * 0.8,
          fit: BoxFit.contain,
        ),
        Image.asset(
          'assets/logo.png',
          height: screenHeight * 0.3,
          width: screenWidth * 0.8,
          fit: BoxFit.contain,
        ),
        Image.asset(
          'assets/logo.png',
          height: screenHeight * 0.3,
          width: screenWidth * 0.8,
          fit: BoxFit.contain,
        ),
      ],
      speed: 1.8,
      pageBodies: [
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 380,
              ),
              Text(
                'Keep Your City Clean, One Tap at a Time!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: primaryGreen,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Discover smart waste disposal with real-time tracking and optimized routes.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black26,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 380,
              ),
              Text(
                'Track Your Waste, Contribute to a Greener Future!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: primaryGreen,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Monitor your waste production and get personalized collection schedules.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black26,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 380,
              ),
              Text(
                'Join the Eco-Friendly Movement Today!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: primaryGreen,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Earn rewards for responsible waste management and help us recycle more efficiently',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black26,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
