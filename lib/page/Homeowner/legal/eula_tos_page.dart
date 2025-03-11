import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EulaTosScreen extends StatefulWidget {
  const EulaTosScreen({super.key});

  @override
  _EulaTosScreenState createState() => _EulaTosScreenState();
}

class _EulaTosScreenState extends State<EulaTosScreen> {
  Map<String, dynamic>? eulaTosData;

  @override
  void initState() {
    super.initState();
    loadJson();
  }

  Future<void> loadJson() async {
    String jsonString =
        await rootBundle.loadString('assets/legal/eula_tos.json');
    setState(() {
      eulaTosData = json.decode(jsonString);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 75,
        title: Text(
          eulaTosData?['title'] ?? 'Loading...',
          style: const TextStyle(color: Colors.white),
          maxLines: 3,
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: eulaTosData == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: eulaTosData!['sections'].length,
                itemBuilder: (context, index) {
                  var section = eulaTosData!['sections'][index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        section['header'],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        section['body'],
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                    ],
                  );
                },
              ),
            ),
    );
  }
}
