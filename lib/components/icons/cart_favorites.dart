import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CartFavoritesIcon extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final VoidCallback? onTap;

  const CartFavoritesIcon({
    super.key,
    this.width = 32,
    this.height = 32,
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
<svg width="32" height="32" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg">
  <mask id="mask0_456_976" style="mask-type:luminance" maskUnits="userSpaceOnUse" x="1" y="3" width="30" height="26">
    <path d="M25.9999 21.3333H8.66659L5.33325 8H29.3333L25.9999 21.3333Z" fill="#555555"/>
    <path d="M2 4H4.33333L5.33333 8M5.33333 8L8.66667 21.3333H26L29.3333 8H5.33333Z" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
    <path d="M8.66675 28C9.77132 28 10.6667 27.1046 10.6667 26C10.6667 24.8954 9.77132 24 8.66675 24C7.56218 24 6.66675 24.8954 6.66675 26C6.66675 27.1046 7.56218 28 8.66675 28Z" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
    <path d="M26 28C27.1046 28 28 27.1046 28 26C28 24.8954 27.1046 24 26 24C24.8954 24 24 24.8954 24 26C24 27.1046 24.8954 28 26 28Z" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
    <path d="M14.6667 14.6667H20.0001M17.3334 17.3333V12" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
  </mask>
  <g mask="url(#mask0_456_976)">
    <path d="M0 0H32V32H0V0Z" fill="currentColor"/>
  </g>
</svg>
  ''';
}
