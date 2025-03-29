import 'package:flutter/material.dart';
import 'package:project/components/icons/user_icon.dart';
import 'package:project/components/icons/group_team_hover.dart';
import 'package:project/components/icons/arrowdown.dart';
import 'package:project/components/icons/arrowdown_hover.dart';

class SignInButton extends StatefulWidget {
  final VoidCallback? onTap;
  final bool isSelected;

  const SignInButton({super.key, this.onTap, this.isSelected = false});

  @override
  State<SignInButton> createState() => _SignInButtonState();
}

class _SignInButtonState extends State<SignInButton> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      onHover: (hovering) {
        setState(() {
          _isHovering = hovering;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 182,
        height: 58,
        decoration: BoxDecoration(
          color:
              _isHovering ? const Color(0xFF7ee569) : const Color(0xFF8CFF75),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            // Icon
            Positioned(
              left: 16,
              top: 0,
              bottom: 0,
              child: Center(
                child:
                    _isHovering
                        ? const GroupTeamHoverIcon(width: 34, height: 38)
                        : const UserIcon(width: 24, height: 24),
              ),
            ),

            // Text
            Positioned(
              left: 56,
              top: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TextStyle(
                      fontSize: _isHovering ? 23 : 20,
                      color:
                          _isHovering ? const Color(0xFF792AE8) : Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                    child: const Text("Sign in"),
                  ),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TextStyle(
                      fontSize: _isHovering ? 23 : 20,
                      color:
                          _isHovering ? const Color(0xFF792AE8) : Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                    child: const Text("or sign up"),
                  ),
                ],
              ),
            ),

            // Arrow
            Positioned(
              right: 12,
              top: 0,
              bottom: 0,
              child: Center(
                child:
                    _isHovering
                        ? const ArrowdownHoverIcon(width: 32, height: 38)
                        : const ArrowdownIcon(
                          width: 13,
                          height: 8,
                          color: Colors.black,
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
