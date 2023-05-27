import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;

  const ButtonWidget({
    Key? key,
    required this.text,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>SizedBox(
    width: MediaQuery.of(context).size.width * 1,
    height: 55,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        backgroundColor: Colors.blue[900],
      ),
      onPressed: onClicked,
      child: Text(text),
    ),
  ) ;
}
