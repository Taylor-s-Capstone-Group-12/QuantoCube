import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
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

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: emailController,
          decoration: InputDecoration(
            hintText: 'Email',
            hintStyle: const TextStyle(
              color: Colors.white,
            ),
            filled: true,
            fillColor: Colors.black,
            border: OutlineInputBorder(
              borderSide: BorderSide.none, // No outline when not focused
              borderRadius: BorderRadius.circular(8.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context)
                    .colorScheme
                    .primary, // Primary color outline when focused
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: emailController,
          decoration: InputDecoration(
            hintText: 'Email',
            hintStyle: const TextStyle(
              color: Colors.white,
            ),
            filled: true,
            fillColor: Colors.black,
            border: OutlineInputBorder(
              borderSide: BorderSide.none, // No outline when not focused
              borderRadius: BorderRadius.circular(8.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context)
                    .colorScheme
                    .primary, // Primary color outline when focused
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        )
      ],
    );
  }
}

// GoogleFonts.golosText(
//                   fontSize: 30,
//                   height: 1.2,
//                   fontWeight: FontWeight.w600,
//                 )
