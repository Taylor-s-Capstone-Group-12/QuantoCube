import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:quantocube/components/buttons/large_orange_button.dart';
import 'package:quantocube/components/widgets/text_field.dart';
import 'package:quantocube/page/auth/signup/signup_address_page.dart';
import 'package:quantocube/page/onboarding/welcome_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

final FirebaseFirestore _firestore =
    FirebaseFirestore.instance; // Initialize Firestore

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
              child: PasswordBox(
                signUpData: signUpData,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PasswordBox extends StatelessWidget {
  const PasswordBox({
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

  late bool isPasswordValid;

  late bool isFormValid;

  final _formKey = GlobalKey<FormState>();

  bool passwordObscure = true;

  @override
  void initState() {
    passwordController = TextEditingController();

    confirmPasswordController = TextEditingController();

    isFormValid = false;

    isPasswordValid = false;

    super.initState();
  }

  @override
  void dispose() {
    passwordController.dispose();

    confirmPasswordController.dispose();

    super.dispose();
  }

  // navigate to the welcome page if the password is acceptable.
  void onContinue() {
    if (isFormValid) {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => SignUpAddressPage(
            signUpData: widget.signUpData,
          ),
        ),
      );
    }
  }

  // function to update the validation flag

  void setValidation(bool status) {
    setState(() {
      isFormValid = status;
    });
  }

  // function to validate the password

  bool passwordValidator(String password) {
    // check if the password is at least 8 characters long,

    // contains at least one uppercase letter,

    // one lowercase letter, one number,

    // and one special character

    if (password.isEmpty) {
      setValidation(false);

      return true;
    }

    final RegExp regex = RegExp(
        r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,4096}$');

    return regex.hasMatch(password);
  }

  // function to validate the confirm password

  bool confirmPasswordValidator() {
    if (passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      setValidation(false);

      return false;
    } else if (passwordController.text != confirmPasswordController.text) {
      setValidation(false);

      return false;
    } else {
      setValidation(true);

      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: AutovalidateMode.onUnfocus,
      key: _formKey,
      child: Column(
        children: [
          TextInputBox(
            controller: passwordController,
            hintText: 'Password',
            obscureText: passwordObscure,
            validator: (value) {
              final bool validate = passwordValidator(value ?? '');

              if (validate) {
                return null;
              } else {
                return '• Password must be at least 8 characters long\n• at least one uppercase letter \n• one lowercase letter,\n• one number,\n• one special character';
              }
            },
            onChanged: (value) {
              widget.signUpData['password'] = value;

              if (value.isNotEmpty) {
                passwordValidator(value)
                    ? setValidation(confirmPasswordValidator())
                    : setValidation(false);
              } else {
                setValidation(false);
              }
            },
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
          TextInputBox(
            controller: confirmPasswordController,
            hintText: 'Confirm Password',
            textInputAction: TextInputAction.done,
            obscureText: true,
            validator: (value) {
              final bool validate = confirmPasswordValidator();

              if (value == null || value.isEmpty) {
                return null;
              }

              if (validate) {
                return null;
              } else {
                return 'Password does not match';
              }
            },
            onFieldSubmitted: (value) {
              if (_formKey.currentState!.validate()) {
                setValidation(true);
              } else {
                setValidation(false);
              }
            },
            onChanged: (value) {
              if (value.isNotEmpty && passwordController.text.isNotEmpty) {
                confirmPasswordValidator();
              } else {
                setValidation(false);
              }
            },
          ),
          const SizedBox(height: 20),
          LargeOrangeButton.onlyText(context,
              onPressed: isFormValid ? onContinue : null, text: 'Continue'),
        ],
      ),
    );
  }
}
