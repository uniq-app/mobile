import 'package:flutter/material.dart';

class UniqInputField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final bool isObscure;
  final String hintText, labelText;
  final IconData inputIcon, suffixIcon;
  final Color cursorColor;
  final double fieldRounding;
  final int maxLength, maxLines;
  final TextEditingController controller;
  final Function(String) validator;
  final Function onEditingCompleted;
  final TextInputAction textInputAction;
  const UniqInputField({
    Key key,
    this.onChanged,
    this.isObscure = false,
    this.hintText,
    this.inputIcon,
    this.fieldRounding = 15.0,
    this.controller,
    this.validator,
    this.labelText,
    this.suffixIcon,
    this.maxLength,
    this.textInputAction,
    this.cursorColor,
    this.onEditingCompleted,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return TextFormField(
      maxLines: maxLines,
      textInputAction: textInputAction,
      obscureText: isObscure,
      onChanged: onChanged,
      controller: controller,
      style: Theme.of(context).textTheme.bodyText2,
      cursorColor: cursorColor,
      validator: validator,
      maxLength: maxLength,
      onEditingComplete: onEditingCompleted,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        labelText: labelText,
        hintText: hintText,
      ),
    );
  }
}
