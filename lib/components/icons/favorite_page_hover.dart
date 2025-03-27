import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FavoritePageHoverIcon extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final VoidCallback? onTap;

  const FavoritePageHoverIcon({
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
  <rect width="24" height="24" rx="8" fill="#FF4E8F" fill-opacity="0.1"/>
  <path d="M12 19.7501C11.794 19.7501 11.592 19.6871 11.43 19.5631C10.635 18.9411 9.872 18.3581 9.189 17.8361L9.186 17.8331C7.604 16.5931 6.264 15.5341 5.319 14.5171C4.266 13.3761 3.75 12.2881 3.75 11.1101C3.75 9.9731 4.219 8.9341 5.047 8.1771C5.887 7.4061 7.018 6.9931 8.212 6.9931C9.1 6.9931 9.917 7.2531 10.631 7.7661C11.006 8.0241 11.346 8.3471 11.644 8.7221C11.943 8.3471 12.283 8.0241 12.658 7.7661C13.372 7.2531 14.189 6.9931 15.077 6.9931C16.271 6.9931 17.402 7.4061 18.242 8.1771C19.07 8.9341 19.539 9.9731 19.539 11.1101C19.539 12.2881 19.023 13.3761 17.97 14.5171C17.025 15.5341 15.685 16.5931 14.103 17.8331L14.101 17.8351C13.418 18.3581 12.654 18.9421 11.858 19.5651C11.696 19.6871 11.495 19.7501 12 19.7501ZM8.212 8.4381C7.336 8.4381 6.522 8.7501 5.921 9.3031C5.307 9.8681 4.969 10.6381 4.969 11.1101C4.969 11.9871 5.377 12.7951 6.227 13.7271C7.111 14.6761 8.421 15.7111 9.968 16.9221L9.971 16.9251C10.656 17.4481 11.423 18.0341 12.228 18.6631C13.034 18.0321 13.802 17.4471 14.488 16.9231C16.036 15.7111 17.345 14.6761 18.229 13.7271C19.079 12.7951 19.487 11.9871 19.487 11.1101C19.487 10.6381 19.149 9.8681 18.534 9.3031C17.935 8.7501 17.12 8.4381 16.244 8.4381C15.583 8.4381 14.968 8.6301 14.429 9.0061C13.942 9.3451 13.591 9.7701 13.358 10.1581C13.238 10.3571 13.025 10.4761 12.791 10.4761C12.557 10.4761 12.344 10.3571 12.224 10.1581C11.992 9.7701 11.641 9.3451 11.153 9.0061C10.614 8.6301 9.999 8.4381 9.338 8.4381H8.212Z" fill="#FF4E8F"/>
</svg>
  ''';
}
