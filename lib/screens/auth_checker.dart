import 'package:dumdum/providers/register_provider.dart';
import 'package:dumdum/repository/home_repository.dart';
import 'package:dumdum/screens/home.dart';
import 'package:dumdum/screens/login.dart';
import 'package:dumdum/screens/otpscreen.dart';
import 'package:dumdum/screens/registration_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/authprovider.dart';
class AuthChecker extends ConsumerWidget {
  const AuthChecker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final authRepository = ref.watch(authRepositoryProvider);
    final homeRepositoryProvider = Provider((ref) => HomeRepository());

    final homeRepository = ref.watch(homeRepositoryProvider);
    final uidProvider = Provider((ref) => FirebaseAuth.instance.currentUser?.uid);


    final reg = ref.watch(RegisterProvider.provider);


    final User? user1 = FirebaseAuth.instance.currentUser;

    return FutureBuilder(
      future: authState.when(
        data: (user) async {
          if (user1 != null) {
            final Uid = user1.uid;
            final userStatus = await homeRepository.getUserbyID(Uid);
            print(userStatus);

            if (userStatus == null) {
              return const Registation();
            } else if (user1 != null) {
              return const MyHomePage(title: "");
            }
          }
          return const Login();
        },
        loading: () => Future.value(const SplashScreen()),
        error: (e, trace) => Future.value(const Login()),
      ),
      builder: (context, AsyncSnapshot<Widget> snapshot) {
        if (snapshot.hasData) {
          return snapshot.data!;
        } else {
          return const SplashScreen();
        }
      },
    );
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