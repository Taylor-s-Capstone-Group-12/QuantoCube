import 'package:flutter/material.dart';

class PasswordSetupPage extends StatelessWidget {
  const PasswordSetupPage({
    super.key,
    required this.signUpData,
  });

  final Map<String, String> signUpData;

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
                  'Create a Password',
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
              child: SignUpBox(
                signUpData: signUpData,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SignUpBox extends StatelessWidget {
  const SignUpBox({
    super.key,
    required this.signUpData,
  });

  final Map<String, String> signUpData;

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
      child: SignUpContent(signUpData: signUpData),
    );
  }
}

class SignUpContent extends StatefulWidget {
  const SignUpContent({
    super.key,
    required this.signUpData,
  });

  final Map<String, String> signUpData;

  @override
  State<SignUpContent> createState() => _SignUpContentState();
}

class _SignUpContentState extends State<SignUpContent> {
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  late bool isValid;

  @override
  void initState() {
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    passwordController.addListener(_onTextChanged);
    confirmPasswordController.addListener(_onTextChanged);
    isValid = false;
    super.initState();
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
  }

  void passwordValidator() {
    // TODO: Implement sign up logic here
  }

  void onContinue() {
    // TODO: Implement sign up logic here
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextInputBox(
          controller: passwordController,
          hintText: 'Password',
          obscureText: true,
        ),
        const SizedBox(height: 20),
        TextInputBox(
          controller: confirmPasswordController,
          hintText: 'Confirm Password',
          textInputAction: TextInputAction.done,
          obscureText: true,
        ),
        const SizedBox(height: 20),
        SignUpButton(onPressed: isValid ? onContinue : null),
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
