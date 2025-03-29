import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CartHoverIcon extends StatelessWidget {
  final double width;
  final double height;
  final Color? color;
  final Function()? onTap;

  const CartHoverIcon({
    super.key,
    this.width = 24,
    this.height = 24,
    this.color,
    this.onTap,
  });

  static const String svgString = '''
<svg width="39" height="36" viewBox="0 0 39 36" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M14.9373 30.75C16.6286 30.75 17.9998 29.5747 17.9998 28.125C17.9998 26.6753 16.6286 25.5 14.9373 25.5C13.2459 25.5 11.8748 26.6753 11.8748 28.125C11.8748 29.5747 13.2459 30.75 14.9373 30.75Z" fill="#792AE8"/>
  <path d="M24.5623 30.75C26.2536 30.75 27.6248 29.5747 27.6248 28.125C27.6248 26.6753 26.2536 25.5 24.5623 25.5C22.8709 25.5 21.4998 26.6753 21.4998 28.125C21.4998 29.5747 22.8709 30.75 24.5623 30.75Z" fill="#792AE8"/>
  <path fillRule="evenodd" clipRule="evenodd" d="M9.91475 8.99849L26.8075 8.9745C28.3632 8.973 29.8385 9.56098 30.8378 10.581C31.837 11.6025 32.257 12.951 31.9857 14.262L30.7363 20.2875C30.29 22.4355 28.1112 24 25.5667 24H13.9205C11.383 24 9.20951 22.4445 8.75626 20.3055L6.30101 8.73152C6.14876 8.01902 5.42426 7.5 4.57901 7.5H0.499756C-0.466244 7.5 -1.25024 6.828 -1.25024 6C-1.25024 5.172 -0.466244 4.5 0.499756 4.5H4.57901C7.11651 4.5 9.29 6.05552 9.74325 8.19452L9.91475 8.99849Z" fill="#792AE8"/>
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
