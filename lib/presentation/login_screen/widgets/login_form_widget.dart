import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../core/services/firebase_auth_service.dart';

class LoginFormWidget extends StatefulWidget {
  const LoginFormWidget({super.key});

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = FirebaseAuthService();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoading = false;
  String? _authError;

  bool _isGoogleLoading = false;
  bool _isAppleLoading = false;
  bool _isGuestLoading = false;

  bool get _anyLoading =>
      _isLoading || _isGoogleLoading || _isAppleLoading || _isGuestLoading;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _navigateToDashboard() {
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.dashboardScreen,
      (route) => false,
    );
  }

  Future<void> _handleSignIn() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _authError = null;
    });

    try {
      await _authService.signIn(
        email: _emailController.text,
        password: _passwordController.text,
      );
      _navigateToDashboard();
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
        _authError = _authService.getFriendlyError(e);
      });
    } catch (_) {
      setState(() {
        _isLoading = false;
        _authError = 'Something went wrong. Please try again.';
      });
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isGoogleLoading = true;
      _authError = null;
    });
    try {
      final result = await _authService.signInWithGoogle();
      if (result == null) {
        setState(() => _isGoogleLoading = false);
        return;
      }
      _navigateToDashboard();
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isGoogleLoading = false;
        _authError = _authService.getFriendlyError(e);
      });
    } catch (_) {
      setState(() {
        _isGoogleLoading = false;
        _authError = 'Google sign-in failed. Please try again.';
      });
    }
  }

  Future<void> _handleAppleSignIn() async {
    setState(() {
      _isAppleLoading = true;
      _authError = null;
    });
    try {
      final result = await _authService.signInWithApple();
      if (result == null) {
        setState(() => _isAppleLoading = false);
        return;
      }
      _navigateToDashboard();
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isAppleLoading = false;
        _authError = _authService.getFriendlyError(e);
      });
    } catch (_) {
      setState(() {
        _isAppleLoading = false;
        _authError = 'Apple sign-in failed. Please try again.';
      });
    }
  }

  Future<void> _handleGuestSignIn() async {
    setState(() {
      _isGuestLoading = true;
      _authError = null;
    });
    try {
      await _authService.signInAnonymously();
      _navigateToDashboard();
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isGuestLoading = false;
        _authError = _authService.getFriendlyError(e);
      });
    } catch (_) {
      setState(() {
        _isGuestLoading = false;
        _authError = 'Guest sign-in failed. Please try again.';
      });
    }
  }

  Future<void> _handleForgotPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      setState(() => _authError = 'Enter your email above first.');
      return;
    }
    try {
      await _authService.sendPasswordReset(email);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password reset email sent to $email')),
      );
    } on FirebaseAuthException catch (e) {
      setState(() => _authError = _authService.getFriendlyError(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Email field
          Text(
            'Email Address',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: AppTheme.onSurface,
            ),
            decoration: InputDecoration(
              hintText: 'Enter your email',
              prefixIcon: const Icon(
                Icons.email_outlined,
                size: 20,
                color: AppTheme.muted,
              ),
              filled: true,
              fillColor: AppTheme.surfaceVariant,
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Email is required';
              if (!v.contains('@')) return 'Enter a valid email address';
              return null;
            },
          ),
          const SizedBox(height: 20),

          // Password field
          Text(
            'Password',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: AppTheme.onSurface,
            ),
            decoration: InputDecoration(
              hintText: 'Enter your password',
              prefixIcon: const Icon(
                Icons.lock_outline_rounded,
                size: 20,
                color: AppTheme.muted,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 20,
                  color: AppTheme.muted,
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
              filled: true,
              fillColor: AppTheme.surfaceVariant,
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Password is required';
              if (v.length < 6) return 'Password must be at least 6 characters';
              return null;
            },
          ),
          const SizedBox(height: 12),

          // Remember me + Forgot password row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: Checkbox(
                      value: _rememberMe,
                      onChanged: (v) =>
                          setState(() => _rememberMe = v ?? false),
                      activeColor: AppTheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Remember me',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: AppTheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: _handleForgotPassword,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Forgot password?',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primary,
                  ),
                ),
              ),
            ],
          ),

          // Auth error
          if (_authError != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.errorContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    size: 16,
                    color: AppTheme.error,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _authError!,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: AppTheme.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 24),

          // Sign in button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _anyLoading ? null : _handleSignIn,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      'Sign In to SME360',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),

          const SizedBox(height: 16),

          // Divider
          Row(
            children: [
              const Expanded(child: Divider()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'or continue with',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: AppTheme.muted,
                  ),
                ),
              ),
              const Expanded(child: Divider()),
            ],
          ),

          const SizedBox(height: 16),

          // Google Sign-In button
          _SocialButton(
            onPressed: _anyLoading ? null : _handleGoogleSignIn,
            isLoading: _isGoogleLoading,
            icon: Image.network(
              'https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg',
              width: 20,
              height: 20,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.g_mobiledata_rounded,
                size: 24,
                color: Colors.red,
              ),
            ),
            label: 'Sign in with Google',
          ),

          const SizedBox(height: 12),

          // Apple Sign-In button
          _SocialButton(
            onPressed: _anyLoading ? null : _handleAppleSignIn,
            isLoading: _isAppleLoading,
            icon: const Icon(
              Icons.apple,
              size: 22,
              color: Colors.black87,
            ),
            label: 'Sign in with Apple',
          ),

          const SizedBox(height: 20),

          // Continue as Guest
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: _anyLoading ? null : _handleGuestSignIn,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isGuestLoading
                  ? SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppTheme.muted,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person_outline_rounded,
                          size: 18,
                          color: AppTheme.muted,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Continue as Guest',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.muted,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.onPressed,
    required this.isLoading,
    required this.icon,
    required this.label,
  });

  final VoidCallback? onPressed;
  final bool isLoading;
  final Widget icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: AppTheme.outlineVariant),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: AppTheme.surface,
        ),
        child: isLoading
            ? SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: AppTheme.primary,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon,
                  const SizedBox(width: 10),
                  Text(
                    label,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.onSurface,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
