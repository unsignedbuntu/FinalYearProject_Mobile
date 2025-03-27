import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TicketLineIcon extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final VoidCallback? onTap;

  const TicketLineIcon({
    super.key,
    this.width = 100,
    this.height = 2,
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
<svg width="100" height="2" viewBox="0 0 100 2" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M0 1H100" stroke="currentColor" stroke-width="2" stroke-dasharray="4 4"/>
</svg>
  ''';
}
