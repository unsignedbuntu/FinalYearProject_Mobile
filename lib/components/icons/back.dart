import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BackIcon extends StatelessWidget {
  final double width;
  final double height;
  final Color? color;
  final Function()? onTap;

  static const String _svgString = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M15.0898 19.9201L8.56984 13.4001C7.79984 12.6301 7.79984 11.3701 8.56984 10.6001L15.0898 4.08008" stroke="#292D32" stroke-width="1.5" stroke-miterlimit="10" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
''';

  const BackIcon({
    super.key,
    this.width = 24,
    this.height = 24,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SvgPicture.string(
        _svgString,
        width: width,
        height: height,
        colorFilter:
            color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
      ),
    );
  }
}
