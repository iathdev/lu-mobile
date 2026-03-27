import 'package:flutter/material.dart';

class VocabularyFormPage extends StatelessWidget {
  final String? editId;
  const VocabularyFormPage({super.key, this.editId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('VocabularyFormPage')),
      body: Center(child: Text('VocabularyFormPage — editId: $editId')),
    );
  }
}
