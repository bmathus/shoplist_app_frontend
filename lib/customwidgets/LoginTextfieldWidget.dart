import 'package:flutter/material.dart';

//custom widget textfieldow ktore pouzivame pri logine
class TextFieldWidget extends StatelessWidget {
  final String hintText;
  final IconData leftIcon;
  final IconData? rightIcon;
  final bool hideText;
  final Function(String)? onCh;
  final TextEditingController controller;

  TextFieldWidget({
    required this.hintText,
    required this.leftIcon,
    this.rightIcon,
    required this.hideText,
    this.onCh,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onCh,
      obscureText: hideText,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
      ),
      cursorColor: Color(0xFF355C7D),
      decoration: InputDecoration(
        prefixIcon: Icon(
          leftIcon,
          size: 18,
          color: Color(0xFF355C7D),
        ),
        labelText: hintText,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF355C7D)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF355C7D)),
        ),
        filled: true,
        suffixIcon: Icon(
          rightIcon,
          size: 18,
          color: Color(0xFF355C7D),
        ),
        labelStyle: const TextStyle(color: Colors.white),
        focusColor: Color(0xFF355C7D),
      ),
    );
  }
}
