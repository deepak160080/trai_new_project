import 'package:flutter/material.dart';

class Textfield extends StatelessWidget {
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final String text;

  const Textfield({
    super.key,
    required this.text,
    this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final inputDecorationTheme = Theme.of(context).inputDecorationTheme;
    final textheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
    Text(
        text,
          style: textheme.bodyLarge
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: text,
            hintStyle: inputDecorationTheme.hintStyle,
            filled: true,
            fillColor: inputDecorationTheme.fillColor,
            contentPadding: inputDecorationTheme.contentPadding,
            border: inputDecorationTheme.border,
            enabledBorder: inputDecorationTheme.enabledBorder,
            focusedBorder: inputDecorationTheme.focusedBorder,
        
          ))
      ],
    );
  }
}