import 'package:flutter/material.dart';
import 'package:trai_new_ui/responsive/ts.dart';

class ResponsiveCardContainer extends StatelessWidget {
  const ResponsiveCardContainer({super.key});

  // Helper method to get responsive dimensions based on screen size
  double _getResponsiveDimension(BuildContext context, double defaultSize) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 600) {
      return defaultSize * 0.8; // Mobile
    } else if (screenWidth < 1200) {
      return defaultSize * 1.0; // Tablet
    } else {
      return defaultSize * 1.2; // Desktop
    }
  }

  // Helper method to get responsive font size
  double _getResponsiveFontSize(BuildContext context, double defaultSize) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 600) {
      return defaultSize * 0.9;
    } else if (screenWidth < 1200) {
      return defaultSize;
    } else {
      return defaultSize * 1.1;
    }
  }

  // Helper method to get responsive padding
  EdgeInsets _getResponsivePadding(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 600) {
      return const EdgeInsets.all(16.0);
    } else if (screenWidth < 1200) {
      return const EdgeInsets.all(24.0);
    } else {
      return const EdgeInsets.all(32.0);
    }
  }

  Widget _cardContainer(BuildContext context) {
    // Get responsive dimensions
    double cardWidth = _getResponsiveDimension(context, 350);
    double cardHeight = _getResponsiveDimension(context, 280);
    double iconSize = _getResponsiveDimension(context, 48);

    return Container(
      width: cardWidth,
      constraints: const BoxConstraints(
        maxWidth: 600, // Maximum width for larger screens
        minWidth: 280, // Minimum width for smaller screens
      ),
      height: cardHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: _getResponsivePadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: iconSize,
                height: iconSize,
                decoration: BoxDecoration(
                  color: const Color(0xFF4C6EF5),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  Icons.chat_bubble_outline,
                  color: Colors.white,
                  size: iconSize * 0.5,
                ),
              ),
            ),
            SizedBox(height: _getResponsiveDimension(context, 24)),
            Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed suscipit nunc sit amet elit gravida.",
              style: Ts.bold16(color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: Center(
            child: _cardContainer(context),
          ),
        );
      },
    );
  }
}
