import 'package:flutter/material.dart';
import 'dart:async';
import 'package:project/components/icons/visible.dart';
import 'package:project/components/icons/unvisible.dart';
import 'package:project/components/layouts/sign_in_layout.dart';
import 'package:go_router/go_router.dart';

class SignupSuccessMessage extends StatelessWidget {
  final VoidCallback onClose;

  const SignupSuccessMessage({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 50),
            const SizedBox(height: 16),
            const Text(
              'Signed up successfully!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'You will be redirected to the home page shortly.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onClose,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB4D4FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('OK', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  static const String routeName = '/register'; // Define route name

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool showSuccessMessage = false;

  // Form fields
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> errors = {};

  String firstName = '';
  String lastName = '';
  String email = '';
  String birthDay = '';
  String birthMonth = '';
  String birthYear = '';
  String phoneNumber = '';
  String password = '';
  String confirmPassword = '';

  // Generate arrays for day, month, and year dropdowns
  List<int> get days => List.generate(31, (index) => index + 1);
  List<String> get months => [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];
  List<int> get years {
    final currentYear = DateTime.now().year;
    return List.generate(100, (index) => currentYear - index);
  }

  bool validateForm() {
    if (_formKey.currentState!.validate()) {
      return true;
    }
    return false;
  }

  void handleSignUp() {
    if (validateForm()) {
      setState(() {
        showSuccessMessage = true;
      });

      Timer(const Duration(seconds: 3), () {
        context.go('/');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SignInLayout(
      child: Stack(
        children: [
          // Background Image
          Image.asset(
            'assets/images/Sign.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),

          // Content
          SingleChildScrollView(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 50),

                  // Logo
                  GestureDetector(
                    onTap: () => context.go('/'),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/images/MyLogo.png',
                        width: 100,
                        height: 100,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Title
                  const Text(
                    "Create a new account",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFFFFF99),
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Form
                  Form(
                    key: _formKey,
                    child: SizedBox(
                      width: 400,
                      child: Column(
                        children: [
                          // First Name
                          TextFormField(
                            onChanged: (value) {
                              setState(() {
                                firstName = value;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'First name',
                              hintStyle: TextStyle(
                                color: Colors.black.withOpacity(0.7),
                              ),
                              filled: true,
                              fillColor: const Color(0xFFB4D4FF),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                            ),
                            style: const TextStyle(color: Colors.black),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'First name is required';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 16),

                          // Last Name
                          TextFormField(
                            onChanged: (value) {
                              setState(() {
                                lastName = value;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'Last name',
                              hintStyle: TextStyle(
                                color: Colors.black.withOpacity(0.7),
                              ),
                              filled: true,
                              fillColor: const Color(0xFFB4D4FF),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                            ),
                            style: const TextStyle(color: Colors.black),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Last name is required';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 16),

                          // Email
                          TextFormField(
                            onChanged: (value) {
                              setState(() {
                                email = value;
                              });
                            },
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: 'Email',
                              hintStyle: TextStyle(
                                color: Colors.black.withOpacity(0.7),
                              ),
                              filled: true,
                              fillColor: const Color(0xFFB4D4FF),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                            ),
                            style: const TextStyle(color: Colors.black),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Email is required';
                              }
                              if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                                return 'Invalid email format';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 16),

                          // Birth Date Row
                          Row(
                            children: [
                              // Day
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: const Color(0xFFB4D4FF),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 14,
                                    ),
                                  ),
                                  hint: const Text(
                                    'Day',
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                  value: birthDay.isNotEmpty ? birthDay : null,
                                  items:
                                      days.map((day) {
                                        return DropdownMenuItem<String>(
                                          value: day.toString(),
                                          child: Text(day.toString()),
                                        );
                                      }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      birthDay = value ?? '';
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Required';
                                    }
                                    return null;
                                  },
                                ),
                              ),

                              const SizedBox(width: 8),

                              // Month
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: const Color(0xFFB4D4FF),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 14,
                                    ),
                                  ),
                                  hint: const Text(
                                    'Month',
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                  value:
                                      birthMonth.isNotEmpty ? birthMonth : null,
                                  items:
                                      months.map((month) {
                                        return DropdownMenuItem<String>(
                                          value: month,
                                          child: Text(month),
                                        );
                                      }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      birthMonth = value ?? '';
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Required';
                                    }
                                    return null;
                                  },
                                ),
                              ),

                              const SizedBox(width: 8),

                              // Year
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: const Color(0xFFB4D4FF),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 14,
                                    ),
                                  ),
                                  hint: const Text(
                                    'Year',
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                  value:
                                      birthYear.isNotEmpty ? birthYear : null,
                                  items:
                                      years.map((year) {
                                        return DropdownMenuItem<String>(
                                          value: year.toString(),
                                          child: Text(year.toString()),
                                        );
                                      }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      birthYear = value ?? '';
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Required';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Phone Number
                          TextFormField(
                            onChanged: (value) {
                              setState(() {
                                phoneNumber = value;
                              });
                            },
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              hintText: 'Phone number',
                              hintStyle: TextStyle(
                                color: Colors.black.withOpacity(0.7),
                              ),
                              filled: true,
                              fillColor: const Color(0xFFB4D4FF),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                            ),
                            style: const TextStyle(color: Colors.black),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Phone number is required';
                              }
                              if (value.startsWith('0')) {
                                return 'Please enter your phone number without the leading zero';
                              }
                              if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                                return 'Phone number must be 10 digits';
                              }
                              return null;
                            },
                          ),

                          const Padding(
                            padding: EdgeInsets.only(top: 4, left: 8),
                            child: Text(
                              'Please enter your phone number without the leading zero.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Password
                          TextFormField(
                            onChanged: (value) {
                              setState(() {
                                password = value;
                              });
                            },
                            obscureText: !isPasswordVisible,
                            decoration: InputDecoration(
                              hintText: 'Password',
                              hintStyle: TextStyle(
                                color: Colors.black.withOpacity(0.7),
                              ),
                              filled: true,
                              fillColor: const Color(0xFFB4D4FF),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              suffixIcon: IconButton(
                                icon:
                                    isPasswordVisible
                                        ? const VisibleIcon(
                                          color: Colors.black,
                                          width: 20,
                                          height: 20,
                                        )
                                        : const UnvisibleIcon(
                                          color: Colors.black,
                                          width: 20,
                                          height: 20,
                                        ),
                                onPressed: () {
                                  setState(() {
                                    isPasswordVisible = !isPasswordVisible;
                                  });
                                },
                              ),
                            ),
                            style: const TextStyle(color: Colors.black),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password is required';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 16),

                          // Confirm Password
                          TextFormField(
                            onChanged: (value) {
                              setState(() {
                                confirmPassword = value;
                              });
                            },
                            obscureText: !isConfirmPasswordVisible,
                            decoration: InputDecoration(
                              hintText: 'Confirm password',
                              hintStyle: TextStyle(
                                color: Colors.black.withOpacity(0.7),
                              ),
                              filled: true,
                              fillColor: const Color(0xFFB4D4FF),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              suffixIcon: IconButton(
                                icon:
                                    isConfirmPasswordVisible
                                        ? const VisibleIcon(
                                          color: Colors.black,
                                          width: 20,
                                          height: 20,
                                        )
                                        : const UnvisibleIcon(
                                          color: Colors.black,
                                          width: 20,
                                          height: 20,
                                        ),
                                onPressed: () {
                                  setState(() {
                                    isConfirmPasswordVisible =
                                        !isConfirmPasswordVisible;
                                  });
                                },
                              ),
                            ),
                            style: const TextStyle(color: Colors.black),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm your password';
                              }
                              if (value != password) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 24),

                          // Sign Up Button
                          SizedBox(
                            width: 300,
                            height: 75,
                            child: ElevatedButton(
                              onPressed: handleSignUp,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF8EE7ED),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                              ),
                              child: const Text(
                                'Sign up',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 36,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Sign In Link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Already have an account? ",
                                style: TextStyle(color: Colors.white),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, '/signin');
                                },
                                child: const Text(
                                  'Sign in',
                                  style: TextStyle(
                                    color: Color(0xFFB4D4FF),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 50),

                  // Promotional Messages
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '🎉 Welcome! Special 15% Discount Opportunity for New Members 🎉',
                                style: TextStyle(
                                  color: Color(0xFF00FF85),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Become a Member Quickly!',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'We are happy that you have joined us! You can benefit from the 15% discount opportunity on all products, exclusively for our new members. Don\'t miss this advantage!',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'How to Benefit?',
                                style: TextStyle(
                                  color: Color(0xFF00FF85),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '1. Sign Up: If you are not a member yet, quickly log in.',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '2. Start Shopping: Add the products you like to your cart.',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '3. Enter the code KTUN15 and the 15% discount will be applied instantly.',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Terms and Conditions: Discount code is valid for new memberships and first purchases only.',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),

          // Success Message
          if (showSuccessMessage)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: SignupSuccessMessage(
                    onClose: () {
                      setState(() {
                        showSuccessMessage = false;
                      });
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
