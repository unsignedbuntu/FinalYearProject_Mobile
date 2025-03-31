import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project/widgets/sidebar/siderbar.dart';

// Define colors and fonts for clarity
const Color emptyCartBg = Color(0xFFD9D9D9);
const Color emptyCartButtonBg = Color(0xFF00EEFF);
const Color emptyCartButtonHoverBg =
    Color(0xFF2F00FF); // Note: Hover is mainly web/desktop
const Color emptyCartButtonText = Colors.black;
const Color emptyCartButtonHoverText = Colors.white;
const String ralewayFont = 'Raleway';
const String interFont = 'Inter'; // Make sure Inter font is added

class EmptyCartPage extends StatelessWidget {
  const EmptyCartPage({super.key});

  static const String routeName = '/empty-cart'; // Example route name

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Using Stack for absolute positioning like the React example
      body: Stack(
        children: [
          // Sidebar positioned absolutely
          const Positioned(
            left: 47.0,
            top: 55.0,
            child: Sidebar(), // Assuming Sidebar is already created
          ),

          // Main content area positioned
          Positioned(
            // ml-[580px] mt-[160px] -> Use left/top for positioning
            left: 580.0,
            top: 160.0 +
                55.0, // Add sidebar's top offset if needed, or adjust based on app bar presence
            child: Container(
              // w-[835px] h-[250px] bg-[#D9D9D9] rounded-lg relative
              width: 835.0,
              height: 250.0,
              decoration: BoxDecoration(
                color: emptyCartBg,
                borderRadius: BorderRadius.circular(8.0), // rounded-lg
              ),
              // Using another Stack for absolute positioning inside the container
              child: Stack(
                children: [
                  // Cart Icon
                  Positioned(
                    left: 20.0, // left-5
                    top: 24.0, // top-6
                    child: SvgPicture.asset(
                      'assets/icons/cart_icon.svg', // *** Replace with your actual icon path ***
                      width: 64.0,
                      height: 64.0,
                    ),
                  ),

                  // Empty Cart Message
                  const Positioned(
                    // style={{ top: '20px', left: '93px' }}
                    top: 20.0,
                    left: 93.0,
                    child: Text(
                      "There are no products in your cart",
                      style: TextStyle(
                        fontFamily: ralewayFont,
                        fontSize: 48.0,
                        fontWeight: FontWeight.normal, // font-normal
                        color: Colors.black, // Assuming black text
                      ),
                    ),
                  ),

                  // Start Shopping Button
                  Positioned(
                    // style={{ top: '156px', left: '242px' }}
                    top: 156.0,
                    left: 242.0,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to home page
                        Navigator.pushNamedAndRemoveUntil(context, '/',
                            (route) => false); // Go to home and clear stack
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: emptyCartButtonBg,
                        foregroundColor: emptyCartButtonText, // Text color
                        minimumSize:
                            const Size(320.0, 54.0), // w-[320px] h-[54px]
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(15.0), // rounded-[15px]
                        ),
                        padding:
                            EdgeInsets.zero, // Remove default padding if needed
                        elevation: 0, // Remove shadow if needed
                        // Simulate hover effects using states if needed (more complex)
                      ),
                      child: const Text(
                        "Start shopping",
                        style: TextStyle(
                          fontFamily: interFont, // font-inter
                          fontSize: 32.0,
                          fontWeight: FontWeight.normal, // font-normal
                          // Color is handled by foregroundColor above
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
    );
  }
}
