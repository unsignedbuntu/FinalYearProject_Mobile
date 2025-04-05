import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// İkon importlarınız (Bunların flutter_svg kullandığını varsayıyoruz)

import 'package:project/components/icons/index.dart';
// Sayfa importlarınız
import 'package:project/screens/auth/sign_in_page.dart';
import 'package:project/screens/auth/sign_up_page.dart';
import 'package:project/screens/user_info/user_info_page.dart';
import 'package:project/screens/my_reviews/my_reviews_page.dart';
import 'package:project/screens/orders/my_orders_page.dart';

class SignInOverlay extends StatefulWidget {
  final bool isOpen;
  final VoidCallback onClose;

  const SignInOverlay({super.key, required this.isOpen, required this.onClose});

  @override
  State<SignInOverlay> createState() => _SignInOverlayState();
}

class _SignInOverlayState extends State<SignInOverlay> {
  String? _hoveredItem;

  @override
  Widget build(BuildContext context) {
    if (!widget.isOpen) return const SizedBox.shrink();

    final Size screenSize = MediaQuery.of(context).size;
    const Color hoverBorderColor = Color(0xFF9747FF);
    const Color hoverTextColor = Color(0xFF9747FF);
    final Color hoverBackgroundColor = Colors.grey.shade100;
    final Color defaultTextColor = Colors.black87;
    final Color menuBackgroundColor = Colors.white.withOpacity(
      0.85,
    ); // Biraz daha opak yaptım, isterseniz 0.75'e dönebilirsiniz

    return Positioned.fill(
      child: Material(
        color: Colors.transparent,
        child: GestureDetector(
          onTap: widget.onClose,
          child: Container(
            width: screenSize.width,
            height: screenSize.height,
            color: Colors.transparent,
            child: Stack(
              children: [
                Positioned(
                  top: 160.0, // Sabit pozisyon
                  left: 1000.0, // Sabit pozisyon
                  child: GestureDetector(
                    onTap: () {}, // Menü içine tıklamanın kapanmasını engelle
                    child: Container(
                      width: 350.0,
                      height: 460.0,
                      // Stack'in dışına taşan üçgeni göstermek için Clip.none
                      clipBehavior: Clip.none,
                      child: Stack(
                        children: [
                          // Üçgen Gösterge (Triangle Indicator)
                          Positioned(
                            top:
                                -8, // Üçgenin yüksekliğinin yarısı kadar yukarı
                            left:
                                (350 / 2) -
                                8, // Konteynerin ortasına hizala (üçgen genişliğinin yarısı kadar sola kaydır)
                            child: Transform.rotate(
                              angle: 45 * 3.1415926535 / 180, // 45 derece
                              child: Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: menuBackgroundColor,
                                  // Gölgeyi sadece üste vermek için ayarlama (isteğe bağlı)
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 4,
                                      offset: const Offset(
                                        -1,
                                        -1,
                                      ), // Gölgeyi yukarı ve sola kaydırır gibi
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // Ana Menü Kartı
                          // Positioned.fill yerine doğrudan Container kullandık çünkü Stack'in boyutları zaten belli.
                          Container(
                            // Üçgenin arkasında kalması için padding ekleyebiliriz veya stack'te sıralama yaparız.
                            // Şimdilik böyle bırakalım, üçgen zaten üstte.
                            decoration: BoxDecoration(
                              color: menuBackgroundColor,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0), // p-4
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceAround, // space-y-4 approx
                                children: [
                                  _buildMenuItem(
                                    context: context,
                                    icon: VectorIcon(width: 72, height: 45),
                                    iconContainerWidth: 90,
                                    title: 'Sign In',
                                    route: SignInPage.routeName,
                                    hoverBorderColor: hoverBorderColor,
                                    hoverTextColor: hoverTextColor,
                                    hoverBackgroundColor: hoverBackgroundColor,
                                    defaultTextColor: defaultTextColor,
                                  ),
                                  _buildMenuItem(
                                    context: context,
                                    icon: SignupIcon(width: 90, height: 70),
                                    iconContainerWidth: 90,
                                    title: 'Sign Up',
                                    route: SignUpPage.routeName,
                                    hoverBorderColor: hoverBorderColor,
                                    hoverTextColor: hoverTextColor,
                                    hoverBackgroundColor: hoverBackgroundColor,
                                    defaultTextColor: defaultTextColor,
                                  ),
                                  _buildMenuItem(
                                    context: context,
                                    icon: UserInfSidebarIcon(
                                      width: 65,
                                      height: 52,
                                    ),
                                    iconContainerWidth: 90,
                                    title: 'User Information',
                                    route: UserInfoPage.routeName,
                                    hoverBorderColor: hoverBorderColor,
                                    hoverTextColor: hoverTextColor,
                                    hoverBackgroundColor: hoverBackgroundColor,
                                    defaultTextColor: defaultTextColor,
                                  ),
                                  _buildMenuItem(
                                    context: context,
                                    icon: MyReviewsIcon(width: 70, height: 45),
                                    iconContainerWidth: 90,
                                    title: 'My Reviews',
                                    route: MyReviewsPage.routeName,
                                    hoverBorderColor: hoverBorderColor,
                                    hoverTextColor: hoverTextColor,
                                    hoverBackgroundColor: hoverBackgroundColor,
                                    defaultTextColor: defaultTextColor,
                                  ),
                                  _buildMenuItem(
                                    context: context,
                                    icon: OrderIcon(width: 60, height: 60),
                                    iconContainerWidth: 90,
                                    title: 'My Orders',
                                    route: MyOrdersPage.routeName,
                                    hoverBorderColor: hoverBorderColor,
                                    hoverTextColor: hoverTextColor,
                                    hoverBackgroundColor: hoverBackgroundColor,
                                    defaultTextColor: defaultTextColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required Widget icon,
    required double iconContainerWidth,
    required String title,
    required String route,
    required Color hoverBorderColor,
    required Color hoverTextColor,
    required Color hoverBackgroundColor,
    required Color defaultTextColor,
  }) {
    bool isHovered = _hoveredItem == title;
    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredItem = title),
      onExit: (_) => setState(() => _hoveredItem = null),
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: () {
          widget.onClose();
          context.go(route);
        },
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: isHovered ? hoverBackgroundColor : Colors.transparent,
            borderRadius: BorderRadius.circular(8.0),
            border:
                isHovered
                    ? Border.all(color: hoverBorderColor, width: 2)
                    : null,
          ),
          child: Row(
            children: [
              Container(
                width: iconContainerWidth,
                alignment: Alignment.center,
                child: Theme(
                  data: Theme.of(context).copyWith(
                    iconTheme: IconTheme.of(context).copyWith(color: null),
                  ),
                  child: icon,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: isHovered ? hoverTextColor : defaultTextColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
