import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TicIcon extends StatelessWidget {
  final double width;
  final double height;
  final Color backgroundColor;
  final Color strokeColor;
  final VoidCallback? onTap;

  const TicIcon({
    super.key,
    this.width = 24,
    this.height = 24,
    this.backgroundColor = Colors.white,
    this.strokeColor = Colors.black,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final String svgString = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <circle cx="12" cy="12" r="10" fill="${_colorToHex(backgroundColor)}" stroke="${_colorToHex(strokeColor)}" stroke-width="2"/>
  <path d="M7 12L10 15L17 8" stroke="${_colorToHex(strokeColor)}" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
''';

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

  String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2)}';
  }
}
