import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final Color color;
  final Color textColor;
  final double width;
  final double height;
  final EdgeInsetsGeometry padding;

  const CustomButton({
    Key key,
    @required this.title,
    @required this.onTap,
    this.color,
    this.textColor,
    this.width,
    this.height,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: RaisedButton(
        onPressed: onTap,
        child: Container(
          width: width,
          height: height,
          child: Center(
            child: Text(
              title.toUpperCase(),
              style: TextStyle(color: textColor),
            ),
          ),
        ),
        color: color ?? Theme.of(context).primaryColor,
      ),
    );
  }
}
