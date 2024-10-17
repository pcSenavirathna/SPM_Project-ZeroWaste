import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:zero_waste/models/user.dart';
import 'package:zero_waste/providers/user_provider.dart';
import 'package:zero_waste/utils/app_logger.dart';
import 'package:zero_waste/utils/validators.dart';
import 'package:zero_waste/widgets/dialog_messages.dart';
import 'package:zero_waste/widgets/submit_button.dart';
import 'package:zero_waste/widgets/text_field_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.green.shade200, Colors.blue.shade200],
        ),
      ),
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.green),
                onPressed: () {
                  context.go('/home');
                },
              ),
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(left: 120.0, bottom: 155.0),
                title: const Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                background: Image.asset(
                  'assets/garbage.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SliverToBoxAdapter(
                child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFieldInput(
                        title: "Email",
                        icon: Icons.person,
                        controller: _emailController,
                        inputType: TextInputType.emailAddress,
                        validator: Validators.validateEmail),
                    const SizedBox(height: 16),
                    TextFieldInput(
                        title: "Password",
                        icon: Icons.person,
                        controller: _passwordController,
                        inputType: TextInputType.visiblePassword,
                        validator: Validators.validatePassword),
                    const SizedBox(height: 24),
                    SubmitButton(
                        icon: Icons.send,
                        text: "Login",
                        whenPressed: _submitForm),
                    const SizedBox(height: 10),
                    RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: "Dont have an account?",
                              style: Theme.of(context).textTheme.bodyMedium),
                          TextSpan(
                              text: "Register",
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.orangeAccent),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  context.go("/user/register");
                                })
                        ]))
                  ],
                ),
              ),
            ))
          ],
        ),
      ),
    ));
  }

  void _submitForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final user = User(
        email: _emailController.text,
        password: _passwordController.text,
        userType: 'HouseholdUser',
      );
      Provider.of<UserProvider>(context, listen: false).login(user).then((_) {
        bottomMessage(context, 'Login Success!');
        context.go("/profile");
      }).catchError((error, stack) {
        okMessageDialog(context, 'Login Failed', error.toString());
      });
    }
  }
}
