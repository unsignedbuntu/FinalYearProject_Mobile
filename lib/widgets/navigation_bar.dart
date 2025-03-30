import 'package:flutter/material.dart';
import 'package:project/components/icons/tic_icon.dart';
import 'package:project/components/icons/tic_hover.dart';
import 'package:project/widgets/megamenu/stores_megamenu.dart';

class NavigationBar extends StatefulWidget {
  const NavigationBar({super.key});

  @override
  State<NavigationBar> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  // Hover durumlarını izleme
  final Map<String, bool> _hoverStates = {
    'stores': false,
    'loyalty': false,
    'ktungpt': false,
    'support': false,
  };

  @override
  Widget build(BuildContext context) {
    // Ekran görüntüsünde belirtilen tam konumda tutuyorum
    return Positioned(
      top: 64,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Stores
              _buildNavButton(
                text: 'Stores',
                hoverKey: 'stores',
                width: 180,
                onTap: () {
                  // Megamenu açma işlemi
                },
                showCheck: true,
              ),

              const SizedBox(width: 62),

              // Loyalty Program
              _buildNavButton(
                text: 'Loyalty Program',
                hoverKey: 'loyalty',
                width: 240,
                onTap: () {
                  Navigator.pushNamed(context, '/loyalty-program');
                },
                showCheck: true,
              ),

              const SizedBox(width: 62),

              // KtunGPT
              _buildNavButton(
                text: 'KtunGPT',
                hoverKey: 'ktungpt',
                width: 180,
                onTap: () {
                  Navigator.pushNamed(context, '/ktungpt');
                },
                showCheck: true,
              ),

              const SizedBox(width: 62),

              // Support
              _buildNavButton(
                text: 'Support',
                hoverKey: 'support',
                width: 180,
                onTap: () {
                  Navigator.pushNamed(context, '/support');
                },
                showCheck: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavButton({
    required String text,
    required String hoverKey,
    required double width,
    required VoidCallback onTap,
    bool showCheck = false,
  }) {
    final isHovering = _hoverStates[hoverKey] ?? false;

    // Ekran görüntüsündeki orijinal stil korundu
    return MouseRegion(
      onEnter: (_) => setState(() => _hoverStates[hoverKey] = true),
      onExit: (_) => setState(() => _hoverStates[hoverKey] = false),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 47,
          width: width,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(255, 255, 0, 0.35),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Stack(
            children: [
              // Text
              Center(
                child: Text(
                  text,
                  style: TextStyle(
                    fontFamily: 'Satisfy',
                    fontSize: isHovering ? 28 : 20,
                    color: isHovering ? const Color(0xFFFF0303) : Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              // Check icon if needed
              if (showCheck)
                Positioned(
                  right: 8,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child:
                        isHovering
                            ? const TicHoverIcon(width: 32, height: 32)
                            : const TicIcon(width: 36, height: 36),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
