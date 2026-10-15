import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Stream of Auth State Changes (logged in / logged out)
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Get Current Logged-in User
  User? get currentUser => _auth.currentUser;

  /// Sign Up with Email and Password
  Future<UserCredential> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  ///signin with google
  void continueWithGoogle()async{
    final webclientId= '513642196062-cbca08h1nuk3t85fsrk8rlpacgm97dmr.apps.googleusercontent.com';
    try{
      GoogleSignIn googleSignIn= GoogleSignIn.instance;
      await googleSignIn.initialize(serverClientId: webclientId);
      GoogleSignInAccount account = await googleSignIn.authenticate();
      GoogleSignInAuthentication googleAuth = account.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken
      );

      await _auth.signInWithCredential(credential);

    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Sign In with Email and Password
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Send Password Reset Email
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Helper to convert Firebase Auth exceptions into user-friendly messages
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found for this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'An account already exists for this email.';
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      default:
        return e.message ?? 'An authentication error occurred.';
    }
  }
}
