import 'package:flutter/material.dart';
import 'package:quantocube/page/Payment/payment_option_page.dart'; // Import PaymentOptionPage

class PaymentSummaryPage extends StatelessWidget {
  const PaymentSummaryPage({super.key});

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
        title: const Text(
          'Summary',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryHeader(),
            const SizedBox(height: 20),
            _buildServiceList(),
            const SizedBox(height: 20),
            _buildTotalAmount(),
            const SizedBox(height: 30),
            _buildPaymentButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryHeader() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Jackson Hon',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Project #9872',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildServiceList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildServiceItem('Interior Design Consultation', 2000.00),
        _buildServiceItem('Painting Services', 1000.00),
        _buildServiceItem('Furniture Package', 3000.00),
        _buildServiceItem('Labor and Installation', 800.00),
      ],
    );
  }

  Widget _buildServiceItem(String title, double price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
          Text(
            'MYR ${price.toStringAsFixed(2)}',
            style: const TextStyle(color: Colors.orange, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalAmount() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSummaryTotal('Subtotal', 6800.00),
        _buildSummaryTotal('GST (6%)', 408.00),
        const Divider(color: Colors.grey),
        _buildSummaryTotal('Total Payment', 7208.00, isTotal: true),
      ],
    );
  }

  Widget _buildSummaryTotal(String title, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(color: isTotal ? Colors.orange : Colors.white, fontSize: 16),
          ),
          Text(
            'MYR ${amount.toStringAsFixed(2)}',
            style: TextStyle(
              color: isTotal ? Colors.orange : Colors.white,
              fontSize: 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PaymentOptionPage()), // Navigate to Payment Options
          );
        },
        child: const Text(
          'Payment',
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
