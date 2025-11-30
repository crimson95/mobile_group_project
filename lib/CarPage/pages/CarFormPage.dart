import 'package:flutter/material.dart';

class CarFormPage extends StatefulWidget {
  const CarFormPage({super.key});

  @override
  State<CarFormPage> createState() => _CarFormPageState();
}

class _CarFormPageState extends State<CarFormPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController makeController = TextEditingController();
  final TextEditingController modelController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add New Car")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Title
            const Text(
              "Car Title",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter car title",
              ),
            ),
            const SizedBox(height: 16),

            // 2. Year
            const Text(
              "Year",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: yearController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter year (e.g. 2020)",
              ),
            ),
            const SizedBox(height: 16),

            // 3. Make
            const Text(
              "Make",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: makeController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter make (e.g. Toyota)",
              ),
            ),
            const SizedBox(height: 16),

            // 4. Model
            const Text(
              "Model",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: modelController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter model (e.g. Corolla)",
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _onSavePressed,
                child: const Text("Save Car"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
