import 'package:flutter/material.dart';
import 'package:quantocube/page/Payment/payment_success_page.dart';

class TngPaymentPage extends StatelessWidget {
  const TngPaymentPage({super.key});

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
        title: const Text('TNG Payment',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            Image.asset('assets/icons/tng_qr_code.png', width: 200),
            const SizedBox(height: 20),
            const Text('Scan this QR with your TNG E-Wallet App',
                style: TextStyle(color: Colors.white, fontSize: 16)),
            const SizedBox(height: 30),
            _buildConfirmPaymentButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmPaymentButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PaymentSuccessPage()),
        );
      },
      child: const Text('I Have Paid',
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }
}
