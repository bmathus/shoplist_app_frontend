import 'package:flutter/material.dart';

//custom widget tectfieldov ktory pouzivame na obrazovkzch
class TextFieldWidget extends StatefulWidget {
  final String title;
  final String hintText;
  final TextEditingController controller;
  String? errorText;
  double top;
  double bottom;
  double left;
  double right;
  TextInputType keyboardType;

  TextFieldWidget(
      {required this.title,
      required this.hintText,
      required this.controller,
      this.errorText,
      this.top = 0,
      this.bottom = 0,
      this.left = 0,
      this.right = 0,
      this.keyboardType = TextInputType.text});

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.only(
        top: widget.top,
        bottom: widget.bottom,
        left: widget.left,
        right: widget.right,
      ),
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 59, 58, 58),
          border: Border.all(color: Colors.black26)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.title),
          TextField(
            keyboardType: widget.keyboardType,
            controller: widget.controller,
            style: TextStyle(fontSize: 14),
            cursorColor: Color(0xFF355C7D),
            decoration: InputDecoration(
              errorText: widget.errorText,
              hintText: widget.hintText,
              hintStyle: TextStyle(fontSize: 14),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
