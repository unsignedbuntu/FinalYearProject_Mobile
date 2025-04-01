import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CouponIcon extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final VoidCallback? onTap;

  const CouponIcon({
    super.key,
    this.width = 37,
    this.height = 37,
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
<svg width="37" height="37" viewBox="0 0 37 37" xmlns="http://www.w3.org/2000/svg">
  <path d="M3.09082 14.6453V6.16612C3.09082 5.31469 3.78106 4.62445 4.63249 4.62445H32.3825C33.234 4.62445 33.9242 5.31469 33.9242 6.16612V14.6453C31.7956 14.6453 30.07 16.3709 30.07 18.4995C30.07 20.6281 31.7956 22.3537 33.9242 22.3537V30.8328C33.9242 31.6842 33.234 32.3745 32.3825 32.3745H4.63249C3.78106 32.3745 3.09082 31.6842 3.09082 30.8328V22.3537C5.21941 22.3537 6.94499 20.6281 6.94499 18.4995C6.94499 16.3709 5.21941 14.6453 3.09082 14.6453ZM13.8825 13.8744V16.9578H23.1325V13.8744H13.8825ZM13.8825 20.0412V23.1245H23.1325V20.0412H13.8825Z" fill="currentColor"/>
</svg>
  ''';
}
