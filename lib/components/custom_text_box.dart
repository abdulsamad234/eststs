import 'package:flutter/material.dart';
import 'package:estats/styleguide/colors.dart';

class CustomTextBox extends StatelessWidget {
  final String placeholderText;
  final Color borderColor;
  final Color textColor;
  final bool required;
  final bool same;
  final String password;
  final Color placeholderColor;
  final String errorText;
  final Color textboxBackgroundColor;
  final TextEditingController controller;
  final bool obscureText;
  final FocusNode focusNode;
  final bool enabled;
  final TextInputType keyboardType;
  final Widget child;
  final Function onChanged;
  CustomTextBox(
      {this.focusNode,
      this.placeholderText,
      this.borderColor = darkBGColor,
      this.textColor = Colors.white,
      this.placeholderColor = placeHolderColor,
      this.textboxBackgroundColor = darkBGColor,
      this.controller,
      this.errorText = 'Field cannot be left empty',
      this.required = false,
      this.same = false,
      this.password,
      this.enabled = true,
      this.obscureText = false,
      this.child,
      this.keyboardType = TextInputType.text,
      this.onChanged});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: textboxBackgroundColor),
      child: Stack(
        children: <Widget>[
          TextFormField(
            onChanged: onChanged,
            enabled: enabled,
            focusNode: focusNode,
            keyboardType: keyboardType,
            obscureText: obscureText,
            validator: (value) {
              if (value.isEmpty && required) {
                return errorText;
              } else if (same && password != null) {
                print("Value is: $value");
                print("Password is: $password");
                if (value != password) {
                  return 'Must be same as password';
                }
              }
              return null;
            },
            style: TextStyle(color: textColor, fontWeight: FontWeight.w400),
            controller: controller,
            decoration: InputDecoration(
                fillColor: Colors.green,
                contentPadding:
                    new EdgeInsets.symmetric(vertical: 12, horizontal: 20.0),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: borderColor, width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: borderColor, width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: borderColor, width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: borderColor, width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                hintText: placeholderText,
                hintStyle: TextStyle(
                    color: placeholderColor, fontWeight: FontWeight.w400)),
          ),
          child == null ? Container() : child
        ],
      ),
    );
  }
}
