import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BigRoundTextField extends StatelessWidget {
  final TextEditingController controller;
  final String initialValue;
  final String hintText;
  final TextStyle hintStyle;
  final String labelText;
  final String errorText;
  final bool obscureText;
  final int maxLines;
  final TextInputType keyboardType;
  final Function validator;
  final TextInputAction textInputAction;
  final FocusNode focusNode;
  final Function onFieldSubmitted;
  final Function onChanged;
  final Function onTap;
  final bool enabled;
  final bool autofocus;
  final double marginTop;
  final double opacity;
  final int maxLength;
  final Color textColor;
  final List<TextInputFormatter> inputFormat;

  const BigRoundTextField({
    Key key,
    this.controller,
    this.initialValue,
    this.hintText,
    this.hintStyle,
    this.obscureText = false,
    this.maxLines = 1,
    this.keyboardType,
    this.validator,
    this.textInputAction,
    this.focusNode,
    this.onFieldSubmitted,
    this.onChanged,
    this.enabled,
    this.errorText,
    this.marginTop = 0,
    this.labelText,
    this.maxLength,
    this.opacity = 1,
    this.textColor = Colors.white,
    this.autofocus = false,
    this.inputFormat,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const border = OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.transparent, width: 0.0),
      borderRadius: const BorderRadius.all(const Radius.circular(5.0)),
    );
    return Opacity(
      opacity: opacity,
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width - 160,
        margin: EdgeInsets.only(top: marginTop),
        decoration: BoxDecoration(
            color: Color(0xff111111),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: TextFormField(
          controller: controller,
          inputFormatters: inputFormat,
          style: TextStyle(color: textColor),
          onTap: onTap,
          decoration: new InputDecoration(
            enabledBorder: border,
            disabledBorder: border,
            focusedBorder: border,
            errorBorder: border,
            focusedErrorBorder: border,
            filled: true,
            hintStyle:
                hintStyle ?? new TextStyle(color: const Color(0x88707070)),
            hintText: hintText,
            errorText: errorText,
            fillColor: const Color(0xff111111),
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
            labelText: labelText,
            labelStyle: new TextStyle(color: Color(0xffffffff)),
          ),
          buildCounter: (BuildContext context,
                  {int currentLength, int maxLength, bool isFocused}) =>
              null,
          maxLength: maxLength,
          initialValue: initialValue,
          textAlign: TextAlign.center,
          obscureText: obscureText,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          textInputAction: textInputAction,
          focusNode: focusNode,
          onFieldSubmitted: onFieldSubmitted,
          onChanged: onChanged,
          enabled: enabled,
          autofocus: autofocus,
        ),
      ),
    );
  }
}
