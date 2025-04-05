import 'package:flutter/material.dart';
import 'package:project/components/icons/favorite_icon.dart';
import 'package:go_router/go_router.dart';

class EmptyFavorites extends StatelessWidget {
  const EmptyFavorites({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 835,
        height: 300,
        color: const Color(0xFFD9D9D9),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FavoriteIcon(width: 64, height: 72, color: Color(0xFFFF0000)),
            const SizedBox(height: 24),
            const Text(
              "There are no products in\nmy favorites list yet.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 48,
                fontWeight: FontWeight.normal,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 32),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  context.go('/products');
                },
                child: Stack(
                  children: [
                    Container(
                      width: 354,
                      height: 74,
                      decoration: BoxDecoration(
                        color: const Color(0xFF00EEFF),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    Positioned.fill(
                      child: Center(
                        child: Text(
                          "Start shopping now and add your favorite products!",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 24,
                            fontWeight: FontWeight.normal,
                            color: Color(0xFFFF0000),
                          ),
                        ),
                      ),
                    ),
                    MouseRegion(
                      onEnter: (_) {
                        // Hover efekti - burada setState ile renk değişimi yapılabilir
                        // Stateful Widget kullanılarak
                      },
                      onExit: (_) {
                        // Hover'dan çıkınca eski renge dönülür
                      },
                      child: Positioned.fill(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              context.go('/products');
                            },
                            borderRadius: BorderRadius.circular(15),
                            hoverColor: const Color(
                              0xFF2F00FF,
                            ).withOpacity(0.9),
                            splashColor: const Color(
                              0xFF2F00FF,
                            ).withOpacity(0.7),
                            child: Container(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
