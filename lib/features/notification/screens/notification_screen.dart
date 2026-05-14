import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixvalley_delivery_boy/features/dashboard/screens/dashboard_screen.dart';
import 'package:sixvalley_delivery_boy/features/notification/controllers/notification_controller.dart';
import 'package:sixvalley_delivery_boy/common/basewidgets/custom_app_bar_widget.dart';
import 'package:sixvalley_delivery_boy/common/basewidgets/no_data_screen_widget.dart';
import 'package:sixvalley_delivery_boy/features/notification/widgets/notification_card_item_widget.dart';
import 'package:sixvalley_delivery_boy/features/notification/widgets/notification_screen_shimmer_widget.dart';
import 'package:sixvalley_delivery_boy/utill/dimensions.dart';

class NotificationScreen extends StatefulWidget {
  final bool fromNotification;
  const NotificationScreen({super.key, required this.fromNotification});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  int? seenNotificationID = Get.find<NotificationController>().getSeenNotificationId();

  @override
  Widget build(BuildContext context) {
    Get.find<NotificationController>().getNotificationList(1);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if(widget.fromNotification) {
          Get.to(()=> const DashboardScreen(pageIndex: 0));
        }
        Get.find<NotificationController>().saveSeenNotificationId(Get.find<NotificationController>().notificationList![0].id ?? 0);
        return;
      },


      child: Scaffold(
        appBar: CustomAppBarWidget(title: 'notification'.tr),
        body: GetBuilder<NotificationController>(builder: (notificationController) {

          return RefreshIndicator(
            onRefresh: () async {
              await notificationController.getNotificationList(1);
            },
            child: !notificationController.isLoading ? notificationController.notificationList!.isNotEmpty ?
            ListView.separated(
              itemCount: notificationController.notificationList!.length,
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return NotificationCardWidget(
                  notificationModel: notificationController.notificationList![index],
                  addTitle: false,
                  index: index,
                  isSeen: notificationController.notificationList![index].id! <= (seenNotificationID ?? 0),
                );
              },
              separatorBuilder: (BuildContext context, int index) => SizedBox(height: Dimensions.paddingSizeMin),
            ) : const NoDataScreenWidget() : const NotificationScreenShimmer(),
          );

        }),
      ),
    );
  }
}
