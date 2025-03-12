import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quantocube/components/buttons/large_orange_button.dart';
import 'package:quantocube/components/text_field.dart';
import 'package:quantocube/page/onboarding/welcome_page.dart';
import 'package:quantocube/tests/test_func.dart';
import 'package:quantocube/utils/geocoding_service.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';

final FirebaseFirestore _firestore =
    FirebaseFirestore.instance; // Initialize Firestore

class SignUpAddressPage extends StatefulWidget {
  const SignUpAddressPage({
    super.key,
    required this.signUpData,
  });

  final Map<String, String> signUpData;

  @override
  State<SignUpAddressPage> createState() => _SignUpAddressPageState();
}

class _SignUpAddressPageState extends State<SignUpAddressPage> {
  bool isLoading = false;

  void loadingState(bool state) {
    setState(() {
      isLoading = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                children: [
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 35),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Add Address',
                        style: TextStyle(
                          fontSize: 30,
                          height: 1.2,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  AddressBox(
                    signUpData: widget.signUpData,
                    loadingState: loadingState,
                  ),
                ],
              ),
            ),
          ),
          if (isLoading) const LoadingScreen(),
        ],
      ),
    );
  }
}

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withAlpha(100),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

class AddressBox extends StatelessWidget {
  const AddressBox({
    super.key,
    required this.signUpData,
    required this.loadingState,
  });

  final Map<String, String> signUpData;
  final Function(bool) loadingState;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 45),
      child: SignUpAddressContent(
          signUpData: signUpData, loadingState: loadingState),
    );
  }
}

class SignUpAddressContent extends StatefulWidget {
  const SignUpAddressContent({
    super.key,
    required this.signUpData,
    required this.loadingState,
  });

  final Map<String, String> signUpData;
  final Function(bool) loadingState;

  @override
  State<SignUpAddressContent> createState() => _SignUpAddressContentState();
}

class _SignUpAddressContentState extends State<SignUpAddressContent> {
  // hash map to store address data
  final Map<String, String> _addressData = {
    'phoneNumber': '',
    'houseNumber': '',
    'streetAddress': '',
    'city': '',
    'state': '',
    'zipCode': '',
  };

  final Map<String, String> fieldTexts = {
    'Phone Number': 'e.g. (0123456789)',
    'Apartment/Suite/Unit': 'e.g. (A-1-1)',
    'Street Address': 'e.g. (Jalan SS 2/75)',
    'City': 'e.g. (Petaling Jaya)',
    'State': 'e.g. (Selangor)',
    'ZIP Code': 'e.g. (43000)',
  };

  final List<TextEditingController> _controllers = [];
  late bool _isValid;

  /// Initialize the controllers based on the length of the [_addressData] keys
  /// Additionally, set the [_isValid] flag to false
  @override
  void initState() {
    // Create a controller for each field in the address data, and add a listener
    // to validate the form.
    for (int index = 0; index < _addressData.keys.length; index++) {
      final textController = TextEditingController();
      textController.addListener(formListener);
      _controllers.add(textController);
    }

    _isValid = false;

    super.initState();
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void formListener() {
    setState(() {
      for (final controller in _controllers) {
        if (controller.text.isEmpty) {
          _isValid = false;
          return;
        }
      }
      _isValid = true;
    });
  }

  String camelToTitle(String text) {
    return text[0].toUpperCase() +
        text.substring(1).splitMapJoin(
              RegExp(r'([A-Z])'),
              onMatch: (m) => ' ${m.group(0)}',
              onNonMatch: (n) => n,
            );
  }

  void onContinue() async {
    if (_isValid) {
      try {
        widget.loadingState(true);
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: widget.signUpData['email']!,
          password: widget.signUpData['password']!,
        );

        reviewMap(widget.signUpData);

        String formattedAddress = [
          _addressData['houseNumber'],
          _addressData['streetAddress'],
          _addressData['city'],
          _addressData['zipCode'],
          _addressData['state']
        ].where((e) => e != null && e.isNotEmpty).join(', ');

        // Get coordinates from the address
        var coords =
            await GeocodingService.getCoordinatesFromAddress(formattedAddress);

        GeoFirePoint? geoFirePoint;
        if (coords != null) {
          geoFirePoint =
              GeoFirePoint(GeoPoint(coords['latitude'], coords['longitude']));
        } else {
          print('Could not get coordinates'); // Handle geocoding failure
        }

        // Ensure user is not null before storing in Firestore
        if (userCredential.user != null) {
          await _firestore
              .collection("users")
              .doc(userCredential.user!.uid)
              .set({
            "name": widget.signUpData['name'],
            "email": widget.signUpData['email'],
            "createdAt": FieldValue.serverTimestamp(),
            "isHomeowner": widget.signUpData['isHomeowner'] == 'true',
            "address": _addressData,
            if (geoFirePoint != null)
              "geo": geoFirePoint.data, // Store geolocation if available
          }, SetOptions(merge: true)); // Merge to avoid overwriting data
        }

        // If successful, navigate to the Welcome Page
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            CupertinoPageRoute(
              builder: (context) => WelcomePage(
                name: widget.signUpData['name'] ?? 'User',
              ),
            ),
            (Route<dynamic> route) => false,
          );
        }
      } on FirebaseAuthException catch (e) {
        widget.loadingState(false);
        String errorMessage = "An error occurred";
        if (e.code == 'email-already-in-use') {
          errorMessage = "This email is already in use.";
        } else if (e.code == 'weak-password') {
          errorMessage = "The password is too weak.";
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: List.generate(
            _addressData.keys.length,
            (index) {
              final String hintText = fieldTexts.keys.elementAt(index);

              return TextInputSection(
                titleText: hintText,
                child: TextInputBox(
                  controller: _controllers[index],
                  keyboardType: ['phone number', 'zip code']
                          .contains(hintText.toLowerCase())
                      ? TextInputType.phone
                      : TextInputType.text,
                  hintText: fieldTexts[hintText] ?? '',
                  textInputAction: index == _addressData.keys.length - 1
                      ? TextInputAction.done
                      : TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid $hintText';
                    } else {
                      return null;
                    }
                  },
                  autovalidateMode: AutovalidateMode.onUnfocus,
                  onChanged: (value) {
                    _addressData[_addressData.keys.elementAt(index)] = value;
                  },
                ),
              );
            },
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        LargeOrangeButton.onlyText(
          context,
          onPressed: _isValid ? onContinue : null,
          text: 'Continue',
        ),
        const SizedBox(
          height: 20,
        )
      ],
    );
  }
}

class TextInputSection extends StatelessWidget {
  const TextInputSection({
    super.key,
    required this.titleText,
    required this.child,
  });

  final String titleText;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titleText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          child,
        ],
      ),
    );
  }
}
