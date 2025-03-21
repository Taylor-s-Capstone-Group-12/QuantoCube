import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:quantocube/components/buttons/large_orange_button.dart';
import 'package:quantocube/components/widgets/text_field.dart';
import 'package:quantocube/page/auth/signup/name_setup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

class PhoneNumberRegisterPage extends StatelessWidget {
  const PhoneNumberRegisterPage({
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
                  'Verify Your Phone Number',
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
              child: PhoneNumberBox(signUpData: signUpData),
            ),
          ],
        ),
      ),
    );
  }
}

class PhoneNumberBox extends StatelessWidget {
  const PhoneNumberBox({
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
      child: SignUpPhoneContent(signUpData: signUpData),
    );
  }
}

class SignUpPhoneContent extends StatefulWidget {
  const SignUpPhoneContent({
    super.key,
    required this.signUpData,
  });

  final Map<String, String> signUpData;

  @override
  State<SignUpPhoneContent> createState() => _SignUpPhoneContentState();
}

class _SignUpPhoneContentState extends State<SignUpPhoneContent> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late TextEditingController phoneController;
  late TextEditingController otpController;

  bool isPhoneValid = false;
  bool isOtpValid = false;
  bool otpSent = false;
  String verificationId = ''; // 🔹 Store verification ID

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    phoneController = TextEditingController();
    otpController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    phoneController.dispose();
    otpController.dispose();
    super.dispose();
  }

  // Function to validate phone number
  bool phoneValidator(String phone) {
    final RegExp regex =
        RegExp(r'^\+?[1-9]\d{7,14}$'); // Supports international format
    return regex.hasMatch(phone);
  }

  // Function to handle "Send OTP" button
  // void sendOtp() async {
  //   if (phoneValidator(phoneController.text)) {
  //     // Refresh Firebase App Check token before sending OTP

  //     await _auth.verifyPhoneNumber(
  //       phoneNumber: phoneController.text,
  //       verificationCompleted: (PhoneAuthCredential credential) {
  //         // Auto-retrieve OTP (for some devices)
  //       },
  //       verificationFailed: (FirebaseAuthException e) {
  //         setState(() {
  //           otpSent = false;
  //         });
  //         print("Verification failed: ${e.message}");
  //       },
  //       codeSent: (String verificationId, int? resendToken) {
  //         setState(() {
  //           otpSent = true;
  //         });
  //       },
  //       codeAutoRetrievalTimeout: (String verificationId) {},
  //     );
  //   } else {
  //     setState(() {
  //       isPhoneValid = false;
  //       otpSent = false;
  //     });
  //   }
  // }

  // void sendOtp() async {
  //   if (phoneValidator(phoneController.text)) {
  //     await _auth.verifyPhoneNumber(
  //       phoneNumber: phoneController.text,
  //       verificationCompleted: (PhoneAuthCredential credential) {
  //         // Auto-retrieve OTP (for some devices)
  //       },
  //       verificationFailed: (FirebaseAuthException e) {
  //         setState(() {
  //           otpSent = false;
  //         });
  //         print("Verification failed: ${e.message}");
  //       },
  //       codeSent: (String verificationId, int? resendToken) {
  //         setState(() {
  //           otpSent = true;
  //         });
  //       },
  //       codeAutoRetrievalTimeout: (String verificationId) {
  //         // Leave empty but keep this required parameter
  //       },
  //       timeout: const Duration(
  //           seconds: 120), // Extended from default 30 seconds to 120
  //     );
  //   } else {
  //     setState(() {
  //       isPhoneValid = false;
  //       otpSent = false;
  //     });
  //   }
  // }

  // Function to verify OTP
  // void verifyOtp() async {
  //   String otp = otpController.text.trim();

  //   PhoneAuthCredential credential = PhoneAuthProvider.credential(
  //     verificationId: verificationId,
  //     smsCode: otp,
  //   );

  //   try {
  //     await FirebaseAuth.instance.signInWithCredential(credential);
  //     setState(() {
  //       isOtpValid = true;
  //     });
  //   } catch (e) {
  //     print("OTP verification failed: $e");
  //     setState(() {
  //       isOtpValid = false;
  //     });
  //   }
  // }

  // void verifyOtp() async {
  //   String otp = otpController.text.trim();

  //   try {
  //     // Create the credential but don't sign in
  //     PhoneAuthCredential credential = PhoneAuthProvider.credential(
  //       verificationId: verificationId,
  //       smsCode: otp,
  //     );

  //     // Manually verify the credential without completing the sign-in
  //     // This will throw an exception if the OTP is invalid
  //     await FirebaseAuth.instance
  //         .signInWithCredential(credential)
  //         .then((userCredential) {
  //       // Immediately sign out to avoid actually logging the user in
  //       FirebaseAuth.instance.signOut();

  //       setState(() {
  //         isOtpValid = true;
  //       });

  //       // Here you can store or use the verified phone number
  //       String verifiedPhoneNumber = userCredential.user?.phoneNumber ?? "";
  //       print("Phone number verified: $verifiedPhoneNumber");
  //     });
  //   } catch (e) {
  //     print("OTP verification failed: $e");
  //     setState(() {
  //       isOtpValid = false;
  //     });
  //   }
  // }

  void sendOtp() async {
    if (phoneValidator(phoneController.text)) {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneController.text,
        verificationCompleted: (PhoneAuthCredential credential) {
          // Auto-retrieve OTP (for some devices)
        },
        verificationFailed: (FirebaseAuthException e) {
          setState(() {
            otpSent = false;
          });
          print("Verification failed: ${e.message}");
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            this.verificationId = verificationId; // 🔹 Store verification ID
            otpSent = true;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            this.verificationId =
                verificationId; // 🔹 Store verification ID even after timeout
          });
        },
        timeout: const Duration(seconds: 120),
      );
    } else {
      setState(() {
        isPhoneValid = false;
        otpSent = false;
      });
    }
  }

  void pushToNextPage() {
    if (mounted) {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (_) => NameSetupPage(
            signUpData: widget.signUpData,
          ),
        ),
      );
    }
  }

  void verifyOtp() async {
    String otp = otpController.text.trim(); // 🔹 Get OTP from text box

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, // 🔹 Use stored verificationId
        smsCode: otp,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      FirebaseAuth.instance.signOut(); // 🔹 Sign out after verification

      setState(() {
        isOtpValid = true;
      });

      print("Phone number verified: ${userCredential.user?.phoneNumber}");
    } catch (e) {
      print("OTP verification failed: $e");
      setState(() {
        isOtpValid = false;
      });
    }

    if (isOtpValid) {
      print('valid');
      // Store verified phone number
      widget.signUpData['phone'] = phoneController.text;
      pushToNextPage();
    } else {
      print('notvalid');
    }
  }

  // Function to proceed after OTP verification
  void onContinue() {
    if (isOtpValid) {
      print('valid');
      // Store verified phone number
      widget.signUpData['phone'] = phoneController.text;
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (_) => NameSetupPage(
            signUpData: widget.signUpData,
          ),
        ),
      );
    } else {
      print('notvalid');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: AutovalidateMode.onUnfocus,
      key: _formKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: TextInputBox(
                  controller: phoneController,
                  hintText: 'Phone Number',
                  keyboardType: TextInputType.phone,
                  validator: (value) => phoneValidator(value ?? '')
                      ? null
                      : 'Enter a valid phone number',
                  onChanged: (value) {
                    setState(() {
                      isPhoneValid = phoneValidator(value);
                    });
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton(
                  onPressed: isPhoneValid ? sendOtp : null, // 🔹 Call sendOtp()
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 25),
                  ),
                  child: const Text(
                    'Send',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (otpSent) // Show OTP input only after sending
            TextInputBox(
              controller: otpController,
              hintText: 'Enter OTP',
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              validator: (value) => value != null && value.length == 6
                  ? null
                  : 'Enter a valid 6-digit OTP',
              onChanged: (value) {
                setState(() {
                  isOtpValid = value.length == 6;
                });
              },
            ),
          const SizedBox(height: 20),
          LargeOrangeButton.onlyText(
            context,
            onPressed: otpSent ? verifyOtp : null, // 🔹 Call verifyOtp()
            text: 'Continue',
          ),
        ],
      ),
    );
  }
}
