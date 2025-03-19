import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quantocube/components/buttons/back_button.dart';
import 'package:quantocube/components/components.dart';
import 'package:quantocube/theme.dart';
import 'package:uuid/uuid.dart';

final FirebaseFirestore _firestore =
    FirebaseFirestore.instance; // Initialize Firestore

class EditServiceRequestPage extends StatefulWidget {
  const EditServiceRequestPage({
    super.key,
    required this.projectID,
  });

  final String projectID;

  @override
  State<EditServiceRequestPage> createState() => _EditServiceRequestPageState();
}

class _EditServiceRequestPageState extends State<EditServiceRequestPage> {
  Map<String, String> serviceRequest = {
    'createdAt': '',
    'service': '',
    'details': '',
    'location': '',
    'startDate': '',
    'endDate': '',
    'additionalComment': '',
    'projectName': '',
  };

  final GlobalKey<LoadingOverlayState> _loadingOverlayKey =
      GlobalKey<LoadingOverlayState>();

  bool isValid = false;

  bool isLoading = true;

  @override
  void initState() {
    getServiceDetails();
    super.initState();
  }

  Future<void> getServiceDetails() async {
    print('DEBUG: Getting service details');

    await _firestore
        .collection('projects')
        .doc(widget.projectID)
        .collection('data')
        .doc('details')
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document does exist.');

        var data = documentSnapshot.data();
        if (data is Map<String, dynamic>) {
          for (var key in data.keys) {
            var value = data[key];
            print('Key: $key, Value: $value, Type: ${value.runtimeType}');
          }
        } else {
          print("Document data is null or not a valid map");
        }

        serviceRequest['service'] = documentSnapshot['serviceType'];
        serviceRequest['projectName'] = documentSnapshot['name'];
        serviceRequest['details'] = documentSnapshot['serviceDetail'];
        serviceRequest['location'] = documentSnapshot['location'];
        serviceRequest['startDate'] =
            (documentSnapshot['startDate'] as Timestamp).toDate().toString();
        serviceRequest['endDate'] =
            (documentSnapshot['endDate'] as Timestamp).toDate().toString();
        serviceRequest['minBudget'] = documentSnapshot['budgetMin'].toString();
        serviceRequest['maxBudget'] = documentSnapshot['budgetMax'].toString();
        serviceRequest['additionalComment'] = documentSnapshot['comments'];
        setState(() {
          isLoading = false;
        });
      }
    });
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

  Future<void> saveProjectDocument() async {
    _loadingOverlayKey.currentState?.show(); // Show loading overlay

    DocumentReference projectRef =
        _firestore.collection("projects").doc(widget.projectID);

    if (mounted) {
      try {
        // Create project document

        await projectRef.collection("timeline").doc(Uuid().v4()).set({
          "createdAt": FieldValue.serverTimestamp(),
          "status": "serviceRequest",
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
          "status": "serviceRequest",
          "serviceStatus": "pending",
        });
      } catch (e) {
        _loadingOverlayKey.currentState?.hide();
        print("⚠ Error creating project: $e");
      }
    }
  }

  void onContinue() async {
    await saveProjectDocument();
    if (mounted) {
      await _firestore
          .collection('projects')
          .doc(widget.projectID)
          .collection('chat')
          .add({
        'attachmentType': 'Service Request',
        'message': serviceRequest['details'],
        'time': FieldValue.serverTimestamp(),
        'type': 'attachment',
        'sender': FirebaseAuth.instance.currentUser!.uid,
      });

      _loadingOverlayKey.currentState?.hide();

      Navigator.pop(
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      key: _loadingOverlayKey,
      child: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Scaffold(
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
                    width: MediaQuery.of(context).size.width,
                    color: Colors.grey[900],
                  ),
                  LargeOrangeButton.onlyText(
                    context,
                    onPressed: isValid ? onContinue : null,
                    text: 'Send Request',
                  ),
                ]),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
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
  @override
  void initState() {
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
      width: MediaQuery.of(context).size.width,
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
            initialValue: widget.serviceRequest['projectName'],
            onChanged: (value) {
              widget.serviceRequest['projectName'] = value;
              widget.updateMap(widget.serviceRequest);
            },
            maxLines: 1,
            hintText: 'Enter project name',
          ),
          const Separator(),
          const TitleSection(title: 'Select Service', isRequired: true),
          ServiceSelectionMenu(
            initialSelection: widget.serviceRequest['service']!,
            onSelected: onServiceSelect,
          ),
          const Separator(),
          const TitleSection(title: 'Service Details', isRequired: true),
          TextInputBox(
            initialValue: widget.serviceRequest['details'],
            hintText: 'Tell us more about your project',
            onChanged: (value) {
              widget.serviceRequest['details'] = value;
              widget.updateMap(widget.serviceRequest);
            },
          ),
          const Separator(),
          const TitleSection(title: 'Location', isRequired: true),
          TextInputBox(
            initialValue: widget.serviceRequest['location'],
            onChanged: (value) {
              widget.serviceRequest['location'] = value;
              widget.updateMap(widget.serviceRequest);
            },
            hintText: 'Where is your project located?',
            maxLines: 1,
          ),
          const Separator(),
          const TitleSection(title: 'Timeline', isRequired: true),
          DateRangePicker(
            initialEndDate: DateTime.parse(widget.serviceRequest['endDate']!),
            initialStartDate:
                DateTime.parse(widget.serviceRequest['startDate']!),
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
            minBudget: widget.serviceRequest['minBudget']!,
            maxBudget: widget.serviceRequest['maxBudget']!,
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
            initialValue: widget.serviceRequest['additionalComment'],
            onChanged: (value) {
              widget.serviceRequest['additionalComment'] = value;
              widget.updateMap(widget.serviceRequest);
            },
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
    required this.initialSelection,
  });

  void Function(String) onSelected;
  final String initialSelection;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9, // 90% of screen width
      child: DropdownMenu<String>(
        initialSelection: initialSelection,
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
          maximumSize: WidgetStateProperty.all(
              const Size(1000, double.infinity)), // Fixed max width
          backgroundColor:
              WidgetStateProperty.all(Colors.grey[900]), // Dark background
          elevation: WidgetStateProperty.all(8), // Shadow effect
          shape: WidgetStateProperty.all(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TextInputBox extends StatelessWidget {
  const TextInputBox({
    super.key,
    required this.onChanged,
    required this.hintText,
    this.maxLines = 5,
    this.initialValue,
  });

  final void Function(String) onChanged;
  final String hintText;
  final int maxLines;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      maxLines: maxLines,
      onChanged: onChanged,
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
    required this.initialStartDate,
    required this.initialEndDate,
  });

  final void Function(DateTime) setStartDate;
  final void Function(DateTime) setEndDate;

  final DateTime initialStartDate;
  final DateTime initialEndDate;

  @override
  _DateRangePickerState createState() => _DateRangePickerState();
}

