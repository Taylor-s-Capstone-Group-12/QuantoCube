import 'package:flutter/material.dart';
import 'package:quantocube/components/buttons/large_orange_button.dart';
import 'package:quantocube/components/text_field.dart';

class SignUpAddressPage extends StatelessWidget {
  const SignUpAddressPage({
    super.key,
    required this.signUpData,
  });

  final Map<String, String> signUpData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 100.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 35),
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
                signUpData: signUpData,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddressBox extends StatelessWidget {
  const AddressBox({
    super.key,
    required this.signUpData,
  });

  final Map<String, String> signUpData;

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
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: SignUpAddressContent(signUpData: signUpData),
    );
  }
}

class SignUpAddressContent extends StatefulWidget {
  const SignUpAddressContent({
    super.key,
    required this.signUpData,
  });

  final Map<String, String> signUpData;

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
    'street Address': 'e.g. (Jalan SS 2/75)',
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
    for (int index = 0; index < _addressData.keys.length; index++) {
      _controllers.add(TextEditingController());
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

  String camelToTitle(String text) {
    return text[0].toUpperCase() +
        text.substring(1).splitMapJoin(
              RegExp(r'([A-Z])'),
              onMatch: (m) => ' ${m.group(0)}',
              onNonMatch: (n) => n,
            );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView.builder(
              itemCount: _addressData.keys.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final String hintText =
                    camelToTitle(_addressData.keys.elementAt(index));

                return TextInputSection(
                  titleText: hintText,
                  child: TextInputBox(
                    controller: _controllers[index],
                    hintText: '',
                    textInputAction: index == _addressData.keys.length - 1
                        ? TextInputAction.done
                        : TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a valid $hintText';
                      }
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: (value) {
                      _addressData[_addressData.keys.elementAt(index)] = value;
                      //_isValid = Form.of(context).validate();
                    },
                    onFieldSubmitted: (value) {
                      //_isValid = Form.of(context).validate();
                    },
                  ),
                );
              }),
        ),
        LargeOrangeButton.onlyText(
          context,
          onPressed: () {},
          text: 'Continue',
        ),
        const SizedBox(
          height: 50,
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
