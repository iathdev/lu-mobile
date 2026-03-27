import 'package:flutter/material.dart';

class FolderDetailPage extends StatelessWidget {
  final String id;
  const FolderDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FolderDetailPage')),
      body: Center(child: Text('FolderDetailPage — id: $id')),
    );
  }
}
