
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixvalley_delivery_boy/features/splash/controllers/splash_controller.dart';

class NetworkInfo {
  final Connectivity connectivity;
  NetworkInfo(this.connectivity);


  Future<bool> get isConnected async {
    List<ConnectivityResult> result = await connectivity.checkConnectivity();
    return result.contains(ConnectivityResult.wifi)  || result.contains(ConnectivityResult.mobile);
  }


  static void checkConnectivity(BuildContext context) {
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
      if(Get.find<SplashController>().firstTimeConnectionCheck) {
        Get.find<SplashController>().setFirstTimeConnectionCheck(false);
      }else {
        bool isConnected = result.contains(ConnectivityResult.wifi)  || result.contains(ConnectivityResult.mobile);
        !isConnected ? const SizedBox() : ScaffoldMessenger.of(Get.context!).hideCurrentSnackBar();
        ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
          backgroundColor: !isConnected ? Colors.red : Colors.green,
          duration: Duration(seconds: !isConnected ? 6000 : 3),
          content: Text(!isConnected ? 'no_connection'.tr : 'connected'.tr,
            textAlign: TextAlign.center,
          ),
        ));
      }
    });
  }
}
