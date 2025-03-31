import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TicHoverIcon extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final VoidCallback? onTap;

  const TicHoverIcon({
    super.key,
    this.width = 24,
    this.height = 24,
    this.color = Colors.red,
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
<svg width="42" height="32" viewBox="0 0 42 32" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M22 -8C18.0444 -8 14.1776 -6.82702 10.8886 -4.62939C7.59962 -2.43177 5.03617 0.691807 3.52242 4.34633C2.00867 8.00085 1.6126 12.0222 2.3843 15.9018C3.15601 19.7814 5.06082 23.3451 7.85787 26.1421C10.6549 28.9392 14.2186 30.844 18.0982 31.6157C21.9778 32.3874 25.9991 31.9913 29.6537 30.4776C33.3082 28.9638 36.4318 26.4004 38.6294 23.1114C40.827 19.8224 42 15.9556 42 12C41.9944 6.69739 39.8855 1.61356 36.136 -2.13595C32.3864 -5.88547 27.3026 -7.9944 22 -8ZM30.7808 8.47307L20.0115 19.2423C19.8687 19.3853 19.699 19.4988 19.5122 19.5762C19.3255 19.6537 19.1253 19.6935 18.9231 19.6935C18.7209 19.6935 18.5207 19.6537 18.3339 19.5762C18.1472 19.4988 17.9775 19.3853 17.8346 19.2423L13.2192 14.6269C12.9306 14.3382 12.7684 13.9467 12.7684 13.5385C12.7684 13.1302 12.9306 12.7387 13.2192 12.45C13.5079 12.1613 13.8994 11.9991 14.3077 11.9991C14.716 11.9991 15.1075 12.1613 15.3962 12.45L18.9231 15.9788L28.6038 6.29615C28.7468 6.15321 28.9165 6.03983 29.1032 5.96247C29.29 5.88511 29.4902 5.8453 29.6923 5.8453C29.8945 5.8453 30.0946 5.88511 30.2814 5.96247C30.4681 6.03983 30.6378 6.15321 30.7808 6.29615C30.9237 6.43909 31.0371 6.60878 31.1145 6.79554C31.1918 6.9823 31.2316 7.18247 31.2316 7.38461C31.2316 7.58676 31.1918 7.78693 31.1145 7.97368C31.0371 8.16044 30.9237 8.33014 30.7808 8.47307Z" fill="#FF0000"/>
</svg>
  ''';
}
