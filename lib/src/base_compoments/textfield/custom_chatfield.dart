import 'package:flutter/material.dart';

class CustomChatField extends StatelessWidget {
  final String hint;
  final Function onChanged;
  final Color color;
  final TextInputType keyboardType;
  final TextEditingController controller;

  const CustomChatField({
    Key key,
    @required this.hint,
    @required this.onChanged,
    this.color = Colors.white,
    this.keyboardType = TextInputType.text,
    this.controller,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 20, 0),
      width: MediaQuery.of(context).size.width / 1.5,
      height: 30,
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.all(Radius.circular(20))),
      child: TextField(
        keyboardType: keyboardType,
        textAlign: TextAlign.right,
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration.collapsed(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            borderSide: BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
          ),
          hintText: '$hint',
        ),
      ),
    );
  }
}
