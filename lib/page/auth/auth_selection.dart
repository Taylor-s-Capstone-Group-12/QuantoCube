import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quantocube/page/auth/login_page.dart';
import 'package:quantocube/page/Homeowner/homeowner_homepage.dart';

class AuthSelection extends StatelessWidget {
  const AuthSelection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "you are..?",
                style: TextStyle(
                  fontSize: 40,
                  height: 1.2,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 30),
            _buildSelectionButtons(context),
            _buildLoginText(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildRoleButton(context, "Homeowner", "assets/mascot/homeowner.png", const LoginPage()),
        const SizedBox(width: 20),
        _buildRoleButton(context, "Contractor", "assets/mascot/contractor.png", const LoginPage()),
      ],
    );
  }

  Widget _buildRoleButton(BuildContext context, String role, String imgURL, Widget nextPage) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, CupertinoPageRoute(builder: (context) => nextPage));
      },
      child: Container(
        width: 157,
        height: 181,
        decoration: BoxDecoration(
          color: const Color(0xff1C1C1D),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Image.asset(
                imgURL,
                fit: BoxFit.fitHeight,
              ),
            ),
            Text(
              role,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginText(BuildContext context) {
    return Column(
      children: [
        const Text(
          "I already have an account.",
          style: TextStyle(color: Colors.white),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (_) => const LoginPage()),
            );
          },
          child: Text(
            "Log In",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
