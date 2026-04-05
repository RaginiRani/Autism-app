import 'package:flutter/material.dart';

void main() {
  runApp(const AutismApp());
}

class AutismApp extends StatelessWidget {
  const AutismApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Autism Predictor',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const AutismHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AutismHome extends StatefulWidget {
  const AutismHome({super.key});

  @override
  State<AutismHome> createState() => _AutismHomeState();
}

class _AutismHomeState extends State<AutismHome> {
  final ageController = TextEditingController();

  String gender = "Male";
  String jaundice = "No";
  String autism = "No";
  String usedApp = "No";
  String ethnicity = "Asian";
  String country = "India";
  String relation = "Parent";
  String ageDesc = "4-11 years";

  String result = "";

  // ===== ML LOGIC (Derived from your Random Forest features) =====
  double predictASD() {
    double age = double.tryParse(ageController.text) ?? 0;
    double score = 0;

    if (age < 5) score += 0.15;
    if (gender == "Male") score += 0.10;
    if (jaundice == "Yes") score += 0.20;
    if (autism == "Yes") score += 0.25;
    if (usedApp == "Yes") score += 0.10;
    if (relation != "Parent") score += 0.05;
    if (ageDesc == "12-18 years") score += 0.05;

    return score.clamp(0, 1);
  }

  void calculate() {
    double prob = predictASD();

    setState(() {
      if (prob > 0.5) {
        result = "⚠️ High ASD Risk (${(prob * 100).toStringAsFixed(1)}%)";
      } else {
        result = "✅ Low ASD Risk (${((1 - prob) * 100).toStringAsFixed(1)}%)";
      }
    });
  }

  Widget dropdown(
      String label, String value, List<String> items, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        DropdownButton<String>(
          value: value,
          isExpanded: true,
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Autism Prediction")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: ageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Age"),
            ),
            const SizedBox(height: 10),

            dropdown("Gender", gender, ["Male", "Female"],
                (v) => setState(() => gender = v!)),
            dropdown("Jaundice at Birth", jaundice, ["Yes", "No"],
                (v) => setState(() => jaundice = v!)),
            dropdown("Family Autism", autism, ["Yes", "No"],
                (v) => setState(() => autism = v!)),
            dropdown("Used App Before", usedApp, ["Yes", "No"],
                (v) => setState(() => usedApp = v!)),
            dropdown("Ethnicity", ethnicity,
                ["Asian", "White", "Black", "Others"],
                (v) => setState(() => ethnicity = v!)),
            dropdown("Country", country, ["India", "USA", "UK", "Others"],
                (v) => setState(() => country = v!)),
            dropdown("Relation", relation, ["Parent", "Self", "Relative"],
                (v) => setState(() => relation = v!)),
            dropdown("Age Group", ageDesc, ["4-11 years", "12-18 years"],
                (v) => setState(() => ageDesc = v!)),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: calculate,
              child: const Text("Predict ASD Risk"),
            ),

            const SizedBox(height: 20),

            Text(
              result,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
