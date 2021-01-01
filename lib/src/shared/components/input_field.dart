import 'package:flutter/material.dart';

class UniqInputField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final bool isObscure;
  final String hintText, initialValue;
  final IconData inputIcon;
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
      this.validator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.symmetric(horizontal: 5),
      width: size.width * 0.8,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(fieldRounding),
      ),
      child: TextFormField(
        obscureText: isObscure,
        onChanged: onChanged,
        controller: controller,
        cursorColor: Theme.of(context).primaryColor,
        initialValue: initialValue,
        validator: validator,
        decoration: InputDecoration(
          hintText: hintText,
          icon: Icon(
            inputIcon,
            color: Theme.of(context).primaryColor,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
