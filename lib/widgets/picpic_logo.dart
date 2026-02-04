import 'package:flutter/material.dart';

class PicPicLogo extends StatelessWidget {
  final double size;
  final bool showText;

  const PicPicLogo({
    super.key,
    this.size = 200.0,
    this.showText = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          // Top circle
          Positioned(
            top: size * 0.0,
            left: size * 0.375,
            child: Container(
              width: size * 0.25,
              height: size * 0.25,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
                border: Border.all(
                  color: Colors.white.withOpacity(0.95),
                  width: size * 0.04, // Thick outline
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: size * 0.05,
                    offset: Offset(0, size * 0.02),
                  ),
                ],
              ),
            ),
          ),
          // Bottom left circle
          Positioned(
            top: size * 0.5,
            left: size * 0.125,
            child: Container(
              width: size * 0.25,
              height: size * 0.25,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
                border: Border.all(
                  color: Colors.white.withOpacity(0.95),
                  width: size * 0.04, // Thick outline
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: size * 0.05,
                    offset: Offset(0, size * 0.02),
                  ),
                ],
              ),
            ),
          ),
          // Bottom right circle
          Positioned(
            top: size * 0.5,
            left: size * 0.625,
            child: Container(
              width: size * 0.25,
              height: size * 0.25,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
                border: Border.all(
                  color: Colors.white.withOpacity(0.95),
                  width: size * 0.04, // Thick outline
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: size * 0.05,
                    offset: Offset(0, size * 0.02),
                  ),
                ],
              ),
            ),
          ),
          // App name below logo
          if (showText)
            Positioned(
              top: size * 0.85,
              left: size * 0.25,
              child: Text(
                'PicPic',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size * 0.12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class MistyBackground extends StatelessWidget {
  final Widget child;

  const MistyBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF4A5568), // Misty gray-blue
            Color(0xFF2D3748), // Darker misty gray
            Color(0xFF1A202C), // Very dark misty gray
          ],
        ),
      ),
      child: child,
    );
  }
}
