import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DeliveredIcon extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final VoidCallback? onTap;

  const DeliveredIcon({
    super.key,
    this.width = 40,
    this.height = 40,
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
<svg width="40" height="40" viewBox="0 0 40 40" fill="none" xmlns="http://www.w3.org/2000/svg">
<rect x="0.5" y="0.5" width="39" height="39" rx="19.5" fill="white"/>
<path d="M27.5306 15.4694L17.5306 25.4694L12.5306 20.4694" stroke="#2D9CDB" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
<rect x="0.5" y="0.5" width="39" height="39" rx="19.5" stroke="#2D9CDB"/>
</svg>
  ''';
}
