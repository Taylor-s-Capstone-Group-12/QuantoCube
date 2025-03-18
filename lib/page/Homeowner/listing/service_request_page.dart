import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  final GlobalKey<LoadingOverlayState> _loadingOverlayKey =
      GlobalKey<LoadingOverlayState>();

  bool isValid = false;

  @override
  void initState() {
    serviceRequest = {
      'userID': widget.userID,
      'contractorID': widget.contractorID,
      'createdAt': FieldValue.serverTimestamp().toString(),
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
    for (String key in serviceRequest.keys) {
      print("$key: ${serviceRequest[key]}");
    }
    setState(() {
      serviceRequest = updatedMap;
      isValid = isServiceRequestValid();
    });
  }

  bool isServiceRequestValid() {
    return serviceRequest['service'] != '';
  }

  Future<String> createProjectDocument() async {
    _loadingOverlayKey.currentState?.show(); // Show loading overlay

    String projectId = Uuid().v4(); // Generate a unique ID
    projectId = "AB-CD"; // Generate a unique ID

    DocumentReference projectRef =
        _firestore.collection("projects").doc(projectId);

    if (mounted) {
      try {
        // Create project document
        await projectRef.set({
          "homeownerId": widget.userID,
          "contractorId": widget.contractorID,
          "createdAt": FieldValue.serverTimestamp(),
        });

        // Initialize "details" document
        await projectRef.collection("data").doc("details").set({
          "createdAt": FieldValue.serverTimestamp(),
          "name": serviceRequest['projectName'],
          "serviceType": serviceRequest['service'],
          "serviceDetail": serviceRequest['details'],
          "location": serviceRequest['location'],
          "startDate": DateTime.parse(serviceRequest['startDate']!),
          "endDate": DateTime.parse(serviceRequest['endDate']!),
          "budgetMin": int.parse(serviceRequest['minBudget']!),
          "budgetMax": int.parse(serviceRequest['maxBudget']!),
          "comments": serviceRequest['additionalComment'],
          "status": "service request",
        });

        // Initialize "pending quotation" document
        await projectRef.collection("data").doc("pending quotation").set({
          "createdAt": FieldValue.serverTimestamp(),
          "details": "",
          "startDate": null,
          "endDate": null,
          "itemList": {}, // Empty map for items
        });

        // Initialize "quotation" document
        await projectRef.collection("data").doc("quotation").set({
          "createdAt": FieldValue.serverTimestamp(),
          "details": "",
          "startDate": null,
          "endDate": null,
          "itemList": {}, // Empty map for items
          "status": "pending",
          "dateResponse": null,
          "finalPrice": 0,
        });

        print("✅ Project created successfully: $projectId");
        _loadingOverlayKey.currentState?.hide();
        return projectId; // Return the new project ID
      } catch (e) {
        _loadingOverlayKey.currentState?.hide();
        print("⚠ Error creating project: $e");
        return ""; // Return empty string if failed
      }
    }
    return "";
  }

  void onContinue() async {
    await createProjectDocument();
    //TODO: Implement sending service request to firebase firestore
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      key: _loadingOverlayKey,
      child: Scaffold(
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
          child: Stack(children: [
            Container(
              height: 70,
              width: double.infinity,
              color: Colors.grey[900],
            ),
            LargeOrangeButton.onlyText(
              context,
              onPressed: isValid ? onContinue : null,
              text: 'Send Request',
            ),
          ]),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
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
  late TextEditingController projectNameController;
  late TextEditingController serviceDetailsController;
  late TextEditingController locationController;
  late TextEditingController additionalCommentsController;

  @override
  void initState() {
    projectNameController = TextEditingController();
    serviceDetailsController = TextEditingController();
    locationController = TextEditingController();
    additionalCommentsController = TextEditingController();

    projectNameController.addListener(() {
      widget.serviceRequest['projectName'] = projectNameController.text;
      widget.updateMap(widget.serviceRequest);
    });
    serviceDetailsController.addListener(() {
      widget.serviceRequest['details'] = serviceDetailsController.text;
      widget.updateMap(widget.serviceRequest);
    });
    locationController.addListener(() {
      widget.serviceRequest['location'] = locationController.text;
      widget.updateMap(widget.serviceRequest);
    });
    additionalCommentsController.addListener(() {
      widget.serviceRequest['additionalComment'] =
          additionalCommentsController.text;
      widget.updateMap(widget.serviceRequest);
    });

    super.initState();
  }

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
        bottom: 150,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const TitleSection(title: 'Project Name', isRequired: true),
          TextInputBox(
            controller: projectNameController,
            maxLines: 1,
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
            controller: serviceDetailsController,
            hintText: 'Tell us more about your project',
          ),
          const Separator(),
          const TitleSection(title: 'Location', isRequired: true),
          TextInputBox(
            controller: locationController,
            hintText: 'Where is your project located?',
            maxLines: 1,
          ),
          const Separator(),
          const TitleSection(title: 'Timeline', isRequired: true),
          DateRangePicker(
            setStartDate: (value) {
              widget.serviceRequest['startDate'] = value.toString();
              widget.updateMap(widget.serviceRequest);
            },
            setEndDate: (value) {
              widget.serviceRequest['endDate'] = value.toString();
              widget.updateMap(widget.serviceRequest);
            },
          ),
          const Separator(),
          const TitleSection(title: 'Budget', isRequired: true),
          BudgetPicker(
            changeMinBudget: (value) {
              widget.serviceRequest['minBudget'] = value;
              widget.updateMap(widget.serviceRequest);
            },
            changeMaxBudget: (value) {
              widget.serviceRequest['maxBudget'] = value;
              widget.updateMap(widget.serviceRequest);
            },
          ),
          const Separator(),
          const TitleSection(title: 'Additional Comments', isRequired: false),
          TextInputBox(
            controller: additionalCommentsController,
            hintText: 'Anything else you\'d like us to know?',
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
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 15,
      ),
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
    this.maxLines = 5,
  });

  final TextEditingController controller;
  final String hintText;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines,
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

class DateRangePicker extends StatefulWidget {
  const DateRangePicker({
    super.key,
    required this.setStartDate,
    required this.setEndDate,
  });

  final void Function(DateTime) setStartDate;
  final void Function(DateTime) setEndDate;

  @override
  _DateRangePickerState createState() => _DateRangePickerState();
}

class _DateRangePickerState extends State<DateRangePicker> {
  DateTime? startDate;
  DateTime? endDate;

  setDate() {
    if (startDate != null) widget.setStartDate(startDate!);
    if (endDate != null) widget.setEndDate(endDate!);
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    DateTime initialDate = isStartDate
        ? (startDate ?? DateTime.now()) // Use today if startDate is null
        : (endDate ??
            startDate ??
            DateTime.now()); // If endDate is null, use startDate or today

    DateTime firstDate = isStartDate
        ? DateTime(2000) // No restriction for start date
        : (startDate ?? DateTime(2000)); // If startDate is null, allow any date

    DateTime lastDate = DateTime(2100);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          startDate = picked;
          if (endDate != null && endDate!.isBefore(startDate!)) {
            endDate = null; // Reset end date if it's before start date
          }
        } else {
          endDate = picked;
        }
      });
    }
    setDate();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildDateCard(
            context,
            title: "Start Date",
            date: startDate,
            onTap: () => _selectDate(context, true),
          ),
        ),
        const SizedBox(width: 8),
        const Text("-", style: TextStyle(fontSize: 20, color: Colors.white)),
        const SizedBox(width: 8),
        Expanded(
          child: _buildDateCard(
            context,
            title: "End Date",
            date: endDate,
            onTap: () => _selectDate(context, false),
          ),
        ),
      ],
    );
  }

  Widget _buildDateCard(BuildContext context,
      {required String title, DateTime? date, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 75,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black, // Background color
          borderRadius: BorderRadius.circular(12),
          //border: Border.all(color: Colors.grey[700]!,), // Border color
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today,
                    color: Theme.of(context).colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  date != null
                      ? DateFormat("d MMM").format(date)
                      : "Select Date",
                  style: TextStyle(
                      fontSize: 14,
                      color: date != null ? Colors.white : Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BudgetPicker extends StatefulWidget {
  const BudgetPicker(
      {super.key,
      required this.changeMinBudget,
      required this.changeMaxBudget});

  final void Function(String) changeMinBudget;
  final void Function(String) changeMaxBudget;

  @override
  _BudgetPickerState createState() => _BudgetPickerState();
}

class _BudgetPickerState extends State<BudgetPicker> {
  final TextEditingController minBudgetController = TextEditingController();
  final TextEditingController maxBudgetController = TextEditingController();

  @override
  void dispose() {
    minBudgetController.dispose();
    maxBudgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildBudgetField(
            controller: minBudgetController,
            label: "Min Budget",
            onChange: widget.changeMinBudget,
          ),
        ),
        const SizedBox(width: 8),
        const Text("-", style: TextStyle(fontSize: 20, color: Colors.white)),
        const SizedBox(width: 8),
        Expanded(
          child: _buildBudgetField(
            controller: maxBudgetController,
            label: "Max Budget",
            onChange: widget.changeMaxBudget,
          ),
        ),
      ],
    );
  }

  Widget _buildBudgetField(
      {required TextEditingController controller,
      required String label,
      required void Function(String) onChange}) {
    return TextFormField(
      controller: controller,
      textInputAction: TextInputAction.done,
      onChanged: onChange,
      keyboardType: TextInputType.number, // Numeric keyboard
      decoration: ProjectTheme.inputDecoration(context).copyWith(
        hintText: label,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Enter a value";
        }
        final intValue = int.tryParse(value);
        if (intValue == null) {
          return "Enter a valid number";
        }
        return null;
      },
    );
  }
}
