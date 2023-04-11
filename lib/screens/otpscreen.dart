import 'package:dumdum/providers/authprovider.dart';
import 'package:dumdum/providers/loadingprovider.dart';
import 'package:dumdum/providers/optinputprovider.dart';
import 'package:dumdum/providers/vidprovider.dart';
import 'package:dumdum/screens/loadingscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../repository/auth_repository.dart';
import '../state/login_controller.dart';
import '../state/login_state.dart';

class OtpScreen extends StatefulHookConsumerWidget {
  const OtpScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  @override
  Widget build(BuildContext context) {
    String _code = "";
    String signature = "{{ app signature }}";

    var verifyID = ref.watch(verificationIdProvider);
    var phoneNumber = ref.watch(phoneNumberProvider);
    var loading = ref.watch(loadingProvider);
    var resend = ref.watch(resendProvider);

    ref.listen<LoginState>(loginControllerProvider, ((previous, state) {
      if (state is LoginStateError) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(state.error),
        ));
      }
    }));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              fit: BoxFit.contain,
              height: 200,
              image: NetworkImage(
                  'https://firebasestorage.googleapis.com/v0/b/mamun-public.appspot.com/o/finger-removebg-preview.png?alt=media&token=c491f812-9a2b-43ff-a533-94059683c5c9'),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'DumDum',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Verify OTP',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                const Text(
                  'Not ',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                Text("+91*******${phoneNumber.substring(phoneNumber.length - 4)}? ",
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                ),
                GestureDetector(
                  onTap: (){
                    ref.read(phoneNumberProvider.notifier).setphone('');
                    ref.read(verificationIdProvider.notifier).setVid('');
                    ref.read(otpinputProvider.notifier).stop();
                  },
                  child: const Text(
                  "Change",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                )

              ],
            ),
            const SizedBox(
              height: 10,
            ),
            PinFieldAutoFill(
              decoration: UnderlineDecoration(
                textStyle: const TextStyle(fontSize: 20, color: Colors.black),
                colorBuilder: FixedColorBuilder(Colors.black.withOpacity(0.3)),
              ),
              currentCode: _code,
              onCodeSubmitted: (code) {},
              onCodeChanged: (code) {
                if (code!.length == 6) {
                  FocusScope.of(context).requestFocus(FocusNode());
                  _code = code;
                }
              },
            ),
            const SizedBox(
              height: 10,
            ),
            FilledButton(
              onPressed: () {
                ref
                    .read(loginControllerProvider.notifier)
                    .verifyOtp(verifyID, _code);
              },
              child: const Text(
                'Verify',
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:  [
                const Text(
                  "Didn't Recieve Code? ",
                  style: TextStyle(fontSize: 18),
                ),
                GestureDetector(
                  onTap: (){
                      var loading0 = ref.read(loadingProvider.notifier);

                                loading0.setloading();

                               var instance = ref.read(authRepositoryProvider).instance;
                               
                               instance.verifyPhoneNumber(
                                phoneNumber: '+91$phoneNumber',
                                verificationCompleted: (authCred) async {

                                  await instance.signInWithCredential(authCred);
                                  loading0.stoploading();
                                }, 
                                verificationFailed: (e){
                                  loading0.stoploading();
                                  throw AuthException(e.message!);
                                }, 
                                codeSent: (vid, resend){
                                  loading0.stoploading();
                                  ref.read(resendProvider.notifier).setresend(resend!);
                                  ref.read(phoneNumberProvider.notifier).setphone(phoneNumber);
                                  ref.read(verificationIdProvider.notifier).setVid(vid);
                                  ref.read(otpinputProvider.notifier).setOtpScreen();
                                }, 
                                forceResendingToken: resend,
                                codeAutoRetrievalTimeout: (timeout){},
                                
                                );
                               
                  },
                  child: const Text(
                  "Resend",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                )
              ],
            )
          ],
        ),
      )),
    );
  }
}
