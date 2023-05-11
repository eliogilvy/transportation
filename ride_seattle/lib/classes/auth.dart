import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth {
  Auth({required this.firebaseAuth});
  final FirebaseAuth firebaseAuth;

  User? get currentUser => firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();
  CollectionReference<Map<String, dynamic>> fb =
      FirebaseFirestore.instance.collection('users');

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
    required Function failure,
    required Function success,
  }) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      success();
    } catch (e) {
      failure();
    }
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signInWithPhone(
      BuildContext context, String phone, Function failure) async {
    await firebaseAuth.verifyPhoneNumber(
      timeout: const Duration(seconds: 60),
      phoneNumber: phone,
      verificationCompleted: (credential) async {
        await firebaseAuth.signInWithCredential(credential);
        if (context.mounted) {
          context.go('/');
        }
      },
      verificationFailed: (e) {
        if (context.mounted) {
          if (e.code == 'invalid-phone-number') {
            failure('Invalid number. Please try again');
          } else {
            failure('Unknown error. Please try again.');
          }
        }
      },
      codeSent: (verificationId, resendToken) {
        context.push('/otp',
            extra: {'callback': verifyOtp, 'verificationId': verificationId});
      },
      codeAutoRetrievalTimeout: (verificationId) {},
    );
  }

  void verifyOtp(BuildContext context, String verificationId, String userOtp,
      Function otpFail) async {
    final credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: userOtp);
    try {
      await firebaseAuth.signInWithCredential(credential);
      if (context.mounted) {
        context.go('/');
      }
    } catch (e) {
      otpFail();
    }
  }

  Future<void> signInWithGoogle() async {
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      UserCredential c = await firebaseAuth.signInWithCredential(credential);
    } catch (error) {
      print('error $error');
    }
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }
}
