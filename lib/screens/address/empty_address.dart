import 'package:flutter/material.dart';
import 'package:project/widgets/sidebar/siderbar.dart';
import 'package:project/components/icons/address.dart'; // Import the AddressIcon
import 'package:go_router/go_router.dart'; // GoRouter importu

class EmptyAddressPage extends StatelessWidget {
  const EmptyAddressPage({Key? key}) : super(key: key);

  static const String routeName = '/address/empty'; // Define route name

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Sidebar(),
          Positioned(
            left: 480, // Adjust based on Sidebar width
            top: 320, // Adjust top padding to match React version pt-[320px]
            right: 160, // Adjust right padding pr-[160px]
            child: Center(
              child: Container(
                width: 835, // Fixed width
                height: 250, // Fixed height
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300, // Equivalent to #D9D9D9
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Stack(
                  // Use Stack for absolute positioning like React
                  children: [
                    // Address icon
                    Positioned(
                      left: 10,
                      top: 48,
                      child: AddressIcon(
                        width: 64,
                        height: 64,
                        color: Colors.red, // #FF0000
                      ),
                    ),

                    // Error message
                    Positioned(
                      left: 80,
                      top: 36,
                      child: Text(
                        "Saved address not found",
                        style: TextStyle(
                          fontFamily:
                              'Inter', // Assuming Inter font is available
                          fontSize: 64,
                          color: Colors.red, // #FF0000
                        ),
                      ),
                    ),

                    // Add new address button
                    Positioned(
                      left: 262,
                      top: 153,
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to the add new address page
                          context.go(
                            '/address/new',
                          ); // GoRouter ile değiştirildi
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(
                            320,
                            55,
                          ), // w-[320px] h-[55px]
                          backgroundColor: const Color(0xFF00EEFF),
                          foregroundColor: Colors.black,
                          textStyle: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 32,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          // Add hover effect if needed
                        ),
                        child: const Text("Add new address"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
