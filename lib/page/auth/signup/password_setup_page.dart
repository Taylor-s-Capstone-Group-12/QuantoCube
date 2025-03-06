import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quantocube/page/onboarding/welcome_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';


final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Initialize Firestore

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

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    isValid = false;
    super.initState();
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  // navigate to the welcome page if the password is acceptable.

  void onContinue() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: widget.signUpData['email']!,
          password: passwordController.text,
        );

        // Generate UUID
        var uuid = Uuid();
        String userId = uuid.v4();

        // Store UUID & other data in Firestore
        await _firestore.collection("users").doc(userCredential.user!.uid).set({
          "uuid": userId,
          "name": widget.signUpData['name'],
          "email": widget.signUpData['email'],
          "createdAt": FieldValue.serverTimestamp(),
        });

        // If successful, navigate to the Welcome Page
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => WelcomePage(
              name: widget.signUpData['name'] ?? 'User',
            ),
          ),
        );
      } on FirebaseAuthException catch (e) {
        String errorMessage = "An error occurred";
        if (e.code == 'email-already-in-use') {
          errorMessage = "This email is already in use.";
        } else if (e.code == 'weak-password') {
          errorMessage = "The password is too weak.";
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    }
  }

  // function to update the validation flag
  void setValidation(bool status) {
    setState(() {
      isValid = status;
    });
  }

  // function to validate the password
  bool passwordValidator() {
    // TODO: Implement password validation
    return true;
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
            obscureText: true,
          ),
          const SizedBox(height: 20),
          TextInputBox(
            controller: confirmPasswordController,
            hintText: 'Confirm Password',
            textInputAction: TextInputAction.done,
            obscureText: true,
            validator: (value) {
              final bool validate = confirmPasswordValidator();
              if (validate) {
                return null;
              } else {
                return 'Password does not match';
              }
            },
            onFieldSubmitted: (value) {
              setState(() {
                if (_formKey.currentState!.validate()) {
                  isValid = true;
                } else {
                  isValid = false;
                }
              });
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
          SignUpButton(onPressed: isValid ? onContinue : null),
        ],
      ),
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
    this.validator,
    this.onFieldSubmitted,
    this.onChanged,
  });

  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final TextInputAction textInputAction;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onFieldSubmitted;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
            const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
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
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      obscureText: obscureText,
      validator: validator,
      onFieldSubmitted: onFieldSubmitted,
      onChanged: onChanged,
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
