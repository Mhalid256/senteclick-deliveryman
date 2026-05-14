
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixvalley_delivery_boy/features/chat/controllers/chat_controller.dart';
import 'package:sixvalley_delivery_boy/features/order/domain/models/order_model.dart';
import 'package:sixvalley_delivery_boy/features/order_details/widgets/round_border_icon_widget.dart';
import 'package:sixvalley_delivery_boy/features/splash/controllers/splash_controller.dart';
import 'package:sixvalley_delivery_boy/helper/shop_helper.dart';
import 'package:sixvalley_delivery_boy/utill/images.dart';
import 'package:sixvalley_delivery_boy/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_delivery_boy/features/chat/screens/chat_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class CallAndChatWidget extends StatelessWidget {
  final OrderModel? orderModel;
  final bool isSeller;
  final bool isAdmin;
  const CallAndChatWidget({super.key, this.orderModel, this.isSeller = false, this.isAdmin = false});

  @override
  Widget build(BuildContext context) {
    final inHouseShop = Get.find<SplashController>().configModel?.inHouseShop;

    String? phone = isSeller? orderModel!.sellerInfo!.phone : orderModel!.isGuest! ? orderModel?.shippingAddress?.phone: orderModel!.customer?.phone??'';
    int? id = 0;
    String? name = '';
    String? image;
    if(isAdmin){
      id = inHouseShop?.sellerId;
      name = inHouseShop?.name;
      image = inHouseShop?.imageFullUrl?.path ?? '';
    }else{
      id =   isSeller ? orderModel!.sellerInfo!.id! : orderModel!.customer?.id?? -1;
      name = isSeller ? orderModel!.sellerInfo!.shop!.name! : '${orderModel!.customer?.fName??''} ${orderModel!.customer?.lName??''}';
      image = isSeller ? orderModel?.sellerInfo?.shop?.imageFullUrl?.path : orderModel?.customer?.imageFullUrl?.path;
    }

    return Row(children: [

      InkWell(onTap: () => _launchUrl("tel:$phone"), child: const RoundBorderIconWidget(image: Images.callIcon)),


      if(isAdmin || isSeller || !orderModel!.isGuest!)
        InkWell(
          onTap: (){
            if(!isSeller && !isAdmin && orderModel!.isGuest!){
              showCustomSnackBarWidget('you_cant_chat_with_guest_user'.tr);
            }
            else if(!isSeller && !isAdmin && !orderModel!.isGuest!){
              Get.find<ChatController>().setUserTypeIndex(1);
            }else if(isAdmin){
              Get.find<ChatController>().setUserTypeIndex(3);
            }else if(isSeller){
              Get.find<ChatController>().setUserTypeIndex(0);
            }
            if(id != -1){
              Get.to(()=> ChatScreen(
                userId: id,
                name: name,
                image: image,
                isShopOnVacation: isSeller ? ShopHelper.isVacationActive(
                  context,
                  startDate: orderModel?.sellerInfo?.shop?.vacationStartDate,
                  endDate: orderModel?.sellerInfo?.shop?.vacationEndDate,
                  vacationDurationType: orderModel?.sellerInfo?.shop?.vacationDurationType,
                  vacationStatus: orderModel?.sellerInfo?.shop?.vacationStatus,
                  isInHouseSeller: orderModel?.sellerIs == 'admin',
                ) : false,
                isShopTemporaryClosed: isSeller
                  ? orderModel?.sellerInfo?.shop?.temporaryClose ?? false
                  : false,
              ));
            } else if(id  == -1) {
              showCustomSnackBarWidget('user_account_was_deleted'.tr);
            }
          },
          child: const RoundBorderIconWidget(image: Images.smsIcon),
        ),
    ]);
  }
}

Future<void> _launchUrl(String _url) async {
  if (!await launchUrl(Uri.parse(_url))) {
    throw 'Could not launch $_url';
  }
}