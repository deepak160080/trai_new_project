import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AppConstants {
  static final navigatorKey = GlobalKey<NavigatorState>();
}
class AuthServices {
    final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookAuth _facebookAuth = FacebookAuth.instance;

  // Stream to listen to authentication state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Get current user
  User? get currentUser => _auth.currentUser;

//  static final Config config = Config(
//     tenant: 'YOUR_TENANT_ID',
//     clientId: 'YOUR_CLIENT_ID',
//     scope: 'openid profile email',
//     redirectUri: 'msauth://com.example.trai_ui/auth',
//     navigatorKey: AppConstants.navigatorKey,
//   );
  
//   final AadOAuth oauth = AadOAuth(config);


  Future<UserCredential> signInWithCredential(AuthCredential credential) async {
    try {
      final UserCredential userCredential = 
          await _auth.signInWithCredential(credential);
      return userCredential;
    } catch (e) {
      print('Error signing in with credential: $e');
      rethrow;
    }
  }
  // Sign in with Google


// Fix the return type to match the possible null return
Future<UserCredential?> signInWithGoogle() async {
    try {
      // Handle web platform differently
      if (kIsWeb) {
        GoogleAuthProvider authProvider = GoogleAuthProvider();
        return await _auth.signInWithPopup(authProvider);
      }

      // Trigger the authentication flow for mobile
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // Early return if user cancels sign in
      if (googleUser == null) {
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = 
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with Firebase and return the result
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      print('Error signing in with Google: $e');
      rethrow;
    }
}


  // Sign out
  Future<void> signOut() async {
    try {
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
        _facebookAuth.logOut(),
      ]);
    } catch (e) {
      print('Error signing out: $e');
      rethrow;
    }
  }

  // Check if user is signed in
  bool isUserSignedIn() {
    return _auth.currentUser != null;
  }

  // Get user display name
  String? getUserDisplayName() {
    return _auth.currentUser?.displayName;
  }

  // Get user email
  String? getUserEmail() {
    return _auth.currentUser?.email;
  }

  // Get user photo URL
  String? getUserPhotoURL() {
    return _auth.currentUser?.photoURL;
  }

  // Get user ID
  String? getUserId() {
    return _auth.currentUser?.uid;
  }

  // Delete account
  Future<void> deleteAccount() async {
    try {
      await _auth.currentUser?.delete();
    } catch (e) {
      print('Error deleting account: $e');
      rethrow;
    }
  }

  // Check if email is verified
  bool isEmailVerified() {
    return _auth.currentUser?.emailVerified ?? false;
  }

  // Send email verification
  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } catch (e) {
      print('Error sending email verification: $e');
      rethrow;
    }
  }

  //  Future<UserCredential?> signInWithMicrosoft() async {
  //   try {
  //     // Trigger Microsoft login
  //     await oauth.login();
  //     final accessToken = await oauth.getAccessToken();
      
  //     if (accessToken == null) {
  //       throw FirebaseAuthException(
  //         code: 'ERROR_MICROSOFT_LOGIN_FAILED',
  //         message: 'Microsoft login failed: No access token received',
  //       );
  //     }

  //     // Create a credential from the access token
  //     final OAuthCredential credential = OAuthProvider('microsoft.com').credential(
  //       accessToken: accessToken,
  //     );

  //     // Sign in with Firebase
  //     return await _auth.signInWithCredential(credential);
  //   } catch (e) {
  //     print('Error signing in with Microsoft: $e');
  //     await oauth.logout();
  //     rethrow;
  //   }
  // }
 
  Future<UserCredential?> signInWithFacebook() async {
    try {
      // Trigger the sign-in flow
      final LoginResult loginResult = await _facebookAuth.login();

      // Check if login was successful
      if (loginResult.status != LoginStatus.success) {
        throw FirebaseAuthException(
          code: 'ERROR_FACEBOOK_LOGIN_FAILED',
          message: 'Facebook login failed: ${loginResult.status}',
        );
      }

      // Create a credential from the access token
      final OAuthCredential credential = FacebookAuthProvider.credential(
        loginResult.accessToken!.tokenString,
      );

      // Sign in with Firebase
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      print('Error signing in with Facebook: $e');
      rethrow;
    }
  }
 Future<void> verifyPhone({
    required String phoneNumber,
    required Function(String) onCodeSent,
    required Function(String) onError,
    required Function(PhoneAuthCredential) onVerified,
  }) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto verification or Android device only
          onVerified(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          onError(e.message ?? 'Verification Failed');
        },
        codeSent: (String verificationId, int? resendToken) {
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      onError(e.toString());
    }
  }

  Future<UserCredential?> verifyOTPAndLogin(
      String verificationId, String otp) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      print('Error verifying OTP: $e');
      rethrow;
    }
  }

}