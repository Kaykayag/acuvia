import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SymptomInputScreen extends ConsumerStatefulWidget {
  final Map<String, bool> checklist;
  const SymptomInputScreen({super.key, required this.checklist});

  @override
  ConsumerState<SymptomInputScreen> createState() => _SymptomInputScreenState();
}

class _SymptomInputScreenState extends ConsumerState<SymptomInputScreen> {
  final controller = TextEditingController();
  bool listening = false;
  // Access checklist via widget.checklist

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
        title: const Text('Symptom Input'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: controller, decoration: const InputDecoration(labelText: 'Enter symptom')),
            const SizedBox(height: 12),
            Expanded(child: ListView(
              children: widget.checklist.keys.map((k) => CheckboxListTile(
                value: widget.checklist[k] ?? false,
                onChanged: (v) {
                  setState(() {
                    widget.checklist[k] = v ?? false;
                  });
                },
                title: Text(k),
              )).toList(),
            )),
          ],
        ),
      ),
    );
  }
}