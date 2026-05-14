
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:sixvalley_delivery_boy/utill/dimensions.dart';

class CustomStepperWidget extends StatelessWidget {
  final bool isActive;
  final bool hasLeftBar;
  final bool hasRightBar;
  final String title;
  final bool rightActive;
  final String? icon;
  const CustomStepperWidget({super.key, required this.title, required this.isActive, required this.hasLeftBar, required this.hasRightBar,
    required this.rightActive, this.icon});

  @override
  Widget build(BuildContext context) {
    Color color = isActive ? Theme.of(context).primaryColor : Theme.of(context).disabledColor;
    Color right = rightActive ? Theme.of(context).primaryColor : Theme.of(context).disabledColor;

    return Expanded(
      child: Column(children: [

        Row(children: [
          Expanded(child: hasLeftBar ? DottedLine(dashColor: color, lineThickness: 2) : const SizedBox()),
          Padding(
            padding: EdgeInsets.symmetric(vertical: isActive ? 0 : 5, horizontal: Dimensions.paddingSizeExtraSmall),
            child: SizedBox(width: 20,child: Image.asset(icon!, color: color)),
          ),
          Expanded(child: hasRightBar ? DottedLine(dashColor: right, lineThickness: 2) : const SizedBox()),
        ]),

      ]),
    );
  }
}
