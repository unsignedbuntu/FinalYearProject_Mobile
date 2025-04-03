import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TicketIcon extends StatelessWidget {
  final double width;
  final double height;
  final VoidCallback? onTap;

  const TicketIcon({
    super.key,
    this.width = 380,
    this.height = 180,
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
<svg 
  width="380" 
  height="180" 
  viewBox="0 0 380 180" 
  fill="none" 
  xmlns="http://www.w3.org/2000/svg"
>
  <path 
    d="M0 20C0 8.95431 8.95431 0 20 0H360C371.046 0 380 8.95431 380 20V160C380 171.046 371.046 180 360 180H20C8.95431 180 0 171.046 0 160V20Z" 
    fill="#FF9D00"
  />
</svg>
  ''';
}
