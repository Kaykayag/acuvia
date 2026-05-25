import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../shared/providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey                   = GlobalKey<FormState>();
  final _nameController            = TextEditingController();
  final _emailController           = TextEditingController();
  final _passwordController        = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool    _obscurePassword        = true;
  bool    _obscureConfirmPassword = true;
  bool    _isLoading              = false;
  bool    _agreeToTerms           = false;
  String? _registerError;           // ← shown above the Full Name field

  // ── Theme colors ───────────────────────────────────────────────────────
  static const Color _bgColor      = Color(0xFFD6EAF8);
  static const Color _cardColor    = Color(0xFFDEEFF8);
  static const Color _primaryColor = Color(0xFF1A7A9B);
  static const Color _accentColor  = Color(0xFF1A7A9B);
  static const Color _fieldBorder  = Color(0xFFB0C8D8);
  static const Color _hintColor    = Color(0xFF8AAABB);

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // ── Handlers ────────────────────────────────────────────────────────────
  Future<void> _handleRegister() async {
    // Clear previous error
    setState(() => _registerError = null);

    if (!_formKey.currentState!.validate()) return;

    if (!_agreeToTerms) {
      setState(() =>
          _registerError = 'Please agree to the Terms & Conditions.');
      return;
    }

    setState(() => _isLoading = true);

    final success = await ref.read(authStateProvider.notifier).register(
          _emailController.text.trim(),
          _passwordController.text,
          fullName: _nameController.text.trim(),
        );

    setState(() => _isLoading = false);
    if (!mounted) return;

    if (success) {
      context.go('/home');
    } else {
      final authState = ref.read(authStateProvider);
      setState(() {
        _registerError = _friendlyError(
          authState.hasError ? authState.error.toString() : '',
        );
      });
    }
  }

  String _friendlyError(String error) {
    if (error.contains('400') || error.contains('already registered')) {
      return 'This email is already registered. Try logging in.';
    }
    if (error.contains('SocketException') || error.contains('connect')) {
      return 'Cannot reach server. Check your connection.';
    }
    return 'Registration failed. Please try again.';
  }

  void _handleGoogleSignUp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Google Sign-Up coming soon!')),
    );
  }

  void _handleLogin() => context.go('/login');

  // ── Build ────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLogo(),
                const SizedBox(height: 36),
                _buildRegisterCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Logo ─────────────────────────────────────────────────────────────────
  Widget _buildLogo() {
    return Container(
      width: 90,
      height: 90,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
              color: Color(0x1A000000), blurRadius: 12, offset: Offset(0, 4)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Image.asset('assets/acuvia_logo.png', fit: BoxFit.contain),
      ),
    );
  }

  // ── Register card ────────────────────────────────────────────────────────
  Widget _buildRegisterCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
              color: Color(0x1A000000), blurRadius: 20, offset: Offset(0, 6)),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Title ────────────────────────────────────────────────────
            const Text(
              'CREATE ACCOUNT',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.4,
                color: Color(0xFF1A3A4A),
              ),
            ),
            const SizedBox(height: 28),

            // ── Inline error banner (above Full Name) ────────────────────
            if (_registerError != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  border: Border.all(color: Colors.red.shade200),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline_rounded,
                        color: Colors.red.shade600, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _registerError!,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.red.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
            ],

            // ── Full name ────────────────────────────────────────────────
            _buildTextField(
              controller: _nameController,
              hint: 'Full Name',
              prefixIcon: Icons.person_outline_rounded,
              keyboardType: TextInputType.name,
              hasError: _registerError != null,
              onChanged: (_) {
                if (_registerError != null) {
                  setState(() => _registerError = null);
                }
              },
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Full name is required';
                if (v.trim().length < 2) return 'Enter a valid name';
                return null;
              },
            ),
            const SizedBox(height: 16),

            // ── Email ────────────────────────────────────────────────────
            _buildTextField(
              controller: _emailController,
              hint: 'Email',
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              hasError: _registerError != null,
              onChanged: (_) {
                if (_registerError != null) {
                  setState(() => _registerError = null);
                }
              },
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Email is required';
                final emailRegex = RegExp(r'^[\w.+-]+@[\w-]+\.[a-z]{2,}$');
                if (!emailRegex.hasMatch(v.trim())) {
                  return 'Enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // ── Password ─────────────────────────────────────────────────
            _buildTextField(
              controller: _passwordController,
              hint: 'Password',
              prefixIcon: Icons.lock_outline_rounded,
              obscureText: _obscurePassword,
              hasError: _registerError != null,
              onChanged: (_) {
                if (_registerError != null) {
                  setState(() => _registerError = null);
                }
              },
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: _hintColor,
                  size: 20,
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Password is required';
                if (v.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // ── Confirm password ─────────────────────────────────────────
            _buildTextField(
              controller: _confirmPasswordController,
              hint: 'Confirm Password',
              prefixIcon: Icons.lock_outline_rounded,
              obscureText: _obscureConfirmPassword,
              hasError: _registerError != null,
              onChanged: (_) {
                if (_registerError != null) {
                  setState(() => _registerError = null);
                }
              },
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: _hintColor,
                  size: 20,
                ),
                onPressed: () => setState(
                    () => _obscureConfirmPassword = !_obscureConfirmPassword),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) {
                  return 'Please confirm your password';
                }
                if (v != _passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // ── Terms & Conditions ───────────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: Checkbox(
                    value: _agreeToTerms,
                    onChanged: (v) {
                      setState(() {
                        _agreeToTerms = v ?? false;
                        if (_agreeToTerms) _registerError = null;
                      });
                    },
                    activeColor: _accentColor,
                    side: BorderSide(
                      color: _registerError != null && !_agreeToTerms
                          ? Colors.red.shade400
                          : _accentColor,
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() {
                      _agreeToTerms = !_agreeToTerms;
                      if (_agreeToTerms) _registerError = null;
                    }),
                    child: RichText(
                      text: const TextSpan(
                        text: 'I agree to the ',
                        style: TextStyle(
                            fontSize: 12, color: Color(0xFF4A7A8A)),
                        children: [
                          TextSpan(
                            text: 'Terms & Conditions',
                            style: TextStyle(
                              color: _accentColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ── Sign Up button ───────────────────────────────────────────
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleRegister,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor:
                      _primaryColor.withValues(alpha: 0.6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2.5),
                      )
                    : const Text(
                        'SIGN UP',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.8,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 18),

            // ── Already have account ─────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Already have an account? ',
                  style:
                      TextStyle(fontSize: 13, color: Color(0xFF4A7A8A)),
                ),
                GestureDetector(
                  onTap: _handleLogin,
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 13,
                      color: _accentColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ── OR divider ───────────────────────────────────────────────
            Row(
              children: [
                Expanded(
                    child: Divider(color: _fieldBorder, thickness: 1)),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'OR',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF8AAABB),
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                Expanded(
                    child: Divider(color: _fieldBorder, thickness: 1)),
              ],
            ),
            const SizedBox(height: 20),

            // ── Google Sign-Up ───────────────────────────────────────────
            _buildGoogleButton(),
          ],
        ),
      ),
    );
  }

  // ── Reusable text field ──────────────────────────────────────────────────
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    bool hasError = false,
    Widget? suffixIcon,
    ValueChanged<String>? onChanged,
    String? Function(String?)? validator,
  }) {
    final errorBorderSide =
        BorderSide(color: Colors.red.shade400, width: 1.5);
    final normalBorderSide =
        const BorderSide(color: _fieldBorder, width: 1.2);
    final focusBorderSide =
        const BorderSide(color: _primaryColor, width: 1.8);

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      onChanged: onChanged,
      style: const TextStyle(fontSize: 14, color: Color(0xFF1A3A4A)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: _hintColor, fontSize: 14),
        prefixIcon: Icon(prefixIcon, color: _hintColor, size: 20),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: hasError ? errorBorderSide : normalBorderSide,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: hasError ? errorBorderSide : focusBorderSide,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide:
              const BorderSide(color: Colors.redAccent, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide:
              const BorderSide(color: Colors.redAccent, width: 1.8),
        ),
      ),
    );
  }

  // ── Google button ────────────────────────────────────────────────────────
  Widget _buildGoogleButton() {
    return SizedBox(
      height: 52,
      child: OutlinedButton(
        onPressed: _handleGoogleSignUp,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF1A3A4A),
          side: const BorderSide(color: _fieldBorder, width: 1.2),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30)),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/google 1.png', height: 22),
            const SizedBox(width: 12),
            const Text(
              'Sign up with Google',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A3A4A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}