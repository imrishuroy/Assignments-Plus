import 'package:flutter/material.dart';

class EnterOtpScreen extends StatefulWidget {
  @override
  _EnterOtpScreenState createState() => _EnterOtpScreenState();
}

class _EnterOtpScreenState extends State<EnterOtpScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 21.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(),
              SizedBox(height: 20.0),
              ElevatedButton(onPressed: () {}, child: Text('Submit')),
              SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}
