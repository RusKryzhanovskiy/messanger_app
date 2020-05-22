import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focus;
  final FocusNode nextFocus;
  final EdgeInsetsGeometry padding;
  final String hint;
  final bool obscureText;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final List<TextInputFormatter> formatter;
  final String Function(String value) validator;

  const CustomTextField({
    Key key,
    this.controller,
    this.focus,
    this.nextFocus,
    this.padding,
    this.hint,
    this.inputType,
    this.inputAction,
    this.formatter,
    this.obscureText = false,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: TextFormField(
        controller: controller,
        focusNode: focus,
        obscureText: obscureText,
        keyboardType: inputType,
        textInputAction: inputAction,
        inputFormatters: formatter,
        validator:validator,
        onEditingComplete: () {
          if (nextFocus != null) {
            FocusScope.of(context).requestFocus(nextFocus);
          }
        },
        decoration: InputDecoration(
          labelText: hint,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
