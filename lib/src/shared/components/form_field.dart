import 'package:flutter/material.dart';
import 'package:uniq/src/models/board.dart';

class UniqFormField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final TextEditingController controller;
  final bool isObscure;
  final String labelText, initialValue;
  final IconData inputIcon;
  final Color color;
  final double fieldRounding;
  final int maxLength;
  const UniqFormField({
    Key key,
    this.onChanged,
    this.isObscure = false,
    this.labelText,
    this.inputIcon,
    this.color,
    this.fieldRounding = 15.0,
    this.initialValue = "",
    this.controller,
    this.maxLength,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return TextFormField(
      maxLength: maxLength,
      controller: controller,
      obscureText: isObscure,
      onChanged: onChanged,
      cursorColor: Theme.of(context).primaryColor,
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: labelText,
      ),
    );
  }
}
