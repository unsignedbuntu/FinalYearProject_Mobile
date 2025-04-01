import 'package:flutter/material.dart';

class MyReviewsIcon extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final VoidCallback? onTap;

  const MyReviewsIcon({
    super.key,
    this.width = 50,
    this.height = 38,
    this.color = Colors.black,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final iconWidget = Icon(
      Icons.rate_review,
      size: height * 0.8,
      color: color,
    );

    // onTap tanımlıysa InkWell ile sar
    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: SizedBox(
          width: width,
          height: height,
          child: Center(child: iconWidget),
        ),
      );
    }

    return SizedBox(
      width: width,
      height: height,
      child: Center(child: iconWidget),
    );
  }
}
