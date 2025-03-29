import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ArrowdownIcon extends StatelessWidget {
  final double width;
  final double height;
  final Color? color;
  final Function()? onTap;

  const ArrowdownIcon({
    super.key,
    this.width = 13,
    this.height = 8,
    this.color,
    this.onTap,
  });

  static const String svgString = '''
<svg 
  width="13" 
  height="8" 
  viewBox="0 0 13 8" 
  fill="none" 
  xmlns="http://www.w3.org/2000/svg"
>
  <path 
    d="M1 1L6.5 6L12 1" 
    stroke="currentColor" 
    strokeWidth="2" 
    strokeLinecap="round"
  />
</svg>
''';

  @override
  Widget build(BuildContext context) {
    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        child: SvgPicture.string(
          svgString,
          width: width,
          height: height,
          colorFilter:
              color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
        ),
      );
    }

    return SvgPicture.string(
      svgString,
      width: width,
      height: height,
      colorFilter:
          color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
    );
  }
}
