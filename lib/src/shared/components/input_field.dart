import 'package:flutter/material.dart';

class UniqInputField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final bool isObscure;
  final String hintText, initialValue, labelText;
  final IconData inputIcon, suffixIcon;
  final Color color;
  final double fieldRounding;
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
      this.initialValue,
      this.validator,
      this.labelText,
      this.suffixIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return TextFormField(
      obscureText: isObscure,
      onChanged: onChanged,
      controller: controller,
      cursorColor: Theme.of(context).primaryColor,
      initialValue: initialValue,
      validator: validator,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        labelText: labelText,
        hintText: hintText,
        prefixIcon: Icon(
          inputIcon,
          color: Theme.of(context).primaryColor,
        ),
        suffixIcon: Icon(
          suffixIcon,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
