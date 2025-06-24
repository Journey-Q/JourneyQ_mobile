import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:journeyq/core/utils/validator.dart';
import 'package:journeyq/core/services/notification_service.dart';
import 'package:journeyq/shared/widgets/dialog/show_dialog.dart';
import 'package:journeyq/features/authentication/pages/widget.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }


    setState(() => _isLoading = true);

    try {
      await Future.delayed(const Duration(seconds: 2));

      NotificationService.showNotification(
        title: "Account Created! 🎉",
        body: "Welcome to JourneyQ! Your adventure begins now...",
      );

      if (mounted) {
        // Navigate to home page using GoRouter
        context.go('/home');
      }
    } catch (e) {
      NotificationService.showNotification(
        title: "Sign Up Failed",
        body: "Please check your information and try again.",
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sign up failed: ${e.toString()}'),
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

  Future<void> _handleGoogleSignIn() async {
    try {
      // Simulate Google Sign In
      await Future.delayed(const Duration(seconds: 1));
      NotificationService.showNotification(
        title: "Google Sign In",
        body: "Signing in with Google...",
      );
      
      if (mounted) {
        // Navigate to home after successful Google sign in
        context.go('/home');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Google Sign In failed: ${e.toString()}'),
          backgroundColor: Colors.red[400],
          behavior: SnackBarBehavior.floating,
        ),
      );
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

  Future<void> _handleFacebookSignIn() async {
    try {
      // Simulate Facebook Sign In
      await Future.delayed(const Duration(seconds: 1));
      NotificationService.showNotification(
        title: "Facebook Sign In",
        body: "Signing in with Facebook...",
      );
      
      if (mounted) {
        // Navigate to home after successful Facebook sign in
        context.go('/home');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Facebook Sign In failed: ${e.toString()}'),
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
              buildHeader(),
              const SizedBox(height: 12),
              buildSignUpForm(),
              const SizedBox(height: 12),
              buildSignUpButton(),
              const SizedBox(height: 12),
              buildDivider(),
              const SizedBox(height: 12),
              buildSocialButtons(),
              const SizedBox(height: 12),
              buildSignInLink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSignUpForm() {
    return Container(
      padding: const EdgeInsets.all(5),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            buildUsernameField(),
            const SizedBox(height: 20),
            buildEmailField(),
            const SizedBox(height: 20),
            buildPasswordField(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Usage for Username Field
  Widget buildUsernameField() {
    return buildCommonTextField(
      controller: _usernameController,
      labelText: 'Username',
      hintText: 'Enter your username',
      prefixIcon: Icons.person_outline,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a username';
        }
        if (value.length < 3) {
          return 'Username must be at least 3 characters';
        }
        if (value.length > 20) {
          return 'Username must be less than 20 characters';
        }
        if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
          return 'Username can only contain letters, numbers, and underscores';
        }
        return null;
      },
      keyboardType: TextInputType.text,
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

  // Usage for Confirm Password Field
  

  Widget buildSignUpButton() {
    return buildPrimaryGradientButton(
      text: 'Sign Up',
      onPressed: _handleSignUp,
      isLoading: _isLoading,
    );
  }

  Widget buildSocialButtons() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      buildSocialButton(
        icon: Image.asset(
          'assets/images/google.png',
          width: 28,
          height: 28,
        ),
        label: 'Google',
        onPressed: _handleGoogleSignIn,
        backgroundColor: Colors.white,
        textColor: Colors.grey[800]!,
        borderColor: Colors.grey[300]!,
      ),
      const SizedBox(width: 32),
      buildSocialButton(
        icon: Icons.apple,
        label: 'Apple',
        onPressed: _handleAppleSignIn,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        borderColor: Colors.black,
      ),
    ],
  );
}

  Widget buildSignInLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account? ',
          style: TextStyle(color: Colors.grey[600], fontSize: 16),
        ),
        TextButton(
          onPressed: () {
            // Use GoRouter pop to go back to login
            context.pop();
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          ),
          child: const Text(
            'Sign In',
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