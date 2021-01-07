import 'package:flutter/material.dart';

class UniqInputField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final bool isObscure;
  final String hintText, labelText;
  final IconData inputIcon, suffixIcon;
  final Color color;
  final double fieldRounding;
  final int maxLength;
  final TextEditingController controller;
  final Function(String) validator;
  const UniqInputField(
      {Key key,
      this.onChanged,
      this.isObscure = false,
      this.hintText,
      this.inputIcon,
      this.color,
      this.fieldRounding = 15.0,
      this.controller,
      this.validator,
      this.labelText,
      this.suffixIcon,
      this.maxLength})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return TextFormField(
      obscureText: isObscure,
      onChanged: onChanged,
      controller: controller,
      cursorColor: Theme.of(context).primaryColor,
      validator: validator,
      maxLength: maxLength,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        labelText: labelText,
        hintText: hintText,
      ),
    );
  }
}
