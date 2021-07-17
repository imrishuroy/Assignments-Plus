import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUs extends StatelessWidget {
  static const String routeName = '/contact-us';
  const ContactUs({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (_) => ContactUs(),
    );
  }

  Future<void> _openEmail() async {
    await launch('mailto:rishukumar.prince@gmail.com?body=Hello there !');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Contact Us'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                _openEmail();
              },
              child: Text('Email Us'),
            ),
          ),
        ],
      ),
    );
  }
}
