import 'package:flutter/material.dart';

class Notification extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          'Tarifs des voyages',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
        ),
      ),
      body: Center(child: Text("Notification Clicked")),
    );
  }
}
