import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:journeyq/core/utils/validator.dart';
import 'package:journeyq/core/services/notification_service.dart';
import 'package:journeyq/shared/widgets/dialog/show_dialog.dart';
import 'package:journeyq/features/authentication/pages/widget.dart';
import 'package:journeyq/data/repositories/auth_repositories/social_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final SocialAuthService _socialAuthService = SocialAuthService();


  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await Future.delayed(const Duration(seconds: 2));

      NotificationService.showNotification(
        title: "Login Successful! 🎉",
        body: "Welcome back! Your journey continues...",
      );

      if (mounted) {
        // Navigate to home page using GoRouter
        context.go('/home');
      }
    } catch (e) {
      NotificationService.showNotification(
        title: "Login Failed",
        body: "Please check your credentials and try again.",
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login failed: ${e.toString()}'),
            backgroundColor: Colors.red[400],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // Updated LoginPage methods
Future<void> _handleGoogleSignIn() async {
  setState(() => _isLoading = true);
  
  try {
    final userCredential = await _socialAuthService.signInWithGoogle();
    
    if (userCredential != null) {
      // Success
      final user = userCredential.user;
      NotificationService.showNotification(
        title: "Google Sign In Successful! 🎉",
        body: "Welcome, ${user?.displayName ?? 'User'}!",
      );
      
      if (mounted) {
        context.go('/home');
      }
    } else {
      // User cancelled the sign-in
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Google Sign In was cancelled'),
            backgroundColor: Colors.orange[400],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  } catch (e) {
    print('Google Sign In Error: $e');
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Google Sign In failed: ${e.toString()}'),
          backgroundColor: Colors.red[400],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  } finally {
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }
}

Future<void> _handleFacebookSignIn() async {
  setState(() => _isLoading = true);
  
  try {
    final userCredential = await _socialAuthService.signInWithFacebook();
    
    if (userCredential != null) {
      // Success
      final user = userCredential.user;
      NotificationService.showNotification(
        title: "Facebook Sign In Successful! 🎉",
        body: "Welcome, ${user?.displayName ?? 'User'}!",
      );
      
      if (mounted) {
        context.go('/home');
      }
    } else {
      // User cancelled the sign-in
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Facebook Sign In was cancelled'),
            backgroundColor: Colors.orange[400],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  } catch (e) {
    print('Facebook Sign In Error: $e');
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Facebook Sign In failed: ${e.toString()}'),
          backgroundColor: Colors.red[400],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  } finally {
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }
}


  Future<void> _handleAppleSignIn() async {
    try {
      // Simulate Apple Sign In
      await Future.delayed(const Duration(seconds: 1));
      NotificationService.showNotification(
        title: "Apple Sign In",
        body: "Signing in with Apple...",
      );

      if (mounted) {
        // Navigate to home after successful Apple sign in
        context.go('/home');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Apple Sign In failed: ${e.toString()}'),
          backgroundColor: Colors.red[400],
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 32),
              buildHeader(),
              const SizedBox(height: 32),
              buildLoginForm(),
              const SizedBox(height: 32),
              buildLoginButton(),
              const SizedBox(height: 24),
              buildDivider(),
              const SizedBox(height: 24),
              buildSocialButtons(),
              const SizedBox(height: 24),
              buildSignUpLink(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLoginForm() {
    return Container(
      padding: const EdgeInsets.all(5),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            buildEmailField(),
            const SizedBox(height: 20),
            buildPasswordField(),
          ],
        ),
      ),
    );
  }

  // Usage for Email Field
  Widget buildEmailField() {
    return buildCommonTextField(
      controller: _emailController,
      labelText: 'Email Address',
      hintText: 'Enter your email',
      prefixIcon: Icons.email_outlined,
      validator: Validator.validateEmail,
      keyboardType: TextInputType.emailAddress,
    );
  }

  // Usage for Password Field
  Widget buildPasswordField() {
    return buildCommonTextField(
      controller: _passwordController,
      labelText: 'Password',
      hintText: 'Enter your password',
      prefixIcon: Icons.lock_outline,
      validator: Validator.validatePassword,
      obscureText: _obscurePassword,
      suffixIcon: IconButton(
        icon: Container(
          margin: const EdgeInsets.all(12),
          child: Icon(
            _obscurePassword
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: Colors.black,
            size: 20,
          ),
        ),
        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
      ),
    );
  }

  Widget buildLoginButton() {
    return buildPrimaryGradientButton(
      text: 'Sign In',
      onPressed: _handleLogin,
      isLoading: _isLoading,
    );
  }

  Widget buildSocialButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buildSocialButton(
          icon: Image.asset(
            'assets/images/google.png', // Your Google PNG file
            width: 28,
            height: 28,
          ),
          label: 'Google',
          onPressed: _handleGoogleSignIn,
          backgroundColor: Colors.white,
          textColor: Colors.grey[800]!,
          borderColor: Colors.grey[300]!,
        ),
        buildSocialButton(
          icon: Icons.apple,
          label: 'Apple',
          onPressed: _handleAppleSignIn,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          borderColor: Colors.black,
        ),
        buildSocialButton(
          icon: Icons.facebook,
          label: 'Facebook',
          onPressed: _handleFacebookSignIn,
          backgroundColor: const Color(0xFF1877F2),
          textColor: Colors.white,
          borderColor: const Color(0xFF1877F2),
        ),
      ],
    );
  }

  Widget buildSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Don\'t have an account? ',
          style: TextStyle(color: Colors.grey[600], fontSize: 16),
        ),
        TextButton(
          onPressed: () {
            // Use GoRouter push instead of custom animation
            context.push('/signup');
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          ),
          child: const Text(
            'Sign Up',
            style: TextStyle(
              color: Color(0xFF0088cc),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
