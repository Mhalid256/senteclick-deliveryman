import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sixvalley_delivery_boy/utill/dimensions.dart';

class NotificationScreenShimmer extends StatelessWidget {
  const NotificationScreenShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemCount: 10,
      itemBuilder: (_, index) {
        final showDate = index == 0 || index % 3 == 0;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: NotificationCardShimmer(index: index, showDate: showDate),
        );
      },
    );
  }
}

class NotificationCardShimmer extends StatelessWidget {
  final int index;
  final bool showDate;
  const NotificationCardShimmer({super.key, required this.index, this.showDate = false});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

      if (showDate) ...[
        SizedBox(height: Dimensions.rememberMeSizeDefault),

        Padding(
          padding: EdgeInsets.only(
            left: Dimensions.paddingSizeDefault,
            bottom: Dimensions.paddingSizeExtraSmall,
          ),
          child: Shimmer.fromColors(
            baseColor: Theme.of(context).disabledColor.withValues(alpha:0.3),
            highlightColor: Theme.of(context).hintColor.withValues(alpha:0.2),
            child: Container(
              height: 10,
              width: 80,
              color: Theme.of(context).hintColor.withValues(alpha:0.5),
            ),
          ),
        ),
        SizedBox(height: Dimensions.paddingSizeMin),
      ],

      Container(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeDefault,
          vertical: Dimensions.paddingSizeSmall,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha:0.05),
              spreadRadius: 0,
              blurRadius: 7,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Shimmer.fromColors(
                baseColor: Theme.of(context).disabledColor.withValues(alpha:0.3),
                highlightColor: Theme.of(context).hintColor.withValues(alpha:0.4),
                child: Container(
                  width: 45,
                  height: 45,
                  padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(80),
                    border: Border.all(color: Colors.black.withValues(alpha:0.10), width: 1),
                    color: Theme.of(context).hintColor.withValues(alpha:0.5),
                  ),
                ),
              ),

              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Expanded(
                    child: Shimmer.fromColors(
                      baseColor: Theme.of(context).disabledColor.withValues(alpha:0.3),
                      highlightColor: Theme.of(context).hintColor.withValues(alpha:0.4),
                      child: Container(
                        height: 10,
                        width: double.infinity,
                        color: Theme.of(context).hintColor.withValues(alpha:0.5),
                      ),
                    ),
                  ),
                  SizedBox(width: Dimensions.paddingSizeDefault),

                  Shimmer.fromColors(
                    baseColor: Theme.of(context).disabledColor.withValues(alpha:0.3),
                    highlightColor: Theme.of(context).hintColor.withValues(alpha:0.4),
                    child: Container(
                      height: 10,
                      width: 40,
                      color: Theme.of(context).hintColor.withValues(alpha:0.5),
                    ),
                  ),

                ],
              ),

              subtitle: Padding(
                padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                child: Shimmer.fromColors(
                  baseColor: Theme.of(context).disabledColor.withValues(alpha:0.3),
                  highlightColor: Theme.of(context).hintColor.withValues(alpha:0.4),
                  child: Container(
                    height: 10,
                    width: double.infinity,
                    color: Theme.of(context).hintColor.withValues(alpha:0.5),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ]);
  }
}

