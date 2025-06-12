import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class SocialAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

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
      
      // Get authentication details - handle types properly
      final GoogleSignInAuthentication googleAuth;
      try {
        googleAuth = await googleUser.authentication;
      } catch (e) {
        print('Error getting Google authentication: $e');
        throw Exception('Failed to get Google authentication details');
      }

      // Verify we have the required tokens
      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        throw Exception('Failed to get Google authentication tokens');
      }

      print('Google authentication tokens received');
      
      // Create Firebase credential with proper error handling
      final AuthCredential credential;
      try {
        credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken!,
          idToken: googleAuth.idToken!,
        );
      } catch (e) {
        print('Error creating Google credential: $e');
        throw Exception('Failed to create Google credential');
      }

      print('Signing in to Firebase with Google credential...');
      
      // Sign in to Firebase with proper error handling
      final UserCredential userCredential;
      try {
        userCredential = await _auth.signInWithCredential(credential);
      } catch (e) {
        print('Firebase sign-in error: $e');
        rethrow;
      }
      
      print('Firebase sign-in successful: ${userCredential.user?.email}');
      
      // Verify the user was created properly
      if (userCredential.user == null) {
        throw Exception('Sign-in successful but user is null');
      }
      
      return userCredential;
      
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Exception: ${e.code} - ${e.message}');
      
      switch (e.code) {
        case 'account-exists-with-different-credential':
          throw Exception('This email is already registered with a different sign-in method. Please try email/password or Facebook sign-in.');
        case 'invalid-credential':
          throw Exception('Google sign-in failed. Please try again.');
        case 'operation-not-allowed':
          throw Exception('Google sign-in is not enabled. Please contact support.');
        case 'user-disabled':
          throw Exception('This account has been disabled.');
        case 'user-not-found':
          throw Exception('No account found with this email.');
        case 'network-request-failed':
          throw Exception('Network error. Please check your internet connection.');
        default:
          throw Exception('Google sign-in failed: ${e.message ?? 'Unknown error'}');
      }
    } catch (e) {
      print('General Google Sign-In Error: $e');
      
      // Handle specific error types
      if (e.toString().contains('PlatformException')) {
        throw Exception('Google sign-in service error. Please try again.');
      } else if (e.toString().contains('type cast') || e.toString().contains('List<Object?>')) {
        throw Exception('Authentication service error. Please update the app and try again.');
      } else if (e.toString().contains('network')) {
        throw Exception('Network error. Please check your internet connection.');
      }
      
      throw Exception('Google sign-in failed. Please try again.');
    }
  }

  Future<UserCredential?> signInWithFacebook() async {
    try {
      print('Starting Facebook Sign-In...');
      
      // Clear any existing session
      await FacebookAuth.instance.logOut();
      
      final LoginResult loginResult = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
        loginBehavior: LoginBehavior.webOnly, // More reliable
      );

      print('Facebook login status: ${loginResult.status}');

      switch (loginResult.status) {
        case LoginStatus.success:
          final AccessToken? accessToken = loginResult.accessToken;
          if (accessToken == null) {
            throw Exception('Failed to get Facebook access token');
          }
          
          print('Facebook access token received');
          
          // Get user data with proper error handling
          final Map<String, dynamic> userData;
          try {
            userData = await FacebookAuth.instance.getUserData(
              fields: "name,email,picture,first_name,last_name,id"
            );
            print('Facebook user data: ${userData['name']} (${userData['email']})');
          } catch (e) {
            print('Error getting Facebook user data: $e');
            throw Exception('Failed to get Facebook user information');
          }
          
          // Create Firebase credential
          final OAuthCredential facebookAuthCredential;
          try {
            facebookAuthCredential = FacebookAuthProvider.credential(accessToken.token);
          } catch (e) {
            print('Error creating Facebook credential: $e');
            throw Exception('Failed to create Facebook credential');
          }

          print('Signing in to Firebase with Facebook credential...');
          
          // Sign in to Firebase
          final UserCredential userCredential;
          try {
            userCredential = await _auth.signInWithCredential(facebookAuthCredential);
          } catch (e) {
            print('Firebase Facebook sign-in error: $e');
            rethrow;
          }
          
          print('Facebook Firebase sign-in successful: ${userCredential.user?.email}');
          return userCredential;
          
        case LoginStatus.cancelled:
          print('Facebook login was cancelled by user');
          return null;
          
        case LoginStatus.failed:
          print('Facebook login failed: ${loginResult.message}');
          throw Exception('Facebook login failed: ${loginResult.message ?? 'Unknown error'}');
          
        default:
          throw Exception('Facebook login failed with status: ${loginResult.status}');
      }
      
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Exception: ${e.code} - ${e.message}');
      
      switch (e.code) {
        case 'account-exists-with-different-credential':
          throw Exception('This email is already registered with a different sign-in method. Please try Google or email/password sign-in.');
        case 'invalid-credential':
          throw Exception('Facebook sign-in failed. Please try again.');
        case 'operation-not-allowed':
          throw Exception('Facebook sign-in is not enabled. Please contact support.');
        case 'user-disabled':
          throw Exception('This account has been disabled.');
        default:
          throw Exception('Facebook sign-in failed: ${e.message ?? 'Unknown error'}');
      }
    } catch (e) {
      print('Facebook Sign-In Error: $e');
      
      if (e.toString().contains('FACEBOOK_APP_ID')) {
        throw Exception('Facebook is not properly configured. Please contact support.');
      } else if (e.toString().contains('network')) {
        throw Exception('Network error. Please check your internet connection.');
      }
      
      throw Exception('Facebook sign-in failed. Please try again.');
    }
  }

  // Test method to check if Google Sign-In is working
  Future<bool> testGoogleSignIn() async {
    try {
      await _googleSignIn.signOut(); // Clear any existing session
      final result = await _googleSignIn.signInSilently();
      print('Google Sign-In test result: ${result?.email ?? 'No silent sign-in available'}');
      return true;
    } catch (e) {
      print('Google Sign-In test failed: $e');
      return false;
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
      rethrow;
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