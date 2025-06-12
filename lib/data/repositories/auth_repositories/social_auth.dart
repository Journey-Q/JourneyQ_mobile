import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class SocialAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  Future<UserCredential?> signInWithGoogle() async {
    try {
      print('Starting Google Sign-In...');
      
      // Clear any existing session first
      await _googleSignIn.signOut();
      
      // Start fresh sign-in process
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        print('Google Sign-In was cancelled by user');
        return null;
      }

      print('Google Sign-In successful for: ${googleUser.email}');
      
      // Get authentication details with retry logic
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Verify we have the required tokens
      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        throw FirebaseAuthException(
          code: 'missing-auth-token',
          message: 'Failed to get Google authentication tokens',
        );
      }

      print('Google authentication tokens received');
      
      // Create Firebase credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken!,
        idToken: googleAuth.idToken!,
      );

      print('Signing in to Firebase with Google credential...');
      
      // Sign in to Firebase
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      
      print('Firebase sign-in successful: ${userCredential.user?.email}');
      
      return userCredential;
      
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Exception: ${e.code} - ${e.message}');
      rethrow; // Let the UI handle the specific error
    } catch (e) {
      print('General Google Sign-In Error: $e');
      
      // Convert to FirebaseAuthException for consistent error handling
      throw FirebaseAuthException(
        code: 'google-signin-failed',
        message: 'Google sign-in failed. Please try again.',
      );
    }
  }

  Future<UserCredential?> signInWithFacebook() async {
    try {
      print('Starting Facebook Sign-In...');
      
      // Clear any existing session
      await FacebookAuth.instance.logOut();
      
      final LoginResult loginResult = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      print('Facebook login status: ${loginResult.status}');

      switch (loginResult.status) {
        case LoginStatus.success:
          final AccessToken? accessToken = loginResult.accessToken;
          if (accessToken == null) {
            throw FirebaseAuthException(
              code: 'facebook-token-missing',
              message: 'Failed to get Facebook access token',
            );
          }
          
          print('Facebook access token received');
          
          // Create Firebase credential
          final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(accessToken.token);

          print('Signing in to Firebase with Facebook credential...');
          
          // Sign in to Firebase
          final UserCredential userCredential = await _auth.signInWithCredential(facebookAuthCredential);
          
          print('Facebook Firebase sign-in successful: ${userCredential.user?.email}');
          return userCredential;
          
        case LoginStatus.cancelled:
          print('Facebook login was cancelled by user');
          return null;
          
        case LoginStatus.failed:
          print('Facebook login failed: ${loginResult.message}');
          throw FirebaseAuthException(
            code: 'facebook-login-failed',
            message: loginResult.message ?? 'Facebook login failed',
          );
          
        default:
          throw FirebaseAuthException(
            code: 'facebook-unknown-error',
            message: 'Facebook login failed with status: ${loginResult.status}',
          );
      }
      
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Exception: ${e.code} - ${e.message}');
      rethrow; // Let the UI handle the specific error
    } catch (e) {
      print('Facebook Sign-In Error: $e');
      
      throw FirebaseAuthException(
        code: 'facebook-signin-failed',
        message: 'Facebook sign-in failed. Please try again.',
      );
    }
  }

  // Sign out from all services
  Future<void> signOut() async {
    try {
      print('Signing out from all services...');
      
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
        FacebookAuth.instance.logOut(),
      ]);
      
      print('Sign out successful');
    } catch (e) {
      print('Sign Out Error: $e');
      throw FirebaseAuthException(
        code: 'signout-failed',
        message: 'Failed to sign out. Please try again.',
      );
    }
  }

  String getUserDisplayName() {
    final user = _auth.currentUser;
    if (user != null) {
      return user.displayName ?? user.email ?? 'User';
    }
    return 'Guest';
  }

  String? getUserEmail() {
    return _auth.currentUser?.email;
  }

  String? getUserPhotoURL() {
    return _auth.currentUser?.photoURL;
  }

  bool isSignedIn() {
    return _auth.currentUser != null;
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();
}