import 'package:flutter/material.dart';

class CrispyTextField extends StatelessWidget {
  const CrispyTextField(
      {super.key,
      required this.controller,
      this.onChanged,
      this.validator,
      required this.label});

  final String label;
  final TextEditingController controller;

  final void Function(String?)? onChanged;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: controller,
        onChanged: onChanged,
        validator: validator,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          label: Text(label),
        ));
  }
}
