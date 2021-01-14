import 'package:flutter/material.dart';

class UniqInputIconField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final bool isObscure;
  final String hintText, labelText;
  final IconData inputIcon, suffixIcon;
  final Color color;
  final double fieldRounding;
  final TextEditingController controller;
  final Function(String) validator;
  const UniqInputIconField(
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
      style: Theme.of(context).textTheme.bodyText2,
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
