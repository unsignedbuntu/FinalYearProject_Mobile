import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CouponIcon extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final VoidCallback? onTap;

  const CouponIcon({
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
<g clip-path="url(#clip0_1036_109)">
<path d="M19.95 10.5C19.825 10.1 19.825 9.7 19.95 9.3L20.875 6.55C21.075 6 20.75 5.4 20.15 5.25L17.3 4.575C16.9 4.475 16.575 4.225 16.35 3.875L14.65 1.375C14.3 0.875 13.625 0.75 13.125 1.1L10.825 2.6C10.475 2.825 10.075 2.9 9.675 2.825L6.875 2.25C6.275 2.15 5.725 2.55 5.675 3.175L5.375 6.075C5.325 6.475 5.125 6.825 4.825 7.1L2.575 9.125C2.125 9.525 2.1 10.2 2.525 10.65L4.675 13.025C4.95 13.325 5.075 13.725 5.025 14.125L4.6 17.025C4.5 17.65 4.95 18.2 5.55 18.25L8.475 18.35C8.875 18.375 9.25 18.575 9.5 18.9L11.525 21.3C11.925 21.775 12.6 21.825 13.075 21.425L15.4 19.425C15.725 19.15 16.125 19.025 16.525 19.05L19.425 19.25C20.05 19.3 20.6 18.85 20.65 18.25L20.75 15.325C20.775 14.925 20.95 14.55 21.25 14.275L23.525 12.175C24 11.75 24.025 11.075 23.575 10.625L21.55 8.5C21.275 8.2 21.075 7.875 21 7.475" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M12 12.5L12.5 12" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M7 8L7.5 7.5" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M17 17L17.5 16.5" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
</g>
<defs>
<clipPath id="clip0_1036_109">
<rect width="24" height="24" fill="white"/>
</clipPath>
</defs>
</svg>
  ''';
}
