import 'package:dumdum/providers/loadingprovider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/authprovider.dart';
import 'login_state.dart';

class LoginController extends StateNotifier<LoginState> {
  LoginController(this.ref) : super(const LoginStateInitial());

  final Ref ref;

  void verifyOtp(String vid, String otp) async {
    ref.read(loadingProvider.notifier).setloading();
    state = const LoginStateLoading();
    try{
        await ref.read(authRepositoryProvider).verifyOtp(vid, otp);
        ref.read(loadingProvider).stoploading();
        state = const LoginStateSuccess();
    } catch (e) {
      ref.read(loadingProvider).stoploading();
      state = LoginStateError(e.toString());
    }
  }

  void login(String email, String password) async {
    state = const LoginStateLoading();
    try {
      await ref.read(authRepositoryProvider).signInWithEmailAndPassword(
            email,
            password,
          );
      state = const LoginStateSuccess();
    } catch (e) {
      state = LoginStateError(e.toString());
    }
  }

  void signOut() async {
    await ref.read(authRepositoryProvider).signOut();
  }
}

final loginControllerProvider =
    StateNotifierProvider<LoginController, LoginState>((ref) {
  return LoginController(ref);
});