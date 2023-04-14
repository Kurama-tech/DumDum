import 'dart:convert';

import 'package:dumdum/providers/register_provider.dart';
import 'package:dumdum/providers/signupprovider.dart';

import 'package:dumdum/repository/home_repository.dart';
import 'package:dumdum/screens/home.dart';
import 'package:dumdum/screens/login.dart';
import 'package:dumdum/screens/otpscreen.dart';
import 'package:dumdum/screens/registration_screen.dart';
import 'package:dumdum/screens/signupscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../model/profile.dart';
import '../providers/authprovider.dart';
class AuthChecker extends ConsumerWidget {
  const AuthChecker({Key? key}) : super(key: key);

  UserProfile getProfile(dynamic response){
    print('here');
  

        
    var data = response;
    print(data[0].runtimeType);
    UserProfile userProfile = UserProfile.fromJson(data[0]);
    return userProfile;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final authRepository = ref.watch(authRepositoryProvider);
    final homeRepositoryProvider = Provider((ref) => HomeRepository());

    final homeRepository = ref.watch(homeRepositoryProvider);
    final uidProvider = Provider((ref) => FirebaseAuth.instance.currentUser?.uid);

    final isSignedup = ref.watch(signedupProvider);


    final reg = ref.watch(RegisterProvider.provider);

    return FutureBuilder(
      future: authState.when(
        data: (user) async {
          if (user != null) {
            final userStatus = await homeRepository.getUserbyID(user.uid);

            if (userStatus == null) {
              ref.read(signedupProvider.notifier).unset();
              return const Signup();
            }else {
              var data = getProfile(userStatus);
              print(data);
              ref.read(profileProvider.notifier).set(data);
              ref.read(signedupProvider.notifier).set();
              return const MyHomePage(title: 'DumDum');
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