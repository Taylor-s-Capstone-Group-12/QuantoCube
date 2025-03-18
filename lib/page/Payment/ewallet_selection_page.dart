import 'package:flutter/material.dart';
import 'package:quantocube/page/Payment/ewallet_payment_page.dart';

class EWalletSelectionPage extends StatelessWidget {
  const EWalletSelectionPage({super.key});

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
          'E-Wallet Payment',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          _buildEWalletOption(context, 'Touch \'n Go'),
        ],
      ),
    );
  }

  Widget _buildEWalletOption(BuildContext context, String ewalletName) {
    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(Icons.account_balance_wallet, color: Colors.orange),
        title: Text(ewalletName, style: const TextStyle(color: Colors.white, fontSize: 16)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.orange, size: 16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EWalletPaymentPage()),
          );
        },
      ),
    );
  }
}
