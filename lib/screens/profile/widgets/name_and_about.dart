import 'package:flutter/material.dart';

class NameAndAbout extends StatelessWidget {
  final String? name;
  final String? about;

  const NameAndAbout({
    Key? key,
    required this.name,
    required this.about,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('About --- $about');
    return Column(
      children: [
        Text(
          '${name ?? ''}',
          style: TextStyle(
            fontSize: 19.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22.0),
          child: Text(
            '${about ?? ''}',
            style: TextStyle(
              fontSize: 14.0,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
