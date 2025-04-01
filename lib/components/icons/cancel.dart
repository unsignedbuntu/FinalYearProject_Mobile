import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CancelIcon extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final VoidCallback? onTap;

  const CancelIcon({
    Key? key,
    this.width = 24,
    this.height = 24,
    this.color = Colors.black,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final svgIcon = SvgPicture.string(
      svgString,
      width: width,
      height: height,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );

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
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M18 6L6 18" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M6 6L18 18" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
  ''';
}
