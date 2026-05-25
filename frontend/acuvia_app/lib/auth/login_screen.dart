import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../shared/providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _rememberMe = false;
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _loginError;

  // ── Theme colors (pulled from the screenshot) ──────────────────────────
  static const Color _bgColor = Color(0xFFD6EAF8); // light-blue page bg
  static const Color _cardColor = Color(0xFFDEEFF8); // card bg
  static const Color _primaryColor = Color(0xFF1A7A9B); // teal-blue button
  static const Color _accentColor = Color(0xFF1A7A9B); // links / checkbox
  static const Color _fieldBorder = Color(0xFFB0C8D8); // input border
  static const Color _hintColor = Color(0xFF8AAABB); // placeholder text

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ── Handlers ────────────────────────────────────────────────────────────

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _loginError = null;
    });

    // call the AuthController via Riverpod
    final success = await ref
        .read(authStateProvider.notifier)
        .login(_emailController.text.trim(), _passwordController.text);

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (success) {
      context.go('/home');
    } else {
      final state = ref.read(authStateProvider);
      final message = state.hasError ? state.error.toString() : 'Login failed';
      setState(() => _loginError = message);
    }
  }

  void _handleGoogleSignIn() {
    // Temporarily disabled to fix the compiler error!
    // We will wire up the real Google Sign-In later.

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Google Sign-In coming soon!')),
    );
  }

  void _handleForgotPassword() {
    context.go('/forgot-password');
  }

  void _handleSignUp() {
    context.go('/register');
  }

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
                // ── Logo ──────────────────────────────────────────────────
                _buildLogo(),
                const SizedBox(height: 36),

                // ── Login Card ───────────────────────────────────────────
                _buildLoginCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Logo widget ──────────────────────────────────────────────────────────
  Widget _buildLogo() {
    return Container(
      width: 90,
      height: 90,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Image.asset('assets/acuvia_logo.png', fit: BoxFit.contain),
      ),
    );
  }

  // ── Login card ───────────────────────────────────────────────────────────
  Widget _buildLoginCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 20,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Title ────────────────────────────────────────────────────
            const Text(
              'LOGIN TO CONTINUE',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.4,
                color: Color(0xFF1A3A4A),
              ),
            ),
            const SizedBox(height: 28),

            if (_loginError != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  border: Border.all(color: Colors.red.shade200),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      color: Colors.red.shade600,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _loginError!,
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

            // ── Email field ──────────────────────────────────────────────
            _buildTextField(
              controller: _emailController,
              hint: 'Email',
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              onChanged: (_) {
                if (_loginError != null) setState(() => _loginError = null);
              },
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Email is required';
                final emailRegex = RegExp(r'^[\w.+-]+@[\w-]+\.[a-z]{2,}$');
                if (!emailRegex.hasMatch(v.trim()))
                  return 'Enter a valid email';
                return null;
              },
            ),
            const SizedBox(height: 16),

            // ── Password field ───────────────────────────────────────────
            _buildTextField(
              controller: _passwordController,
              hint: 'Password',
              prefixIcon: Icons.lock_outline_rounded,
              obscureText: _obscurePassword,
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
              onChanged: (_) {
                if (_loginError != null) setState(() => _loginError = null);
              },
              validator: (v) {
                if (v == null || v.isEmpty) return 'Password is required';
                if (v.length < 6)
                  return 'Password must be at least 6 characters';
                return null;
              },
            ),
            const SizedBox(height: 12),

            // ── Remember me + Forgot password ────────────────────────────
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
                        activeColor: _accentColor,
                        side: const BorderSide(color: _accentColor, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => setState(() => _rememberMe = !_rememberMe),
                      child: const Text(
                        'Remember Me',
                        style: TextStyle(
                          fontSize: 13,
                          color: _accentColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: _handleForgotPassword,
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      fontSize: 13,
                      color: _accentColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ── Login button ─────────────────────────────────────────────
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: _primaryColor.withValues(alpha: 0.6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : const Text(
                        'LOGIN',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.8,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 18),

            // ── Sign up link ─────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'New User? ',
                  style: TextStyle(fontSize: 13, color: Color(0xFF4A7A8A)),
                ),
                GestureDetector(
                  onTap: _handleSignUp,
                  child: const Text(
                    'Sign Up',
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
                Expanded(child: Divider(color: _fieldBorder, thickness: 1)),
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
                Expanded(child: Divider(color: _fieldBorder, thickness: 1)),
              ],
            ),
            const SizedBox(height: 20),

            // ── Google Sign-In button ────────────────────────────────────
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
    Widget? suffixIcon,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
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
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: _fieldBorder, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: _primaryColor, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.8),
        ),
      ),
    );
  }

  // ── Google button ────────────────────────────────────────────────────────
  Widget _buildGoogleButton() {
    return SizedBox(
      height: 52,
      child: OutlinedButton(
        onPressed: _handleGoogleSignIn,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF1A3A4A),
          side: const BorderSide(color: _fieldBorder, width: 1.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Google 'G' logo — drawn with colored text as a zero-dependency fallback.
            // Replace with: Image.asset('assets/icons/google_logo.png', height: 22)
            // once you add the asset.
            Image.asset('assets/google 1.png', height: 22),
            const Text(
              'Sign in with Google',
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
