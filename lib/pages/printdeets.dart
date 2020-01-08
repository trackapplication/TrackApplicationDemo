import 'package:flutter/material.dart';

class printdeets extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(MediaQuery.of(context).size.height.toString()),
      ),
    );
  }
}
