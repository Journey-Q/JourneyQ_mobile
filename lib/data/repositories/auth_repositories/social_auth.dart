import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:journeyq/data/repositories/auth_repositories/auth_repository.dart';
import 'package:journeyq/core/errors/exception.dart';

class SocialAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);

  Future<UserCredential?> signInWithGoogle() async {
  try {
    // Clear any existing session first
    await _googleSignIn.signOut();
    
    // Start fresh sign-in process
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    
    if (googleUser == null) {
      // User cancelled the sign-in
      return null;
    }
    
    // Get authentication details with retry logic
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    
    // Verify we have the required tokens
    if (googleAuth.accessToken == null || googleAuth.idToken == null) {
      throw FirebaseAuthException(
        code: 'missing-auth-token',
        message: 'Failed to get Google authentication tokens',
      );
    }
    
    // Create Firebase credential
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken!,
      idToken: googleAuth.idToken!,
    );
    
    // Sign in to Firebase
    final UserCredential userCredential = await _auth.signInWithCredential(
      credential,
    );
    
    // Authenticate with backend and handle response
    try {
      final backendResponse = await AuthRepository.loginWithGoogle(googleUser);
      
      // Verify backend authentication was successful
      if (backendResponse == null || backendResponse['accessToken'] == null) {
        throw FirebaseAuthException(
          code: 'backend-auth-failed',
          message: 'Backend authentication failed',
        );
      }
      
      // Backend auth successful, return the Firebase credential
      return userCredential;
      
    } catch (e) {
      // Backend auth failed, sign out from Firebase to maintain consistency
      await _auth.signOut();
      await _googleSignIn.signOut();
      
      // Re-throw as FirebaseAuthException for consistent error handling
      if (e is FirebaseAuthException) {
        rethrow;
      } else {
        throw FirebaseAuthException(
          code: 'backend-auth-failed',
          message: 'Backend authentication failed: ${e.toString()}',
        );
      }
    }
    
  } on FirebaseAuthException catch (e) {
    // Clean up on Firebase auth failure
    await _googleSignIn.signOut();
    rethrow; // Let the UI handle the specific error
  } catch (e) {
    // Clean up on any other failure
    await _googleSignIn.signOut();
    await _auth.signOut();
    
    // Convert to FirebaseAuthException for consistent error handling
    throw FirebaseAuthException(
      code: 'google-signin-failed',
      message: 'Google sign-in failed. Please try again.',
    );
  }
}

  Future<UserCredential?> signInWithApple() async {
    // try {
    //   // Request credential for the currently signed in Apple account
    //   final appleCredential = await SignInWithApple.getAppleIDCredential(
    //     scopes: [
    //       AppleIDAuthorizationScopes.email,
    //       AppleIDAuthorizationScopes.fullName,
    //     ],
    //   );

    //   // Create an `OAuthCredential` from the credential returned by Apple
    //   final oauthCredential = OAuthProvider("apple.com").credential(
    //     idToken: appleCredential.identityToken,
    //     accessToken: appleCredential.authorizationCode,
    //   );

    //   // Sign in the user with Firebase
    //   final UserCredential userCredential = await _auth.signInWithCredential(oauthCredential);

    //   // Update display name if available and not already set
    //   if (userCredential.user != null &&
    //       userCredential.user!.displayName == null &&
    //       appleCredential.givenName != null &&
    //       appleCredential.familyName != null) {

    //     final displayName = '${appleCredential.givenName} ${appleCredential.familyName}';
    //     await userCredential.user!.updateDisplayName(displayName);
    //   }

    //   return userCredential;

    // } on SignInWithAppleException catch (e) {

    //   // Convert to FirebaseAuthException for consistent error handling
    //   throw FirebaseAuthException(
    //     code: 'apple-signin-failed',
    //     message: 'Apple sign-in failed',
    //   );
    // } on FirebaseAuthException catch (e) {
    //   rethrow; // Let the UI handle the specific error
    // } catch (e) {
    //   // Convert to FirebaseAuthException for consistent error handling
    //   throw FirebaseAuthException(
    //     code: 'apple-signin-failed',
    //     message: 'Apple sign-in failed. Please try again.',
    //   );
    // }
  }

  // Sign out from all services
  Future<void> signOut() async {
    try {
      await Future.wait([_auth.signOut(), _googleSignIn.signOut()]);
    } catch (e) {
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
