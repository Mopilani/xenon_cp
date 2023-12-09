import 'package:flutter/material.dart';

class KTextField extends StatelessWidget {
  const KTextField({
    Key? key,
    this.label,
    this.hint,
    this.onSubmitted,
    required this.controller,
  }) : super(key: key);
  final TextEditingController controller;
  final String? label;
  final String? hint;
  final void Function(String)? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        fillColor: Colors.black12,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
