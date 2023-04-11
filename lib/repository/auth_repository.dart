import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  const AuthRepository(this._auth);

  final FirebaseAuth _auth;

  FirebaseAuth get instance => _auth;

  Stream<User?> get authStateChange => _auth.idTokenChanges();


  Future<User?> verifyOtp(String vid, String otp) async {
      try{
         PhoneAuthCredential creds = PhoneAuthProvider.credential(verificationId: vid, smsCode: otp);
         final result = await _auth.signInWithCredential(creds);
         return result.user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'invalid-verification-id') {
          throw AuthException('Otp Cannot Be Empty');
        } else if (e.code == 'invalid-verification-code') { 
          throw AuthException('Worng OTP');
        } else { throw AuthException(e.code); }
      
    }
     

  }



  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw AuthException('User not found');
      } else if (e.code == 'wrong-password') {
        throw AuthException('Wrong password');
      } else {
        throw AuthException('An error occured. Please try again later');
      }
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}

class AuthException implements Exception {
  final String message;

  AuthException(this.message);

  @override
  String toString() {
    return message;
  }
}