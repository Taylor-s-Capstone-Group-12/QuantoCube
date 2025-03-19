import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quantocube/components/buttons/default_square_button.dart';
import 'package:quantocube/components/overlays/loading_overlay.dart';
import 'package:quantocube/page/messaging/attachment/create_quotation.dart';
import 'package:quantocube/theme.dart';
import 'package:quantocube/utils/utils.dart';

class QuotationReviewPage extends StatefulWidget {
  const QuotationReviewPage({super.key, required this.projectId});

  final String projectId;

  @override
  State<QuotationReviewPage> createState() => _QuotationReviewPageState();
}

final FirebaseFirestore _firestore =
    FirebaseFirestore.instance; // Initialize Firestore

class _QuotationReviewPageState extends State<QuotationReviewPage> {
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  final GlobalKey<LoadingOverlayState> _overlayKey =
      GlobalKey<LoadingOverlayState>();
  bool isLoading = true;
  bool isHomeowner = false;

  final Map<String, String> _projectHeader = {
    'title': 'Quotation',
    'createdAt': '',
  };

  final Map<String, dynamic> _projectDetails = {
    'homeownerName': '',
    'location': '',
    'details': '',
    'startDate': null,
    'endDate': null,
    'lineItems': <Map<String, dynamic>>[],
    'subtotal': 0.0,
  };

  @override
  void initState() {
    assignProjectInfo();
    super.initState();
  }

  Future<void> assignProjectInfo() async {
    final DocumentSnapshot projectInfoSnapshot =
        await _firestore.collection('projects').doc(widget.projectId).get();

    final DocumentSnapshot projectDetailsSnapshot = await _firestore
        .collection('projects')
        .doc(widget.projectId)
        .collection('data')
        .doc('details')
        .get();

    final DocumentSnapshot quotationDetailsSnapshot = await _firestore
        .collection('projects')
        .doc(widget.projectId)
        .collection('data')
        .doc('pending quotation')
        .get();

    final homeownerName =
        await getNameFromId(await getHomeownerId(widget.projectId));
    if (homeownerName is String) {
      _projectDetails['homeownerName'] = homeownerName;
    } else {
      _projectDetails['homeownerName'] = 'Unknown';
    }

    if (projectInfoSnapshot.exists && quotationDetailsSnapshot.exists) {
      if (projectInfoSnapshot['homeownerId'] == userId) {
        isHomeowner = true;
      }

      final Map<String, dynamic> projectInfoData =
          projectDetailsSnapshot.data() as Map<String, dynamic>? ?? {};

      final Map<String, dynamic> projectQuotationData =
          quotationDetailsSnapshot.data() as Map<String, dynamic>? ?? {};

// Convert timestamps safely
      _projectHeader['createdAt'] =
          (projectQuotationData['createdAt'] as Timestamp?)
                  ?.toDate()
                  .toString() ??
              "N/A";

      _projectDetails['location'] =
          projectInfoData['location'] as String? ?? "Unknown";
      _projectDetails['details'] =
          projectQuotationData['details'] as String? ?? "No details available";

      _projectDetails['startDate'] =
          (projectQuotationData['startDate'] as Timestamp?)
                  ?.toDate()
                  .toString() ??
              "N/A";

      _projectDetails['endDate'] =
          (projectQuotationData['endDate'] as Timestamp?)
                  ?.toDate()
                  .toString() ??
              "N/A";

      _projectDetails['lineItems'] =
          (projectQuotationData['lineItems'] as List<dynamic>?)
                  ?.map((item) => item as Map<String, dynamic>)
                  .toList() ??
              [];

// Convert subtotal safely
      _projectDetails['subtotal'] =
          (projectQuotationData['subtotal'] as num?)?.toDouble() ?? 0.0;

      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception('Project not found');
    }
  }

  Future<void> addAnnoucement(String message) async {
    _firestore
        .collection('projects')
        .doc(widget.projectId)
        .collection('chat')
        .add({
      'sender': userId,
      'message': message,
      'time': FieldValue.serverTimestamp(),
      'type': 'announcement',
    });
  }

  void onDecline() async {
    String? message = await showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows full-screen height
      backgroundColor: Colors.transparent,
      builder: (context) {
        return QuoteDiscussionPopup();
      },
    );

    if (message == null) {
      return;
    }

