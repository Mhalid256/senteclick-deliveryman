import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:sixvalley_delivery_boy/features/dashboard/controllers/dashboard_controller.dart';
import 'package:sixvalley_delivery_boy/features/order/controllers/order_controller.dart';
import 'package:sixvalley_delivery_boy/features/order/widgets/order_history_shimmer_widget.dart';
import 'package:sixvalley_delivery_boy/features/profile/controllers/profile_controller.dart';
import 'package:sixvalley_delivery_boy/utill/dimensions.dart';
import 'package:sixvalley_delivery_boy/common/basewidgets/custom_app_bar_widget.dart';
import 'package:sixvalley_delivery_boy/common/basewidgets/no_data_screen_widget.dart';
import 'package:sixvalley_delivery_boy/common/basewidgets/title_widget_widget.dart';
import 'package:sixvalley_delivery_boy/features/home/widgets/earn_statement_widget.dart';
import 'package:sixvalley_delivery_boy/features/home/widgets/ongoing_order_card_widget.dart';
import 'package:sixvalley_delivery_boy/features/home/widgets/trip_status_widget.dart';
import 'package:sixvalley_delivery_boy/features/home/widgets/permission_dialog_widget.dart';

class HomeScreen extends StatefulWidget {
  final Function(int index) onTap;
  const HomeScreen({super.key, required this.onTap});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Future<void> _loadData() async {
    await Get.find<ProfileController>().getProfile();
    await Get.find<OrderController>().getCurrentOrders();

  }

  @override
  void initState() {
    _checkPermission(context);
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'dashboard'.tr, isSwitch: true),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: CustomScrollView(slivers: [
          SliverToBoxAdapter(
            child: Column(children: [

              const EarnStatementWidget(),
              SizedBox(height: Dimensions.paddingSizeDefault),

              TripStatusWidget(onTap: (int index) => widget.onTap(index)),

              Padding(padding:  EdgeInsets.fromLTRB(Dimensions.paddingSizeExtraLarge,
                  Dimensions.paddingSizeDefault, Dimensions.paddingSizeExtraLarge, Dimensions.paddingSizeExtraSmall),
                  child: TitleWidget(title: 'ongoing'.tr,onTap: (){
                    Get.find<DashboardController>().selectOrderHistoryScreen(fromHome: true);
                    Get.find<OrderController>().setOrderTypeIndex(0);})),


              GetBuilder<OrderController>(builder: (orderController) {
                return !orderController.isLoading ? orderController.currentOrders.isNotEmpty ?
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal : Dimensions.paddingSizeExtraLarge, vertical: Dimensions.paddingSizeSmall),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: orderController.currentOrders.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index){
                      return OnGoingOrderWidget(orderModel: orderController.currentOrders[index], index: index);
                    },
                  ),
                ) : const Center(child: NoDataScreenWidget(),
                ) : const OrderHistoryShimmer();
              }),

            ],
            ),
          )
        ],
        ),

      )
    );
  }

  void _checkPermission(BuildContext context) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if(permission == LocationPermission.denied) {
      showDialog(context: Get.context!, barrierDismissible: false, builder: (context) => PermissionDialogWidget(isDenied: true,
          onPressed: () async {
            Navigator.pop(context);
            await Geolocator.requestPermission();
          }));
    }else if(permission == LocationPermission.deniedForever) {
      showDialog(context: Get.context!, barrierDismissible: false, builder: (context) => PermissionDialogWidget(isDenied: false,
          onPressed: () async {
            Navigator.pop(context);
            await Geolocator.openAppSettings();
          }));
    }
  }
}




