// ignore: file_names
import 'package:hooks_riverpod/hooks_riverpod.dart';

class VerificationIdNotifier extends StateNotifier<String> {

  VerificationIdNotifier() : super("");

  void setVid(String value) async {
    state = value;
  }
}

class PhoneNumberNotifier extends StateNotifier<String> {

  PhoneNumberNotifier() : super("");

  void setphone(String value) async {
    state = value;
  }
}

class ResendNotifier extends StateNotifier<int> {

  ResendNotifier() : super(0);

  void setresend(int value) async {
    state = value;
  }
}


final verificationIdProvider = StateNotifierProvider<VerificationIdNotifier, String>(
  (ref) => VerificationIdNotifier(),
);


final phoneNumberProvider = StateNotifierProvider<PhoneNumberNotifier, String>(
  (ref) => PhoneNumberNotifier(),
);

final resendProvider = StateNotifierProvider<ResendNotifier, int>(
  (ref) => ResendNotifier(),
);