class _DateRangePickerState extends State<DateRangePicker> {
  late DateTime startDate;
  late DateTime endDate;

  @override
  void initState() {
    super.initState();
    startDate = widget.initialStartDate;
    endDate = widget.initialEndDate;
  }

  void setDate() {
    widget.setStartDate(startDate);
    widget.setEndDate(endDate);
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    DateTime initialDate = isStartDate ? startDate : endDate;
    DateTime firstDate = isStartDate ? DateTime(2000) : startDate;
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
          if (endDate.isBefore(startDate)) {
            endDate = picked;
          }
        } else {
          endDate = picked;
        }
      });
      setDate();
    }
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
      {required String title,
      required DateTime date,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 75,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12),
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
                  DateFormat("d MMM").format(date),
                  style: const TextStyle(fontSize: 14, color: Colors.white),
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
  const BudgetPicker({
    super.key,
    required this.changeMinBudget,
    required this.changeMaxBudget,
    required this.minBudget,
    required this.maxBudget,
  });

  final void Function(String) changeMinBudget;
  final void Function(String) changeMaxBudget;

  final String minBudget;
  final String maxBudget;

  @override
  _BudgetPickerState createState() => _BudgetPickerState();
}

class _BudgetPickerState extends State<BudgetPicker> {
  late TextEditingController minBudgetController;
  late TextEditingController maxBudgetController;

  @override
  void initState() {
    super.initState();
    minBudgetController = TextEditingController(text: widget.minBudget);
    maxBudgetController = TextEditingController(text: widget.maxBudget);
  }

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

  Widget _buildBudgetField({
    required TextEditingController controller,
    required String label,
    required void Function(String) onChange,
  }) {
    return TextFormField(
      controller: controller,
      textInputAction: TextInputAction.done,
      onChanged: onChange,
      keyboardType: TextInputType.number,
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
