import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quantocube/components/buttons/back_button.dart';
import 'package:quantocube/components/components.dart';
import 'package:quantocube/theme.dart';
import 'package:uuid/uuid.dart';

final FirebaseFirestore _firestore =
    FirebaseFirestore.instance; // Initialize Firestore

class ServiceRequestPage extends StatefulWidget {
  const ServiceRequestPage({
    super.key,
    required this.userID,
    required this.contractorID,
  });

  final String userID;
  final String contractorID;

  @override
  State<ServiceRequestPage> createState() => _ServiceRequestPageState();
}

class _ServiceRequestPageState extends State<ServiceRequestPage> {
  late Map<String, String> serviceRequest;

  @override
  void initState() {
    serviceRequest = {
      'userID': widget.userID,
      'contractorID': widget.contractorID,
      'createdAt': '',
      'service': '',
      'details': '',
      'location': '',
      'startDate': '',
      'endDate': '',
      'additionalComment': '',
    };

    super.initState();
  }

  void updateMap(Map<String, String> updatedMap) {
    setState(() {
      serviceRequest = updatedMap;
    });
  }

  bool isServiceRequestValid() {
    return serviceRequest['service'] != '';
  }

  Future<String> createProjectDocument({
    required String homeownerId,
    required String contractorId,
  }) async {
    String projectId = Uuid().v4(); // Generate a unique ID

    DocumentReference projectRef =
        _firestore.collection("projects").doc(projectId);

    try {
      // Create project document
      await projectRef.set({
        "homeownerId": homeownerId,
        "contractorId": contractorId,
      });

      // Initialize "details" document
      await projectRef.collection("data").doc("details").set({
        "dateCreated": FieldValue.serverTimestamp(),
        "name": "",
        "serviceType": "",
        "serviceDetail": "",
        "location": "",
        "startDate": null,
        "endDate": null,
        "budgetMin": 0,
        "budgetMax": 0,
        "comments": "",
        "status": "service request",
      });

      // Initialize "pending quotation" document
      await projectRef.collection("data").doc("pending quotation").set({
        "dateCreated": FieldValue.serverTimestamp(),
        "details": "",
        "startDate": null,
        "endDate": null,
        "itemList": {}, // Empty map for items
      });

      // Initialize "quotation" document
      await projectRef.collection("data").doc("quotation").set({
        "dateCreated": FieldValue.serverTimestamp(),
        "details": "",
        "startDate": null,
        "endDate": null,
        "itemList": {}, // Empty map for items
        "status": "pending",
        "dateResponse": null,
        "finalPrice": 0,
      });

      print("✅ Project created successfully: $projectId");
      return projectId; // Return the new project ID
    } catch (e) {
      print("⚠ Error creating project: $e");
      return ""; // Return empty string if failed
    }
  }

  void onContinue() {
    //TODO: Implement sending service request to firebase firestore
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const TitleBar(),
            ServiceRequestBody(
              serviceRequest: serviceRequest,
              updateMap: updateMap,
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: LargeOrangeButton.onlyText(
          context,
          onPressed: isServiceRequestValid() ? onContinue : null,
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
  const ServiceRequestBody({
    super.key,
    required this.serviceRequest,
    required this.updateMap,
  });

  final Map<String, String> serviceRequest;
  final void Function(Map<String, String>) updateMap;

  @override
  State<ServiceRequestBody> createState() => _ServiceRequestBodyState();
}

class _ServiceRequestBodyState extends State<ServiceRequestBody> {
  void onServiceSelect(String service) {
    setState(() {
      widget.serviceRequest['service'] = service;
    });
  }

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const TitleSection(title: 'Project Name', isRequired: true),
          TextInputBox(
            controller: TextEditingController(),
            hintText: 'Enter project name',
          ),
          const Separator(),
          const TitleSection(title: 'Select Service', isRequired: true),
          ServiceSelectionMenu(
            onSelected: onServiceSelect,
          ),
          const Separator(),
          const TitleSection(title: 'Service Details', isRequired: true),
          TextInputBox(
            controller: TextEditingController(),
            hintText: 'Enter service details',
          ),
        ],
      ),
    );
  }
}

class Separator extends StatelessWidget {
  const Separator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: Divider(
        color: Color(0xFF252525),
        height: 0,
        thickness: 1,
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Text(
        title + (isRequired ?? false ? '*' : ''),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }
}

List<String> serviceSelections = [
  'Renovations',
  'Air Conditioning',
  'Installations',
  'Electrical',
  'Plumbing',
  'Others',
];

class ServiceSelectionMenu extends StatelessWidget {
  ServiceSelectionMenu({
    super.key,
    required this.onSelected,
  });

  void Function(String) onSelected;

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      width: double.infinity,
      hintText: 'Select Service',
      inputDecorationTheme: ProjectTheme.inputDecorationTheme(context),
      onSelected: (value) {
        onSelected(value ?? '');
      },
      dropdownMenuEntries: [
        for (var service in serviceSelections)
          DropdownMenuEntry<String>(
            value: service,
            label: service,
          ),
      ],
      menuStyle: MenuStyle(
        maximumSize: WidgetStateProperty.all(Size.fromWidth(350)),
        backgroundColor:
            WidgetStateProperty.all(Colors.grey[900]), // Dark background
        elevation: WidgetStateProperty.all(8), // Shadow effect
        shape: WidgetStateProperty.all(
          const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          )),
        ),
      ),
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
