import 'package:flutter/material.dart';

class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key});

  @override
  Widget build(BuildContext context) {
        final textTheme = Theme.of(context).textTheme;
    const double circleSize = 35;
    return SizedBox(
      width: circleSize * 2,
      height: circleSize,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Container(
            width: circleSize,
            height: circleSize,
            decoration: const BoxDecoration(
              color: Color(0xFFFFB800),
              shape: BoxShape.circle,
            ),
          ),
          Positioned(
            left: circleSize * 0.25,
            child: Text(
              "Trai",
              style: textTheme.headlineLarge,
            ),
          ),
        ],
      ),
    );
  }
}