import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MenuIcon extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final VoidCallback? onTap;

  const MenuIcon({
    super.key,
    this.width = 24,
    this.height = 24,
    this.color = Colors.black,
    this.onTap,
  });

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
<mask id="mask0_558_1042" style="mask-type:luminance" maskUnits="userSpaceOnUse" x="3" y="5" width="18" height="14">
<path d="M3 5H21V7H3V5ZM3 11H21V13H3V11ZM3 17H21V19H3V17Z" fill="white"/>
</mask>
<g mask="url(#mask0_558_1042)">
<path d="M0 0H24V24H0V0Z" fill="currentColor"/>
</g>
</svg>
  ''';
}
