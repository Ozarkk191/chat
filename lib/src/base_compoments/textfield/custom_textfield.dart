import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final Function onChanged;
  final Color color;
  final String errorText;
  final TextInputType keyboardType;
  final TextEditingController controller;

  const CustomTextField({
    Key key,
    @required this.hint,
    @required this.onChanged,
    this.color = Colors.white,
    this.errorText = '',
    this.keyboardType = TextInputType.text,
    this.controller,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.5,
      height: 60,
      child: TextField(
        keyboardType: keyboardType,
        textAlign: TextAlign.center,
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          errorText: errorText,
          filled: true,
          fillColor: color,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            borderSide: BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
          ),
          labelText: '$hint',
        ),
      ),
    );
  }
}
