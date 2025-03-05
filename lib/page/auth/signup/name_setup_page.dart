import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quantocube/page/auth/signup/password_setup_page.dart';

class NameSetupPage extends StatelessWidget {
  const NameSetupPage({super.key, required this.signUpData});

  final Map<String, String> signUpData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          top: 129.0,
          left: 30.0,
          right: 30.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              'Welcome to QuantoCube',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w600,
                height: 1.5,
              ),
            ),
            Expanded(child: NameEntryBox(signUpData: signUpData)),
          ],
        ),
      ),
    );
  }
}

class NameEntryBox extends StatefulWidget {
  const NameEntryBox({
    super.key,
    required this.signUpData,
  });

  final Map<String, String> signUpData;

  @override
  State<NameEntryBox> createState() => _NameEntryBoxState();
}

class _NameEntryBoxState extends State<NameEntryBox> {
  late TextEditingController nameController;
  bool isValid = false;

  @override
  void initState() {
    nameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void nameValidator(String name) {}

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          NameEntryForm(
            controller: nameController,
            signUpData: widget.signUpData,
            onChanged: (value) {
              if (value.isNotEmpty) {
                setState(() {
                  isValid = true;
                  widget.signUpData['name'] = value;
                });
              } else {
                setState(() {
                  isValid = false;
                });
              }
            },
          ),
          Button(
              onPressed: isValid
                  ? () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) =>
                              PasswordSetupPage(signUpData: widget.signUpData),
                        ),
                      );
                    }
                  : null),
        ],
      ),
    );
  }
}

class NameEntryForm extends StatefulWidget {
  const NameEntryForm({
    super.key,
    required this.signUpData,
    required this.onChanged,
    required this.controller,
  });

  final Map<String, String> signUpData;
  final TextEditingController controller;
  final void Function(String) onChanged;

  @override
  State<NameEntryForm> createState() => _NameEntryFormState();
}

class _NameEntryFormState extends State<NameEntryForm> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      style: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.w600,
        fontSize: 40,
      ),
      textAlign: TextAlign.center,
      maxLines: null,
      decoration: InputDecoration(
        hintText: 'Enter your preferred name',
        hintStyle: TextStyle(
          color: Colors.white.withAlpha(100),
          fontWeight: FontWeight.w600,
          fontSize: 30,
        ),
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        border: InputBorder.none,
      ),
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.done,
      onChanged: widget.onChanged,
    );
  }
}

class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.onPressed,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50.0),
      child: SizedBox(
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
            'Confirm',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
