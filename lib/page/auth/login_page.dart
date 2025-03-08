import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quantocube/components/button.dart';
import 'package:quantocube/components/text_field.dart';
import 'package:quantocube/page/auth/signup/signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.only(top: 100.0),
        child: Column(
          children: [
            Padding(
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
      child: const LoginBoxContent(),
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

  void onLogin(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password')),
      );
      return;
    }

    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Navigate to the homeowner screen on successful login
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamed(context, '/homeowner');
      });
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An error occurred. Please try again.';

      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided for that user.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
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
        LargeOrangeButton.onlyText(
          context,
          text: 'Log In',
          onPressed: () =>
              onLogin(emailController.text, passwordController.text),
        ),
        const SizedBox(height: 20),
        AdditionalButtons(
            onForgetPassword: onForgetPassword, onSignUp: onSignUp)
      ],
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
