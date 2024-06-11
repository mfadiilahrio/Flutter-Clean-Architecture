import 'package:flutter/material.dart';

class SyncPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sync'),
      ),
      body: Center(
        child: Text(
          'Offline Data',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}