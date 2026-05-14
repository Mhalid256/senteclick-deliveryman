import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sixvalley_delivery_boy/features/auth/controllers/auth_controller.dart';
import 'package:sixvalley_delivery_boy/helper/color_helper.dart';
import 'package:sixvalley_delivery_boy/utill/dimensions.dart';
import 'package:sixvalley_delivery_boy/utill/styles.dart';
import 'package:sixvalley_delivery_boy/common/basewidgets/custom_button_widget.dart';
import 'package:sixvalley_delivery_boy/common/basewidgets/custom_app_bar_widget.dart';
import 'package:sixvalley_delivery_boy/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_delivery_boy/features/auth/screens/reset_password_screen.dart';


class VerificationScreen extends StatelessWidget {
  final String? mobileNumber;
  final String? countryCode;

  const VerificationScreen({super.key, this.countryCode, this.mobileNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: 'verification'.tr,
        isBack: true,
        onTap: () => Navigator.pop(context),
      ),
      body: GetBuilder<AuthController>(
        builder: (authController) {
          return Column(mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center, children: [

              Padding(padding:  EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                child: Text('please_enter_4_digit_code'.tr,style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeDefault),
                textAlign: TextAlign.center)),

              Padding(padding: EdgeInsets.symmetric(horizontal: Get.width/7, vertical: Dimensions.paddingSizeDefault),
                child: PinCodeTextField(
                  length: 4,
                  appContext: context,
                  obscureText: false,
                  showCursor: true,
                  keyboardType: TextInputType.number,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.circle,
                    fieldHeight: 50,
                    fieldWidth: 50,
                    borderWidth: 1,
                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraLarge),
                    selectedColor: ColorHelper.darken(Theme.of(context).primaryColor, 0.2),
                    selectedFillColor: Colors.white,
                    inactiveFillColor: Get.isDarkMode? Theme.of(context).hintColor.withValues(alpha:.125):
                    Theme.of(context).primaryColor.withValues(alpha:.1),
                    inactiveColor: ColorHelper.darken(Theme.of(context).primaryColor, 0.2),
                    activeColor: ColorHelper.darken(Theme.of(context).primaryColor, 0.1),
                    activeFillColor: Theme.of(context).primaryColor.withValues(alpha:.025),
                  ),
                  animationDuration: const Duration(milliseconds: 300),
                  backgroundColor: Colors.transparent,
                  enableActiveFill: true,
                  onChanged: authController.updateVerificationCode,
                  beforeTextPaste: (text) {
                    return true;
                  },
                ),
              ),


              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('${'if_you_did_not_receive_a_code'.tr},'),
                InkWell(onTap: () {
                    authController.forgotPassword(mobileNumber).then((value) {
                      if (value.statusCode == 200) {
                        showCustomSnackBarWidget('otp_send_successfully'.tr, isError: false);
                      }
                    });
                  },
                  child: Padding(padding:  EdgeInsets.only(left : Dimensions.paddingSizeSmall),
                    child: Text('resend'.tr,
                      style: rubikMedium.copyWith(color:Get.isDarkMode? Theme.of(context).hintColor:
                      Theme.of(context).primaryColor.withValues(alpha:.75))),
                  ),
                ),
              ]),

              const SizedBox(height: 50),

              !authController.willPhoneNumberVerificationButtonLoading ?
              Padding(padding:  EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                child: CustomButtonWidget(
                  btnTxt:  'verify'.tr,
                  onTap: () {
                    authController.verifyOtp(authController.verificationCode, mobileNumber).then((value) {
                      if(value.statusCode == 200) {
                        Get.to(ResetPasswordWidget(mobileNumber: mobileNumber));
                      }else {
                        showCustomSnackBarWidget('input_valid_otp'.tr);
                      }
                    });
                    })):
              Padding(padding: EdgeInsets.symmetric(horizontal: (Get.width/2)-40),
                child: const SizedBox(width: 40,height: 40,
                    child: CircularProgressIndicator(),
                ),
              ),
            ],
          );
        }
      ),
    );
  }
}
