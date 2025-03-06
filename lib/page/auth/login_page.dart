import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quantocube/page/auth/signup/signup_page.dart';
import 'package:quantocube/page/Homeowner/homeowner_homepage.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.only(top: 100.0),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 35),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Log In',
                  style: TextStyle(
                    fontSize: 30,
                    height: 1.2,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Expanded(
              child: LoginBox(),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginBox extends StatelessWidget {
  const LoginBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 45),
      child: LoginBoxContent(),
    );
  }
}

class LoginBoxContent extends StatefulWidget {
  const LoginBoxContent({super.key});

  @override
  State<LoginBoxContent> createState() => _LoginBoxContentState();
}

class _LoginBoxContentState extends State<LoginBoxContent> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late bool passwordObscure;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    passwordObscure = true;
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool onLogin(String email, String password) {
    // TODO: Implement login logic here
    return true;
  }

  void onForgetPassword() {
    // TODO: Implement reset password logic here
  }

  void onSignUp() {
    // TODO: Implement sign up logic here
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => const SignUpPage(
          isHomeowner: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextInputBox(
          controller: emailController,
          hintText: 'Email',
        ),
        const SizedBox(height: 20),
        TextInputBox(
          controller: passwordController,
          hintText: 'Password',
          obscureText: passwordObscure,
          textInputAction: TextInputAction.done,
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                passwordObscure = !passwordObscure;
              });
            },
            child: Icon(
              passwordObscure ? Icons.visibility : Icons.visibility_off,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 20),
        LoginButton(onPressed: (){}), // ✅ Directly calls onLogin()
      ],
    );
  }
}

class TextInputBox extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final TextInputAction textInputAction;
  final Widget? suffixIcon;

  const TextInputBox({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.textInputAction = TextInputAction.next,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: TextFormField(
        textInputAction: textInputAction,
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.white),
          filled: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          fillColor: Theme.of(context).colorScheme.surface,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          suffixIcon: suffixIcon,
        ),
        obscureText: obscureText,
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  final VoidCallback onPressed;

  const LoginButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      width: double.infinity,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: const Text(
          'Enter',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class AdditionalButtons extends StatelessWidget {
  const AdditionalButtons({
    super.key,
    required this.onForgetPassword,
    required this.onSignUp,
  });

  final VoidCallback onForgetPassword;
  final VoidCallback onSignUp;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ForgotPasswordButton(onPressed: onForgetPassword),
        SignUpButton(onPressed: onSignUp),
      ],
    );
  }
}

class ForgotPasswordButton extends StatelessWidget {
  const ForgotPasswordButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: GestureDetector(
        onTap: onPressed,
        child: Text(
          'Forgot Password',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}

class SignUpButton extends StatelessWidget {
  const SignUpButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = TextStyle(
      color: Theme.of(context).colorScheme.primary,
      fontWeight: FontWeight.w700,
      fontSize: 12,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Don\'t have an account? ',
            style: textStyle.copyWith(
              color: Colors.white,
            ),
          ),
          GestureDetector(
            onTap: onPressed,
            child: Text(
              'Sign Up',
              style: textStyle,
            ),
          ),
        ],
      ),
    );
  }
}
