import 'package:flutter/material.dart';
import 'package:quantocube/page/Homeowner/payment_summary_page.dart';

class ProjectAgreementPage2 extends StatefulWidget {
  const ProjectAgreementPage2({super.key});

  @override
  _ProjectAgreementPage2State createState() => _ProjectAgreementPage2State();
}

class _ProjectAgreementPage2State extends State<ProjectAgreementPage2> {
  bool term1 = false;
  bool term2 = false;
  bool term3 = false;
  bool term4 = false;
  bool term5 = false;

  bool get isAccepted => term1 && term2 && term3 && term4 && term5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.orange),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Page 2 of 2',
            style: TextStyle(color: Colors.orange, fontSize: 14)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPaymentTerms(),
            const SizedBox(height: 20),
            _buildTermsAndConditions(),
            const SizedBox(height: 30),
            _buildAcceptButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentTerms() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('PAYMENT TERMS',
            style: TextStyle(color: Colors.orange, fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        Text(
          'Upon acceptance of the quote and signing of the agreement, the homeowner is required to pay 100% of the total project cost upfront. '
          'Of this total amount, 40% will be released to the contractor immediately as a deposit. The remaining 60% will be held in escrow and only released upon project completion.',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        SizedBox(height: 10),
        Text(
          'If the project is canceled before commencement, the deposit may be non-refundable. '
          'Any disputes regarding project completion or quality will be resolved through the app’s dispute resolution system.',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildTermsAndConditions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('TERMS AND CONDITIONS',
            style: TextStyle(color: Colors.orange, fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        _buildCheckbox(
            'Any changes or additions to the scope of work must be agreed upon in writing by both parties.', (val) {
          setState(() => term1 = val);
        }, term1),
        _buildCheckbox(
            'The project timeline is tentative and subject to mutual agreement.', (val) {
          setState(() => term2 = val);
        }, term2),
        _buildCheckbox(
            'Payments are due as per the agreed schedule. Delayed payments may result in project delays.', (val) {
          setState(() => term3 = val);
        }, term3),
        _buildCheckbox(
            'The contractor is responsible for any damage caused during the project and will ensure proper insurance coverage.', (val) {
          setState(() => term4 = val);
        }, term4),
        _buildCheckbox(
            'Either party may terminate this agreement with written notice if the other fails to meet their obligations.', (val) {
          setState(() => term5 = val);
        }, term5),
      ],
    );
  }

  Widget _buildCheckbox(String text, Function(bool) onChanged, bool value) {
    return Row(
      children: [
        Checkbox(
          value: value,
          activeColor: Colors.orange,
          checkColor: Colors.black,
          onChanged: (val) {
            if (val != null) {
              onChanged(val);
            }
          },
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildAcceptButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isAccepted ? Colors.orange : Colors.grey,
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: isAccepted
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PaymentSummaryPage()),
                );
              }
            : null,
        child: const Text('Accept',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
