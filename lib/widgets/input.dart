import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:poultry_classify/constants.dart';

class Input extends StatefulWidget {
  final String labelText;
  final TextEditingController controller;
  final bool obscureText;
  const Input({
    super.key,
    required this.labelText,
    required this.controller,
    this.obscureText = false,
  });

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  bool obscureText = false;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.obscureText && obscureText,
      decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: TextStyle(
            color: primaryColor,
            fontSize: 18.spMin,
          ),
          suffixIcon: widget.obscureText
              ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      obscureText = !obscureText;
                    });
                  },
                )
              : null),
    );
  }
}
