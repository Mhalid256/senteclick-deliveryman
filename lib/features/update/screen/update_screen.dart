import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_delivery_boy/common/basewidgets/custom_button_widget.dart';
import 'package:sixvalley_delivery_boy/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_delivery_boy/features/splash/controllers/splash_controller.dart';
import 'package:sixvalley_delivery_boy/utill/dimensions.dart';
import 'package:sixvalley_delivery_boy/utill/images.dart';
import 'package:sixvalley_delivery_boy/utill/styles.dart';
import 'package:url_launcher/url_launcher_string.dart';

class UpdateScreen extends StatelessWidget {
  const UpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(Dimensions.paddingSizeLarge),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Image.asset(
              color: Theme.of(context).primaryColor,
              Images.update,
              width: MediaQuery.of(context).size.height * 0.4,
              height: MediaQuery.of(context).size.height * 0.4,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Text(
              'update'.tr,
              style: robotoBold.copyWith(
                  fontSize: MediaQuery.of(context).size.height * 0.023,
                  color: Theme.of(context).primaryColor),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Text(
              'your_app_is_deprecated'.tr,
              style: robotoRegular.copyWith(
                  fontSize: MediaQuery.of(context).size.height * 0.0175,
                  color: Theme.of(context).disabledColor),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            CustomButtonWidget(
                btnTxt: 'update_now'.tr,
                onTap: () async {
                  String? appUrl;
                  if (Platform.isAndroid) {
                    appUrl = Get.find<SplashController>()
                        .configModel
                        ?.deliveryManAppVersionControl
                        ?.forAndroid
                        .link;
                  } else if (Platform.isIOS) {
                    appUrl =
                        Provider.of<SplashController>(context, listen: false)
                            .configModel
                            ?.deliveryManAppVersionControl
                            ?.forIos
                            .link;
                  }

                  // Log the URL for debugging
                  debugPrint('Update link from config: $appUrl');

                  // Fallback to Play Store URL using app package name
                  const String packageName = 'com.techsate.delivery';
                  final String marketUrl = 'market://details?id=$packageName';
                  final String playStoreUrl =
                      'https://play.google.com/store/apps/details?id=$packageName';

                  // Try the configured link first (if present), then market: then https
                  List<String> candidates = [];
                  if (appUrl != null && appUrl.isNotEmpty)
                    candidates.add(appUrl);
                  candidates.add(marketUrl);
                  candidates.add(playStoreUrl);

                  bool launched = false;
                  for (final url in candidates) {
                    try {
                      debugPrint('Trying to launch: $url');
                      final can = await canLaunchUrlString(url);
                      debugPrint('canLaunch($url) => $can');
                      if (can) {
                        await launchUrlString(url,
                            mode: LaunchMode.externalApplication);
                        launched = true;
                        break;
                      }
                    } catch (e, st) {
                      debugPrint('Failed to launch $url: $e\n$st');
                    }
                  }

                  if (!launched) {
                    showCustomSnackBarWidget(
                        '${'can_not_launch'.tr}  ${candidates.join(', ')}');
                  }
                }),
          ]),
        ),
      ),
    );
  }
}
