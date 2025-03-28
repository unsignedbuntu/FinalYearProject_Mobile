import 'package:flutter/material.dart';

class SignInLayout extends StatelessWidget {
  final Widget child;

  const SignInLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: child,
      ),
    );
  }
}
