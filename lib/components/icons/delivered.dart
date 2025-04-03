import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DeliveredIcon extends StatelessWidget {
  final double width;
  final double height;
  final VoidCallback? onTap;

  const DeliveredIcon({
    super.key,
    this.width = 32,
    this.height = 32,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final svgIcon = SvgPicture.string(svgString, width: width, height: height);

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(width / 2),
        child: svgIcon,
      );
    }

    return svgIcon;
  }

  static const String svgString = '''
<svg width="32" height="32" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M16 30C23.732 30 30 23.732 30 16C30 8.26801 23.732 2 16 2C8.26801 2 2 8.26801 2 16C2 23.732 8.26801 30 16 30Z" fill="#4CAF50"/>
<path d="M23.0666 9.7334L13.9999 18.8001L10.2666 15.0667L8.3999 16.9334L13.9999 22.5334L24.9332 11.6001L23.0666 9.7334Z" fill="#CCFF90"/>
</svg>
  ''';
}
