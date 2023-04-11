// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OtpInput extends ChangeNotifier {
  String vid = '';
  bool isOtpScreen = false;


  void setOtpScreen() {
    isOtpScreen = !isOtpScreen;
    notifyListeners();
  }
  void stop() {
    isOtpScreen = false;
    notifyListeners();
  }

}

final otpinputProvider = ChangeNotifierProvider<OtpInput>(
  (ref) => OtpInput(),
);