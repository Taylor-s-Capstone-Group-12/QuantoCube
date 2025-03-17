import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quantocube/components/buttons/back_button.dart';
import 'package:quantocube/components/components.dart';
import 'package:quantocube/theme.dart';

class ServiceRequestPage extends StatelessWidget {
  const ServiceRequestPage({
    super.key,
    required this.userID,
    required this.contractorID,
  });

  final String userID;
  final String contractorID;

  @override
  Widget build(BuildContext context) {
    Map<String, String> serviceRequest = {
      'userID': userID,
      'contractorID': contractorID,
      'service': '',
      'details': '',
      'location': '',
      'startDate': '',
      'endDate': '',
    };

    return Scaffold(
      body: const SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TitleBar(),
            ServiceRequestBody(),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: LargeOrangeButton.onlyText(
          context,
          onPressed: () {},
          text: 'Send Request',
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class TitleBar extends StatelessWidget {
  const TitleBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 145,
      width: double.infinity,
      padding: const EdgeInsets.only(left: 30, top: 84),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            style: IconButton.styleFrom(
              padding: const EdgeInsets.all(0),
            ),
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).colorScheme.primary,
              size: 35,
            ),
          ),
          const SizedBox(width: 7),
          const Text(
            'Service Request',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class ServiceRequestBody extends StatefulWidget {
  const ServiceRequestBody({super.key});

  @override
  State<ServiceRequestBody> createState() => _ServiceRequestBodyState();
}

class _ServiceRequestBodyState extends State<ServiceRequestBody> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
        ),
        color: Theme.of(context).colorScheme.secondary,
      ),
      padding: const EdgeInsets.only(
        top: 56,
        left: 30,
        right: 30,
        bottom: 50,
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TitleSection(title: 'Select Service', isRequired: true),
          SizedBox(height: 10),
          ServiceSelectionMenu(),
        ],
      ),
    );
  }
}

class TitleSection extends StatelessWidget {
  const TitleSection({
    super.key,
    required this.title,
    this.isRequired,
  });

  final String title;
  final bool? isRequired;

  @override
  Widget build(BuildContext context) {
    return Text(
      title + (isRequired ?? false ? '*' : ''),
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
      textAlign: TextAlign.left,
    );
  }
}

List<String> serviceSelections = [
  'Renovations',
  'Air COnditioning',
  'Installations',
  'Electrical',
  'Plumbing',
  'Others',
];

class ServiceSelectionMenu extends StatelessWidget {
  const ServiceSelectionMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      width: double.infinity,
      initialSelection: serviceSelections[0],
      inputDecorationTheme: ProjectTheme.inputDecorationTheme(context),
      onSelected: (value) {},
      dropdownMenuEntries: [
        for (var service in serviceSelections)
          DropdownMenuEntry<String>(
            value: service,
            label: service,
          ),
      ],
    );
  }
}

class TextInputBox extends StatelessWidget {
  const TextInputBox({
    super.key,
    required this.controller,
    required this.hintText,
  });

  final TextEditingController controller;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 15,
      ),
      decoration: ProjectTheme.inputDecoration(context).copyWith(
        hintText: hintText,
      ),
    );
  }
}
