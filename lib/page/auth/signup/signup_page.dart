import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quantocube/components/buttons/large_orange_button.dart';
import 'package:quantocube/components/widgets/text_field.dart';
import 'package:quantocube/page/homeowner/legal/eula_tos_page.dart';
import 'package:quantocube/page/auth/signup/name_setup_page.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({
    super.key,
    required this.isHomeowner,
  });

  final bool isHomeowner;

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
              child: SignUpBox(
                isHomeowner: isHomeowner,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SignUpBox extends StatelessWidget {
  const SignUpBox({super.key, required this.isHomeowner});

  final bool isHomeowner;

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
      child: SignUpContent(isHomeowner: isHomeowner),
    );
  }
}

class SignUpContent extends StatefulWidget {
  const SignUpContent({super.key, required this.isHomeowner});

  final bool isHomeowner;

  @override
  State<SignUpContent> createState() => _SignUpContentState();
}

class _SignUpContentState extends State<SignUpContent> {
  late TextEditingController emailController;
  late bool receiveNewsletters;

  bool isValid = false;
  bool acceptTerms = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map<String, String> signUpData = {
    'email': '',
    'name': '',
    'password': '',
    'receiveNewsletters': 'true',
    'isHomeowner': 'true',
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

  void onValidation(bool isValid) {
    print('isValid: $isValid');
    setState(() {
      if (!acceptTerms) {
        this.isValid = false;
      } else {
        this.isValid = isValid;
      }
    });
  }

  bool emailValidator(String email) {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email) || email == '';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: _formKey,
          child: TextInputBox(
            controller: emailController,
            hintText: 'Email',
            textInputAction: TextInputAction.done,
            validator: (value) {
              final bool validate = emailValidator(value ?? '');
              if (validate) {
                return null;
              } else {
                return 'Please enter a valid email address';
              }
            },
            onFieldSubmitted: (value) {
              if (_formKey.currentState!.validate() && value.isNotEmpty) {
                onValidation(true);
              } else {
                onValidation(false);
              }
            },
            onChanged: (value) {
              if (value.isNotEmpty && _formKey.currentState!.validate()) {
                onValidation(emailValidator(value));
              } else {
                onValidation(false);
              }
            },
          ),
        ),
        const SizedBox(height: 20),
        LargeOrangeButton.onlyText(context,
            text: 'Continue', onPressed: !isValid ? null : onSignUpPressed),
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
        TermsCheckbox(
          receiveNewsletters: acceptTerms,
          onChange: () {
            setState(() {
              acceptTerms = !acceptTerms;
              onValidation(emailValidator(emailController.text));
            });
          },
        ),
      ],
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

class TermsCheckbox extends StatelessWidget {
  const TermsCheckbox({
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
        Row(
          children: [
            const Text(
              'I accept the ',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF979797),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const EulaTosScreen(),
                  ),
                );
              },
              child: Text(
                'terms and conditions.',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
