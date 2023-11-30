import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

final Uri _url = Uri.parse('mailto:support@billy.com?subject=Support&body=My problem is ');


class ContactUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Us'),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(236, 144, 5, 100),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 150.0,
                child: Image.asset('assets/images/logo@3x.png'),
              ),
              SizedBox(height: 32.0),
              Text(
                'Contact Us',
                style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey[800],
                ),
              ),
              SizedBox(height: 32.0),
              Text(
                'If you have any questions or feedback, please reach out to us at:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 32.0),
              TextButton(
                onPressed: _launchUrl,
                child: Text(
                  'support@billy.com',
                  style: TextStyle(
                    fontSize: 24.0,
                    color: Color.fromRGBO(236, 144, 5, 100),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }
}
Future<void> _launchUrl() async {
  if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
}