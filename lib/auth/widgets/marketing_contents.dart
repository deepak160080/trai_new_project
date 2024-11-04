import 'package:flutter/material.dart';
import 'package:trai_new_ui/auth/responsive_card.dart';
import 'package:trai_new_ui/responsive/ts.dart';

class MarketingContent extends StatelessWidget {
  final bool isCompact;

  const MarketingContent({super.key, this.isCompact = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Lorem ipsum dolor sit amet.",
          style: Ts.bold20(),
        ),
        const SizedBox(height: 20),
        const ResponsiveCardContainer(),
        const SizedBox(height: 20),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          child: Text(
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed suscipit nunc sit amet elit gravida.",
            style: Ts.bold16(),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}