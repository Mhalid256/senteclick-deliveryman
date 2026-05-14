import 'package:sixvalley_delivery_boy/features/auth/domain/models/response_model.dart';

abstract class AuthServiceInterface  {
  Future<ResponseModel> login(String countryCode, String phone, String password);
  void saveUserToken(String token);
  Future<dynamic> updateToken();
  Future<dynamic> setLanguageCode(String currentLanguage);
  bool isLoggedIn();
  Future<bool> clearSharedData();
  void saveUserCredentials(String countryCode, String number, String password);
  String getUserEmail();
  String getUserPassword();
  String getUserToken();
  Future<bool> clearUserCredentials();
  Future<dynamic> forgotPassword(String? identity);
  Future<dynamic> verifyOtp(String otp ,String? identity);
  String getUserCountryCode();
}