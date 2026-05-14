import 'package:flutter/material.dart';
import 'package:sixvalley_delivery_boy/utill/dimensions.dart';

class CustomDividerWidget extends StatelessWidget {
  final double height;
  final Color color;
  const CustomDividerWidget({super.key, this.height = 1, this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = Dimensions.dashWidth;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal, children: List.generate(dashCount, (_) {
            return SizedBox(width: dashWidth, height: dashHeight,
              child: DecoratedBox(decoration: BoxDecoration(color: color)));
          }));
      },
    );
  }
}