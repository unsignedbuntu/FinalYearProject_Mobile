import 'package:flutter/material.dart';

class SignInOverlay extends StatelessWidget {
  final bool isOpen;
  final VoidCallback onClose;
  final LayerLink layerLink; // CompositedTransformFollower için LayerLink

  const SignInOverlay({
    Key? key,
    required this.isOpen,
    required this.onClose,
    required this.layerLink, // Yeni gerekli parametre
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ekran boyutunu al
    final Size screenSize = MediaQuery.of(context).size;

    return Material(
      color: Colors.transparent,
      child: Container(
        // Container tüm ekranı kapsıyor, böylece Stack için kesin boyut sağlanıyor
        width: screenSize.width,
        height: screenSize.height,
        child: Stack(
          // Stack içindeki tüm içerik Positioned widget'ları içinde olacak
          children: [
            // Tüm ekranı kaplayan saydam arka plan - dışarı tıklandığında kapanır
            Positioned.fill(
              child: GestureDetector(
                onTap: onClose,
                child: Container(color: Colors.transparent),
              ),
            ),

            // CompositedTransformFollower kullanarak menüyü SignInButton'a hizalama
            CompositedTransformFollower(
              link: layerLink, // Header'dan gelen LayerLink
              targetAnchor:
                  Alignment.bottomLeft, // Hedef (buton) alt sol köşesi
              followerAnchor:
                  Alignment.topLeft, // Takipçi (menü) üst sol köşesi
              offset: const Offset(0, 10), // Butonun 10px altına konumlandır
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Üçgen işaretçi
                  Positioned(
                    top: -10,
                    left: 30, // Üçgeni menünün sol tarafına yerleştir
                    child: Transform.rotate(
                      angle: 0.8,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Menü kartı - Kesin boyutlara sahip
                  Container(
                    width: 250,
                    // Burada yükseklik sınırlandırıldı
                    constraints: const BoxConstraints(
                      minHeight: 100,
                      maxHeight: 400, // Maksimum yükseklik sınırlandırıldı
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize:
                          MainAxisSize.min, // İçeriğe göre boyutlanacak
                      children: [
                        _buildMenuItem(
                          icon: Icons.login,
                          title: 'Sign in',
                          onTap: () {
                            Navigator.pushNamed(context, '/login');
                            onClose();
                          },
                        ),
                        _buildDivider(),
                        _buildMenuItem(
                          icon: Icons.person_add,
                          title: 'Sign up',
                          onTap: () {
                            Navigator.pushNamed(context, '/register');
                            onClose();
                          },
                        ),
                        _buildDivider(),
                        _buildMenuItem(
                          icon: Icons.person,
                          title: 'User Information',
                          onTap: () {
                            Navigator.pushNamed(context, '/profile');
                            onClose();
                          },
                        ),
                        _buildDivider(),
                        _buildMenuItem(
                          icon: Icons.star,
                          title: 'My Reviews',
                          onTap: () {
                            Navigator.pushNamed(context, '/reviews');
                            onClose();
                          },
                        ),
                        _buildDivider(),
                        _buildMenuItem(
                          icon: Icons.shopping_bag,
                          title: 'My Orders',
                          onTap: () {
                            Navigator.pushNamed(context, '/orders');
                            onClose();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Colors.black87),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, thickness: 1, color: Colors.grey[200]);
  }
}
