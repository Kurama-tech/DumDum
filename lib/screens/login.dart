import 'package:dumdum/main.dart';
import 'package:dumdum/providers/authprovider.dart';
import 'package:dumdum/providers/loadingprovider.dart';
import 'package:dumdum/providers/optinputprovider.dart';
import 'package:dumdum/providers/vidprovider.dart';
import 'package:dumdum/screens/loadingscreen.dart';
import 'package:dumdum/screens/otpscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../repository/auth_repository.dart';
import '../state/login_controller.dart';
import '../state/login_state.dart';

class Login extends StatefulHookConsumerWidget {
  const Login({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  var vid = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var isOTP = ref.watch(otpinputProvider);
    var loading = ref.watch(loadingProvider).loading;

    ref.listen<LoginState>(loginControllerProvider, ((previous, state) {
      if (state is LoginStateError) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(state.error),
        ));
      }
    }));

    if(loading){
      return const LoadingScreen();
    }

    if(!loading && isOTP.isOtpScreen){
      return OtpScreen();
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Login'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
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
                'Enter the wrold of DumDum',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        autofocus: true,
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            labelText: 'Phone',
                            prefixText: '+91'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Phone Cannot Be Empty';
                          }

                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      //const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FilledButton(

                            onPressed: () {
                              if(_formKey.currentState!.validate()){

                                var loading0 = ref.read(loadingProvider.notifier);

                                loading0.setloading();

                               var instance = ref.read(authRepositoryProvider).instance;

                               instance.verifyPhoneNumber(
                                phoneNumber: '+91${_phoneController.text.trim()}',
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
                                  ref.read(phoneNumberProvider.notifier).setphone(_phoneController.text.trim());
                                  ref.read(verificationIdProvider.notifier).setVid(vid);
                                  ref.read(otpinputProvider.notifier).setOtpScreen();
                                },
                                codeAutoRetrievalTimeout: (timeout){},

                                );

                              }
                            },
                            child: const Text(
                              'Proceed',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
