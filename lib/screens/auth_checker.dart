import 'package:dumdum/screens/home.dart';
import 'package:dumdum/screens/login.dart';
import 'package:dumdum/screens/otpscreen.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/authprovider.dart';

class AuthChecker extends ConsumerWidget {
  const AuthChecker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
        data: (user) {
          if (user != null) return const MyHomePage(title: 'DumDum');
          return const Login();//OtpScreen('hhhh');
        },
        loading: () => const SplashScreen(),
        error: (e, trace) => const Login());//OtpScreen('hhhh'));
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}