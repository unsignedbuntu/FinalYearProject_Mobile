import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StoresIcon extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final VoidCallback? onTap;

  const StoresIcon({
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
<svg width="37" height="37" viewBox="0 0 37 37" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M32.3752 17.9539V32.375C32.3752 33.2264 31.685 33.9166 30.8335 33.9166H6.16683C5.3154 33.9166 4.62516 33.2264 4.62516 32.375V17.9539C3.66569 16.8669 3.0835 15.4388 3.0835 13.875V4.62498C3.0835 3.77355 3.77373 3.08331 4.62516 3.08331H32.3752C33.2266 3.08331 33.9168 3.77355 33.9168 4.62498V13.875C33.9168 15.4388 33.3347 16.8669 32.3752 17.9539ZM21.5835 13.875C21.5835 13.0235 22.2737 12.3333 23.1252 12.3333C23.9766 12.3333 24.6668 13.0235 24.6668 13.875C24.6668 15.5779 26.0472 16.9583 27.7502 16.9583C29.4531 16.9583 30.8335 15.5779 30.8335 13.875V6.16665H6.16683V13.875C6.16683 15.5779 7.54728 16.9583 9.25016 16.9583C10.953 16.9583 12.3335 15.5779 12.3335 13.875C12.3335 13.0235 13.0237 12.3333 13.8752 12.3333C14.7266 12.3333 15.4168 13.0235 15.4168 13.875C15.4168 15.5779 16.7972 16.9583 18.5002 16.9583C20.2031 16.9583 21.5835 15.5779 21.5835 13.875Z" fill="currentColor"/>
</svg>
  ''';
}
