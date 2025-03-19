import 'package:flutter/material.dart';

class AddLineItemPage extends StatefulWidget {
  @override
  _AddLineItemPageState createState() => _AddLineItemPageState();
}

class _AddLineItemPageState extends State<AddLineItemPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _serviceTypeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _unitPriceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, {
        'serviceType': _serviceTypeController.text,
        'description': _descriptionController.text,
        'unitPrice': double.parse(_unitPriceController.text),
        'quantity': int.parse(_quantityController.text),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _serviceTypeController,
                  decoration: const InputDecoration(labelText: 'Service Type'),
                  validator: (value) =>
                      value!.isEmpty ? 'Enter service type' : null,
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                TextFormField(
                  controller: _unitPriceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Unit Price'),
                  validator: (value) =>
                      value!.isEmpty ? 'Enter unit price' : null,
                ),
                TextFormField(
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Quantity'),
                  validator: (value) =>
                      value!.isEmpty ? 'Enter quantity' : null,
                ),
                const SizedBox(height: 16),
                ElevatedButton(onPressed: _submit, child: const Text("Add")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
