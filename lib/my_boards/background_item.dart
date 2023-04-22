import 'package:flutter/material.dart';

class BackgroundItem extends StatelessWidget {
  final String value;
  final String text;
  final String image;

  const BackgroundItem({
    Key? key, 
    required this.value,
    required this.text,
    required this.image,
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          'assets/images/background/$image',
          height: 100,
          width: 100,
        ),
        const SizedBox(width: 8.0),
        Text(text),
      ],
    );
  }
}
