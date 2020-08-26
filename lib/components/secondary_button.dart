import 'package:estats/styleguide/colors.dart';
import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  final Widget child;
  final Gradient gradient;
  final double width;
  final double height;
  final Function onPressed;
  final bool isEnabled;
  final Color borderColor;
  final bool isSelected;

  const SecondaryButton(
      {Key key,
      @required this.child,
      this.gradient,
      this.width = double.infinity,
      this.height = 50.0,
      this.onPressed,
      this.isEnabled = true,
      this.isSelected = false,
      this.borderColor = whiteColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: isEnabled
          ? BoxDecoration(
            color: this.isSelected ? borderColor :Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              border: Border.all(color: borderColor, width: 0.8))
          : BoxDecoration(
              color: Color(0xFFE1E1E1),
              borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Material(
        color: 
         Colors.transparent,
        child: InkWell(
            onTap: isEnabled
                ? () {
                    onPressed(context);
                  }
                : () {
                    // print('pressed');
                  },
            child: Center(
              child: child,
            )),
      ),
    );
  }
}
