import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Connexion Email/Password
  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      rethrow;
    }
  }

  /// Inscription Email/Password
  Future<UserCredential?> createUserWithEmailAndPassword(
      String email, String password, String name) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await userCredential.user?.updateDisplayName(name);
      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  /// Connexion Google (mobile + web)
  Future<UserCredential?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        googleProvider
          ..addScope('email')
          ..setCustomParameters({'prompt': 'select_account'});

        return await _auth.signInWithPopup(googleProvider);
      } else {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        if (googleUser == null) return null;

        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        return await _auth.signInWithCredential(credential);
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Connexion Facebook (mobile + web)
  Future<UserCredential?> signInWithFacebook() async {
    try {
      if (kIsWeb) {
        FacebookAuthProvider facebookProvider = FacebookAuthProvider();
        facebookProvider.addScope('email');
        return await _auth.signInWithPopup(facebookProvider);
      } else {
        final LoginResult result = await FacebookAuth.instance.login(
          permissions: ['email', 'public_profile'],
        );

        if (result.status == LoginStatus.success) {
          final accessTokenString = result.accessToken!.tokenString;
          final credential = FacebookAuthProvider.credential(accessTokenString);
          return await _auth.signInWithCredential(credential);
        } else {
          throw FirebaseAuthException(
              code: 'ERROR_ABORTED_BY_USER',
              message: 'Connexion Facebook annulée par l’utilisateur.');
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Réinitialisation du mot de passe
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  /// Déconnexion
  Future<void> signOut() async {
    await _auth.signOut();
    if (!kIsWeb) {
      await GoogleSignIn().signOut();
      await FacebookAuth.instance.logOut();
    }
  }

  /// Utilisateur actuel
  User? get currentUser => _auth.currentUser;

  /// Stream d’état d’auth
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
