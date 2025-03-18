import 'package:flutter/material.dart';
import 'package:quantocube/page/Homeowner/project_agreement_page_1.dart';

class QuotationDetailsPage extends StatelessWidget {
  const QuotationDetailsPage({super.key});

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
        actions: [
          IconButton(
            icon: const Icon(Icons.download, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildQuotationHeader(context),
            const SizedBox(height: 20),
            _buildQuotationDetails(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuotationHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.monetization_on, color: Colors.yellow),
            SizedBox(width: 5),
            Text(
              'Quotation Expired in 3 days',
              style: TextStyle(color: Colors.orange, fontSize: 14),
            ),
          ],
        ),
        const SizedBox(height: 5),
        const Text(
          'Quotation for Martiny Ong _ 21 Jun 2021',
          style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                onPressed: () {},
                child: const Text('Negotiate', style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProjectAgreementPage()),
                  );
                },
                child: const Text('Accept', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuotationDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Quote #Q980001',
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text(
          'Renovation and redesign of the living room to create a modern and cozy space.',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        SizedBox(height: 10),
        Text(
          'Subtotal: MYR 6800.00',
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          'GST (6%): MYR 408.00',
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          'Total: MYR 7208.00',
          style: TextStyle(color: Colors.orange, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
