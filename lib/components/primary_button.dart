import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final Widget child;
  final Gradient gradient;
  final double width;
  final double height;
  final Function onPressed;
  final bool isEnabled;
  final Color bgColor;

  const PrimaryButton(
      {Key key,
      @required this.child,
      this.gradient,
      this.width = double.infinity,
      this.height = 50.0,
      this.onPressed,
      this.isEnabled = true,
      this.bgColor = Colors.white})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: isEnabled
          ? BoxDecoration(
            color: this.bgColor,
              borderRadius: BorderRadius.all(Radius.circular(10)))
          : BoxDecoration(
              color: Color(0xFFE1E1E1),
              borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
            onTap: isEnabled
                ? (){
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
