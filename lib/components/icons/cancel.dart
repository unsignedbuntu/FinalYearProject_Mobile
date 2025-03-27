import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CancelIcon extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final VoidCallback? onTap;

  const CancelIcon({
    super.key,
    this.width = 32,
    this.height = 32,
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
<svg width="32" height="32" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path opacity="0.3" d="M16.0002 5.33331C10.1202 5.33331 5.3335 10.12 5.3335 16C5.3335 21.88 10.1202 26.6666 16.0002 26.6666C21.8802 26.6666 26.6668 21.88 26.6668 16C26.6668 10.12 21.8802 5.33331 16.0002 5.33331ZM22.6668 20.7866L20.7868 22.6666L16.0002 17.88L11.2135 22.6666L9.3335 20.7866L14.1202 16L9.3335 11.2133L11.2135 9.33331L16.0002 14.12L20.7868 9.33331L22.6668 11.2133L17.8802 16L22.6668 20.7866Z" fill="black"/>
  <path d="M15.9998 2.66669C8.6265 2.66669 2.6665 8.62669 2.6665 16C2.6665 23.3734 8.6265 29.3334 15.9998 29.3334C23.3732 29.3334 29.3332 23.3734 29.3332 16C29.3332 8.62669 23.3732 2.66669 15.9998 2.66669ZM15.9998 26.6667C10.1198 26.6667 5.33317 21.88 5.33317 16C5.33317 10.12 10.1198 5.33335 15.9998 5.33335C21.8798 5.33335 26.6665 10.12 26.6665 16C26.6665 21.88 21.8798 26.6667 15.9998 26.6667ZM20.7865 9.33335L15.9998 14.12L11.2132 9.33335L9.33317 11.2134L14.1198 16L9.33317 20.7867L11.2132 22.6667L15.9998 17.88L20.7865 22.6667L22.6665 20.7867L17.8798 16L22.6665 11.2134L20.7865 9.33335Z" fill="black"/>
</svg>
  ''';
}
