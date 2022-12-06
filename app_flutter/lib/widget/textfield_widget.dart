import 'package:flutter/material.dart';

class TextFieldWidget extends StatefulWidget {
  final String label;

  const TextFieldWidget({
    Key? key,
    required this.label,
  }) : super(key: key);

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 23,
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