    await _firestore
        .collection('projects')
        .doc(widget.projectId)
        .collection('data')
        .doc('details')
        .update({'serviceStatus': 'decline'}).then((_) async {
      print('Service status updated successfully');
      await changeStatus('serviceRejected');
      await addAnnoucement('Quotation has been declined.');

      await _firestore
          .collection('projects')
          .doc(widget.projectId)
          .collection('chat')
          .add({
        'attachmentType': 'Quotation',
        'message': message,
        'time': FieldValue.serverTimestamp(),
        'type': 'attachment',
        'sender': FirebaseAuth.instance.currentUser!.uid,
      });

      if (mounted) {
        Navigator.pop(context);
      }
    }).catchError((error) {
      print('Failed to update service status: $error');
    });
  }

  void onAccept() {
    _firestore
        .collection('projects')
        .doc(widget.projectId)
        .collection('data')
        .doc('details')
        .update({'serviceStatus': 'accepted'}).then((_) async {
      print('Service status updated successfully');
      await changeStatus('projectConfirmed');
      await addAnnoucement('Quotation has been accepted.');

      if (mounted) {
        Navigator.pop(context);
      }
    }).catchError((error) {
      print('Failed to update service status: $error');
    });
  }

  Future<void> changeStatus(String status) async {
    await _firestore
        .collection('projects')
        .doc(widget.projectId)
        .collection('data')
        .doc('details')
        .update({'status': status});
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TitleBar(
                    projectHeader: _projectHeader,
                    onDecline: onDecline,
                    onAccept: onAccept,
                    isHomeowner: isHomeowner,
                  ),
                  ServiceRequestBody(
                    serviceRequest: _projectDetails,
                  ),
                ],
              ),
            ),
          );
  }
}

class TitleBar extends StatelessWidget {
  const TitleBar({
    super.key,
    required this.projectHeader,
    required this.onDecline,
    required this.onAccept,
    required this.isHomeowner,
  });

  final Map<String, String> projectHeader;
  final bool isHomeowner;
  final VoidCallback onDecline;
  final VoidCallback onAccept;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
        ),
      ),
      padding: const EdgeInsets.only(left: 30, top: 84, bottom: 40, right: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Transform.translate(
            offset: const Offset(-10, 0),
            child: IconButton(
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
          ),
          Text(
            projectHeader['title'] ?? 'Unnamed Project',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          if (isHomeowner) const SizedBox(height: 30),
          if (isHomeowner)
            SizedBox(
              width: double.infinity,
              height: 50,
              child: Row(
                children: [
                  Expanded(
                    child: DefaultSquareButton.onlyText(
                      context,
                      onPressed: onDecline,
                      text: 'Negotiate',
                      height: 50,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DefaultSquareButton.onlyText(
                      context,
                      onPressed: onAccept,
                      text: 'Accept',
                      height: 50,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class ServiceRequestBody extends StatelessWidget {
  const ServiceRequestBody({super.key, required this.serviceRequest});

  final Map<String, dynamic> serviceRequest;

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> lineItems = serviceRequest['lineItems'];

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(
        top: 56,
        left: 30,
        right: 30,
        bottom: 30,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TitleSection(title: serviceRequest['homeownerName'] ?? 'Unknown'),
          const SizedBox(height: 10),
          DisplayDetail(detail: serviceRequest['location'] ?? 'Unknown'),
          const SizedBox(height: 10),
          DisplayDetail(detail: serviceRequest['details'] ?? 'Unknown'),
          SizedBox(height: 20),
          Row(
            children: [
              const TitleSection(title: 'Sent'),
              const Spacer(),
              DisplayDetail(
                detail: DateFormat('dd MMM yyyy')
                    .format(DateTime.parse(serviceRequest['startDate'])),
              ),
            ],
          ),
          Separator(),
          const TitleSection(title: 'Quotation Details'),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: lineItems.length,
            itemBuilder: (context, index) {
              final item = lineItems[index];
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
          Separator(),
          InvoiceSummary(subtotal: serviceRequest['subtotal']),
          Separator(),
          DisplayDetail(
              detail:
                  "These dates are tentative and will be confirmed upon project confirmation\n\nThis quote is valid for the next 3 days, after which values may be subject to change.\n\n40% of the total project cost is paid upfront to the contractor, and the remaining 60% is held by the app and released upon your confirmation of project completion."),
          SizedBox(height: 20),
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

class QuoteDiscussionPopup extends StatefulWidget {
  @override
  _QuoteDiscussionPopupState createState() => _QuoteDiscussionPopupState();
}

class _QuoteDiscussionPopupState extends State<QuoteDiscussionPopup> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height, // Full height
      decoration: BoxDecoration(
        color: Colors.black, // Adjust for your theme
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Container(
        color: Theme.of(context).colorScheme.secondary,
        child: Center(
          child: SizedBox(
            height: 330,
            width: 330,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'What would you like to discuss about the quote?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                TextInputBox2(
                  onChanged: _messageController, // Use controller
                  hintText:
                      "Let us know which aspects of the quote you'd like to discuss (e.g., price, timeline, materials)",
                ),
                const SizedBox(height: 20),
                Flexible(
                  child: DefaultSquareButton.onlyText(
                    context,
                    onPressed: () {
                      Navigator.pop(context, _messageController.text);
                    },
                    text: 'Submit',
                    height: 50,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TextInputBox2 extends StatelessWidget {
  const TextInputBox2({
    super.key,
    required this.onChanged,
    required this.hintText,
    this.maxLines = 5,
    this.initialValue,
  });

  final TextEditingController onChanged;
  final String hintText;
  final int maxLines;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      maxLines: maxLines,
      controller: onChanged,
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
