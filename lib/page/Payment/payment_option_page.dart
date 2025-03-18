import 'package:flutter/material.dart';
import 'package:quantocube/page/Payment/ewallet_payment_page.dart';
import 'package:quantocube/page/Payment/ewallet_selection_page.dart';

class PaymentOptionPage extends StatelessWidget {
  const PaymentOptionPage({super.key});

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
        title: const Text('Select your Payment Option',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPaymentOption(context, 'E-Wallet', Icons.account_balance_wallet, () {
             Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const EWalletSelectionPage()),
);

            }),
            _buildPaymentOption(context, 'Credit / Debit Card', Icons.credit_card, () {
              // Future Implementation
            }),
            _buildPaymentOption(context, 'Online Banking', Icons.account_balance, () {
              // Future Implementation
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.orange),
        title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.orange, size: 16),
        onTap: onTap,
      ),
    );
  }
}
