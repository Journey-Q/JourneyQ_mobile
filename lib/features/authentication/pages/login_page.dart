import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:journeyq/core/services/notification_service.dart';
import 'package:journeyq/core/utils/validator.dart';
import 'package:journeyq/core/errors/error_handler.dart';
import 'package:journeyq/core/errors/exception.dart';
import 'package:journeyq/shared/widgets/dialog/show_dialog.dart';
import 'package:journeyq/features/authentication/pages/widget.dart';
import 'package:journeyq/data/repositories/auth_repositories/auth_repository.dart';
import 'package:journeyq/data/repositories/auth_repositories/social_auth.dart';
import 'package:journeyq/data/providers/auth_providers/auth_provider.dart';
import 'package:provider/provider.dart';

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
  late final AuthProvider authProvider;

  @override
  void initState() {
    super.initState();
    authProvider = context.read<AuthProvider>();
  }

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
      final result = await AuthRepository.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      // Verify login was successful and contains required data
      if (result == null || result['accessToken'] == null) {
        throw Exception('Login failed: Invalid response from server');
      }

      // Get user data for personalized welcome message
      final userData = result['user'];
      final userName = userData != null ? userData['name'] : null;

      // Success - show success message with user name if available

      NotificationService.showNotification(
        title: "Welcome back",
        body: "Login successfully",
      );

      if (mounted) {
        authProvider.setStatus(AuthStatus.authenticated);
        context.go('/home');
      }
    } catch (e) {
      // Use existing ErrorHandler pattern
      if (mounted) {
        ErrorHandler.handleError(
          context,
          e is Exception ? e : Exception(e.toString()),
        );
        setState(() => _isLoading = false);
      }
    } finally {
      // Only reset loading state if we're still mounted and haven't already reset it
      if (mounted && _isLoading) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);

    try {
      final userCredential = await _socialAuthService.signInWithGoogle();

      if (userCredential != null) {
        final user = userCredential.user;
        SnackBarService.showSuccess(context, "Login Successful! Welcome back!");

        if (mounted) {
          authProvider.setStatus(AuthStatus.authenticated);
          context.go('/home');
        }
      } else {
        NotificationService.showNotification(title: "Welcome back", body:"Login successfully" );
      }
    } catch (e) {
      ErrorHandler.handleError(context, e is AppException ? e : Exception());
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleAppleSignIn() async {
    setState(() => _isLoading = true);

    try {
      final userCredential = await _socialAuthService.signInWithApple();

      if (userCredential != null) {
        SnackBarService.showSuccess(context, "Login Successful! Welcome back!");

        if (mounted) {
          authProvider.setStatus(AuthStatus.authenticated);
          context.go('/home');
        }
      } else {
        // Handle case where sign-in was cancelled or failed
        SnackBarService.showSuccess(context, "Login Successful! Welcome back!");
      }
    } catch (e) {
      ErrorHandler.handleError(context, e is AppException ? e : Exception());
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
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
              buildLoginHeader(),
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildSocialButton(
          icon: Image.asset('assets/images/google.png', width: 28, height: 28),
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

  Widget buildSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Don\'t have an account? ',
          style: TextStyle(color: Colors.grey[600], fontSize: 16),
        ),
        TextButton(
          onPressed: () => context.push('/signup'),
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
