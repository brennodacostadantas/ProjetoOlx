import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputCustomizado extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final TextInputType type;
  final int? maxLines;
  final bool autofocus;
  final List<TextInputFormatter>? inputFormaters;
  final FormFieldValidator<String>? validator;
  final FormFieldValidator<String>? onSaved;

  const InputCustomizado(
      {required this.controller,
      this.type = TextInputType.text,
      this.obscure = false,
      this.autofocus = false,
      required this.hint,
      this.inputFormaters,
      this.maxLines = 1,
      this.validator,
      this.onSaved,
      super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      autofocus: autofocus,
      keyboardType: type,
      inputFormatters: inputFormaters,
      validator: validator,
      maxLines: maxLines,
      onSaved: onSaved,
      style:  const TextStyle(fontSize: 20),
      decoration: InputDecoration(
          contentPadding:  const EdgeInsets.fromLTRB(32, 16, 32, 16),
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(6))),
    );
  }
}
