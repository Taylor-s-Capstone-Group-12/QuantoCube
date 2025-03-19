import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quantocube/components/buttons/large_orange_button.dart';
import 'package:quantocube/components/overlays/loading_overlay.dart';
import 'package:quantocube/page/homeowner/listing/edit_service_request.dart';
import 'package:quantocube/page/messaging/attachment/add_item.dart';
import 'package:quantocube/theme.dart';

class CreateQuotationPage extends StatefulWidget {
  const CreateQuotationPage({super.key, required this.projectId});

  final String projectId;

  @override
  State<CreateQuotationPage> createState() => _CreateQuotationPageState();
}

final _firestore = FirebaseFirestore.instance;

class _CreateQuotationPageState extends State<CreateQuotationPage> {
  final Map<String, String> serviceRequest = {
    'createdAt': '',
    'service': '',
    'details': '',
    'location': '',
    'startDate': '',
    'endDate': '',
    'additionalComment': '',
    'projectName': '',
  };

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
        .doc(widget.projectId)
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

        quotationDetails['startDate'] =
            (documentSnapshot['startDate'] as Timestamp).toDate();
        quotationDetails['endDate'] =
            (documentSnapshot['endDate'] as Timestamp).toDate();

        setState(() {
          isLoading = false;
        });
      } else {
        print('Document does not exist.');
      }
    });
  }

  Future<void> sendQuotation() async {
    _loadingOverlayKey.currentState?.show(); // Show loading overlay
    DocumentReference projectRef =
        _firestore.collection("projects").doc(widget.projectId);
    // Reference to the "pending quotation" document
    DocumentReference pendingQuotationRef =
        projectRef.collection("data").doc("pending quotation");

    if (mounted) {
      try {
        quotationDetails['createdAt'] = FieldValue.serverTimestamp();
        // Update Firestore document
        await pendingQuotationRef.set(
            quotationDetails, SetOptions(merge: true));
      } catch (e) {
        _loadingOverlayKey.currentState?.hide();
        print("⚠ Error creating project: $e");
      }
    }
  }

  final GlobalKey<LoadingOverlayState> _loadingOverlayKey =
      GlobalKey<LoadingOverlayState>();
  final Map<String, dynamic> quotationDetails = {};
  bool isValid = false;

  void printQuotationDetails() {
    quotationDetails.forEach((key, value) {
      print('Key: $key, Value: $value, Type: ${value.runtimeType}');
    });
  }

  void checkValidity() {
    setState(() {
      isValid = quotationDetails.containsKey('details') &&
          quotationDetails['details'].isNotEmpty &&
          quotationDetails.containsKey('lineItems') &&
          (quotationDetails['lineItems'] as List).isNotEmpty &&
          quotationDetails.containsKey('startDate') &&
          quotationDetails.containsKey('endDate');
    });
  }

  void onContinue() async {
    printQuotationDetails();
    // Send quotation details to the server
    await sendQuotation();
    if (mounted) {
      await _firestore
          .collection('projects')
          .doc(widget.projectId)
          .collection('chat')
          .add({
        'attachmentType': 'Quotation',
        'message':
            'Quotation for the Project "${serviceRequest['projectName']}"',
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
          ? const Center(child: CircularProgressIndicator())
          : Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const TitleBar(),
                    QuotationBody(
                      quotationDetails: quotationDetails,
                      serviceDetails: serviceRequest,
                      checkValidity: checkValidity,
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
                    text: 'Send Quotation',
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
      margin: const EdgeInsets.only(bottom: 35),
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
            'New Quote',
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

class QuotationBody extends StatefulWidget {
  const QuotationBody(
      {super.key,
      required this.quotationDetails,
      required this.serviceDetails,
      required this.checkValidity});

  final Map<String, dynamic> quotationDetails;
  final Map<String, String> serviceDetails;
  final VoidCallback checkValidity;

  @override
  State<QuotationBody> createState() => _QuotationBodyState();
}

class _QuotationBodyState extends State<QuotationBody> {
  List<Map<String, dynamic>> lineItems = [];
  double subtotal = 0;

  void _addLineItem(Map<String, dynamic> item) {
    setState(() {
      lineItems.add(item);
      updateSubtotal();
      widget.quotationDetails['lineItems'] = lineItems;
      widget.quotationDetails['subtotal'] = subtotal;
      widget.checkValidity();
    });
  }

  void updateSubtotal() {
    setState(() {
      subtotal = lineItems.fold<double>(0, (sum, item) {
        return sum + ((item['quantity'] * item['unitPrice']));
      });
    });
  }

  void _openAddItemModal() async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      builder: (context) => AddLineItemPage(),
    );

    if (result != null) {
      _addLineItem(result);
    }
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
          TitleSection(title: 'Service Location'),
          DisplayDetail(detail: widget.serviceDetails['location']!),
          Separator(),
          TitleSection(title: 'Project Title'),
          DisplayDetail(detail: widget.serviceDetails['projectName']!),
          Separator(),
          TitleSection(title: 'Overview', isRequired: true),
          TextInputBox(
              onChanged: (value) {
                widget.quotationDetails['details'] = value;
                widget.checkValidity();
              },
              hintText: 'Briefly describe the project'),
          Separator(),
          TitleSection(title: 'Work', isRequired: true),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: lineItems.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          title: const Text("Line Items",
                              style: TextStyle(color: Colors.white)),
                          trailing: GestureDetector(
                            onTap: _openAddItemModal,
                            child: Icon(Icons.add,
                                color: Theme.of(context).colorScheme.primary),
                          ),
                        ),
                      ),
                    );
                  }
                  final item = lineItems[index - 1];

                  return Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black, // Background color
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                item['serviceType'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  lineItems.removeAt(index - 1);
                                });
                              },
                              child: const Icon(Icons.delete,
                                  color: Colors.red, size: 20),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['description'],
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${item['quantity']} x MYR ${item['unitPrice'].toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "MYR ${(item['quantity'] * item['unitPrice']).toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          Separator(),
          InvoiceSummary(subtotal: subtotal),
          Separator(),
          TitleSection(
            title: 'Estimated Timeline',
            isRequired: true,
          ),
          DateRangePicker(
            setStartDate: setStartDate,
            setEndDate: setEndDate,
            initialEndDate: DateTime.parse(widget.serviceDetails['endDate']!),
            initialStartDate:
                DateTime.parse(widget.serviceDetails['startDate']!),
          ),
          Separator(),
          TitleSection(title: 'Additional Comments'),
          TextInputBox(
              onChanged: (value) {
                widget.quotationDetails['additionalComments'] = value;
                widget.checkValidity();
              },
              maxLines: 5,
              hintText: 'Additional Comments'),
        ],
      ),
    );
  }

  void setStartDate(DateTime value) {
    widget.quotationDetails['startDate'] = value;
    widget.checkValidity();
  }

  void setEndDate(DateTime value) {
    widget.quotationDetails['endDate'] = value;
    widget.checkValidity();
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

class DisplayDetail extends StatelessWidget {
  const DisplayDetail({super.key, required this.detail});

  final String detail;

  @override
  Widget build(BuildContext context) {
    return Text(
      detail,
      style: const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 15,
        color: Color(0xFFB8B8B8),
      ),
    );
  }
}

class InvoiceSummary extends StatelessWidget {
  final double subtotal;
  final double gstRate;
  final double depositRate;

  const InvoiceSummary({
    super.key,
    required this.subtotal,
    this.gstRate = 0.06, // 6% GST
    this.depositRate = 0.4, // 40% Deposit
  });

  String formatCurrency(double amount) {
    return "MYR ${NumberFormat("#,##0.00").format(amount)}";
  }

  @override
  Widget build(BuildContext context) {
    double gstAmount = subtotal * gstRate;
    double total = subtotal + gstAmount;
    double depositAmount = total * depositRate;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRow(
            isBold: true, "Subtotal", formatCurrency(subtotal.toDouble())),
        _buildRow("GST (6%)", formatCurrency(gstAmount)),
        const SizedBox(height: 8),
        _buildRow("Total", formatCurrency(total),
            color: Theme.of(context).colorScheme.primary, isBold: true),
        const SizedBox(height: 8),
        _buildRow("Deposit (40%)", formatCurrency(depositAmount)),
      ],
    );
  }

  Widget _buildRow(String label, String value,
      {Color? color, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: color ?? Colors.white,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: color ?? Colors.white,
            ),
          ),
        ],
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
