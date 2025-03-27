import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CartMainIcon extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final VoidCallback? onTap;

  const CartMainIcon({
    super.key,
    this.width = 63,
    this.height = 42,
    this.color = Colors.black,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final svgIcon = SvgPicture.string(svgString, width: width, height: height);

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: svgIcon,
      );
    }

    return svgIcon;
  }

  static const String svgString = '''
<svg width="63" height="42" viewBox="0 0 63 42" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M26.9062 35.5211C29.4433 35.5211 31.5 34.1635 31.5 32.4888C31.5 30.8141 29.4433 29.4565 26.9062 29.4565C24.3692 29.4565 22.3125 30.8141 22.3125 32.4888C22.3125 34.1635 24.3692 35.5211 26.9062 35.5211Z" fill="#792AE8"/>
<path d="M41.3438 35.5211C43.8808 35.5211 45.9375 34.1635 45.9375 32.4888C45.9375 30.8141 43.8808 29.4565 41.3438 29.4565C38.8067 29.4565 36.75 30.8141 36.75 32.4888C36.75 34.1635 38.8067 35.5211 41.3438 35.5211Z" fill="#792AE8"/>
<path fillRule="evenodd" clipRule="evenodd" d="M19.3725 10.3947L44.7116 10.367C47.0452 10.3653 49.2581 11.0445 50.757 12.2227C52.2559 13.4027 52.8859 14.9605 52.479 16.4749L50.6048 23.4353C49.9354 25.9166 46.6672 27.7238 42.8505 27.7238H25.3811C21.5749 27.7238 18.3146 25.927 17.6348 23.4561L13.9519 10.0863C13.7235 9.26327 12.6368 8.66372 11.3689 8.66372H5.25C3.801 8.66372 2.625 7.88745 2.625 6.93098C2.625 5.97451 3.801 5.19824 5.25 5.19824H11.3689C15.1751 5.19824 18.4354 6.99511 19.1152 9.466L19.3725 10.3947Z" fill="#792AE8"/>
</svg>
  ''';
}
