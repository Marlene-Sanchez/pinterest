import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

ValueNotifier<AuthService> authService = ValueNotifier(AuthService());

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static const String _webClientId =
      '454755295268-cb0mfl5ereggemivjj78m7ht4bp0qhcm.apps.googleusercontent.com';

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<void> signIn({required String email, required String password}) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> createAccount({
    required String email,
    required String password,
  }) async {
    return _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn(
      clientId: kIsWeb ? null : _webClientId,
      serverClientId: kIsWeb ? _webClientId : null,
    );
    if (await googleSignIn.isSignedIn()) {
      await googleSignIn.signOut();
    }
    await _auth.signOut();
  }

  Future<void> resetPassword({required String email}) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> updateUsername({required String username}) async {
    await currentUser?.updateDisplayName(username);
  }

  Future<void> deleteAccount({
    required String email,
    required String password,
  }) async {
    final user = currentUser;
    if (user == null) {
      throw FirebaseAuthException(code: 'no-current-user');
    }

    final credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );

    await user.reauthenticateWithCredential(credential);
    await user.delete();
    await _auth.signOut();
  }

  Future<void> resetPasswordFromCurrentPassword({
    required String currentPassword,
    required String newPassword,
    required String email,
  }) async {
    final user = currentUser;
    if (user == null) {
      throw FirebaseAuthException(code: 'no-current-user');
    }

    final credential = EmailAuthProvider.credential(
      email: email,
      password: currentPassword,
    );

    await user.reauthenticateWithCredential(credential);
    await user.updatePassword(newPassword);
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: kIsWeb ? _webClientId : null,
      serverClientId: kIsWeb ? null : _webClientId,
    );

    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser == null) {
      throw FirebaseAuthException(code: 'google-sign-in-cancelled');
    }

    final googleAuth = await googleUser.authentication;

    if (googleAuth.accessToken == null || googleAuth.idToken == null) {
      throw FirebaseAuthException(
        code: 'google-sign-in-authentication-failed',
        message: 'Failed to obtain authentication tokens',
      );
    }

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken!,
      idToken: googleAuth.idToken!,
    );

    return FirebaseAuth.instance.signInWithCredential(credential);
  }
}