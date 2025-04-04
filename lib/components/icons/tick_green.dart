import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TickGreenIcon extends StatelessWidget {
  final double width;
  final double height;
  final VoidCallback? onTap;

  const TickGreenIcon({
    super.key,
    this.width = 26,
    this.height = 26,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final svgIcon = SvgPicture.string(svgString, width: width, height: height);

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13),
        child: svgIcon,
      );
    }

    return svgIcon;
  }

  static const String svgString = '''
<svg width="26" height="26" viewBox="0 0 26 26" fill="none" xmlns="http://www.w3.org/2000/svg">
  <circle cx="13" cy="13" r="13" fill="#5AD363"/>
  <path fillRule="evenodd" clipRule="evenodd" d="M22.54 5.37842C23.1038 5.92626 23.1565 6.87397 22.6583 7.49779L12.2014 20.4939C12.0806 20.644 11.9337 20.766 11.7693 20.8526C11.605 20.9393 11.4265 20.9888 11.2444 20.9983C11.0623 21.0078 10.8803 20.9771 10.7092 20.908C10.5381 20.8389 10.3814 20.7327 10.2482 20.5959L3.4285 13.598C3.16614 13.3261 3.01234 12.9512 3.00071 12.555C2.98908 12.1589 3.12057 11.7738 3.36643 11.4839C3.6123 11.1941 3.95254 11.023 4.31278 11.0082C4.67303 10.9933 5.02398 11.1358 5.28891 11.4046L11.0902 17.3428L20.6196 5.50639C20.7384 5.35862 20.8826 5.23807 21.0438 5.15164C21.2051 5.06522 21.3803 5.01461 21.5593 5.00273C21.7384 4.99084 21.9178 5.01791 22.0874 5.08237C22.2569 5.14684 22.4132 5.24745 22.5473 5.37842H22.54Z" fill="white"/>
</svg>
  ''';
}
