import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quantocube/page/auth/signup/name_setup_page.dart';
import 'package:quantocube/page/auth/signup/password_setup_page.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({
    super.key,
    required this.isHomeowner,
  });

  final bool isHomeowner;

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
                  'Sign Up',
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
              child: SignUpBox(),
            ),
          ],
        ),
      ),
    );
  }
}

class SignUpBox extends StatelessWidget {
  const SignUpBox({super.key});

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
      child: const SignUpContent(),
    );
  }
}

class SignUpContent extends StatefulWidget {
  const SignUpContent({super.key});

  @override
  State<SignUpContent> createState() => _SignUpContentState();
}

class _SignUpContentState extends State<SignUpContent> {
  late TextEditingController emailController;
  late bool receiveNewsletters;

  Map<String, String> signUpData = {
    'email': '',
    'name': '',
    'password': '',
    'receiveNewsletters': 'true',
  };

  @override
  void initState() {
    emailController = TextEditingController();
    emailController.addListener(_onTextChanged);
    receiveNewsletters = true;
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      signUpData['email'] = emailController.text;
    });
  }

  void onSignUpPressed() {
    // TODO: Implement sign up logic
    print('Test');
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (_) => NameSetupPage(
          signUpData: signUpData,
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
          textInputAction: TextInputAction.done,
        ),
        const SizedBox(height: 20),
        SignUpButton(
            onPressed: emailController.text == '' ? null : onSignUpPressed),
        const SizedBox(height: 20),
        MarketingCheckbox(
          receiveNewsletters: receiveNewsletters,
          onChange: () {
            setState(() {
              receiveNewsletters = !receiveNewsletters;
              if (receiveNewsletters) {
                signUpData['receiveNewsletters'] = 'true';
              } else {
                signUpData['receiveNewsletters'] = 'false';
              }
            });
          },
        ),
      ],
    );
  }
}

class TextInputBox extends StatelessWidget {
  const TextInputBox({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false, // default to false
    this.textInputAction = TextInputAction.next, // default to next
    this.suffixIcon,
  });

  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final TextInputAction textInputAction;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: TextFormField(
        textInputAction: textInputAction,
        controller: controller,
        decoration: InputDecoration(
          //contentPadding: const EdgeInsets.all(20),
          isDense: false,
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.white,
          ),
          filled: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          fillColor: Theme.of(context).colorScheme.surface,
          border: OutlineInputBorder(
            borderSide: BorderSide.none, // No outline when not focused
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context)
                  .colorScheme
                  .primary, // Primary color outline when focused
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

class SignUpButton extends StatelessWidget {
  const SignUpButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback? onPressed;

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
          'Continue',
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

class MarketingCheckbox extends StatelessWidget {
  const MarketingCheckbox({
    super.key,
    required this.receiveNewsletters,
    required this.onChange,
  });

  final bool receiveNewsletters;
  final VoidCallback onChange;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: receiveNewsletters,
          onChanged: (value) {
            onChange();
          },
          activeColor: Theme.of(context).colorScheme.primary,
          checkColor:
              receiveNewsletters ? Colors.white : const Color(0xFF979797),
        ),
        const Text(
          'I want to receive the latest news, updates, and\nexclusive offers from QuantoCube!',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF979797),
          ),
        ),
      ],
    );
  }
}
