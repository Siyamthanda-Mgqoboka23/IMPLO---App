import 'package:flutter/material.dart';

import '../services/demo_auth_service.dart';
import 'login_screen.dart';
import 'verify_email_screen.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  static const Color deepTeal = Color(0xFF0A7A75);
  static const Color turquoise = Color(0xFF0DBFB0);
  static const Color softMint = Color(0xFFE0FDF9);
  static const Color darkTeal = Color(0xFF061A19);

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _acceptedTerms = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: deepTeal,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  bool _validateForm() {
    final name = _nameController.text.trim();
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (name.isEmpty) {
      _showMessage('Please enter your name.');
      return false;
    }

    if (username.isEmpty) {
      _showMessage('Please enter a username.');
      return false;
    }

    if (!email.contains('@') || !email.contains('.')) {
      _showMessage('Please enter a valid email address.');
      return false;
    }

    if (password.length < 6) {
      _showMessage('Password must be at least 6 characters.');
      return false;
    }

    if (!_acceptedTerms) {
      _showMessage('Please accept the account agreement.');
      return false;
    }

    return true;
  }

  void _createAccount() async {
    if (!_validateForm()) return;

    setState(() => _isLoading = true);

    try {
      final account = DemoAuthService.instance.createAccount(
        displayName: _nameController.text.trim(),
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 450),
          pageBuilder: (_, __, ___) => VerifyEmailScreen(
            email: account.email,
            verificationCode: account.verificationCode,
          ),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              ),
              child: child,
            );
          },
        ),
      );
    } catch (error) {
      _showMessage(error.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _goToLogin() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 450),
        pageBuilder: (_, __, ___) => const LoginScreen(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ),
            child: child,
          );
        },
      ),
    );
  }

  String _suggestUsername(String name) {
    final cleaned = name.trim().toLowerCase().replaceAll(' ', '_');
    if (cleaned.isEmpty) return '';
    return cleaned;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softMint,
      body: Stack(
        children: [
          _buildBackground(),
          _buildPatternOverlay(),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(22, 18, 22, 26),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTopBar(),
                  const SizedBox(height: 28),
                  const Text(
                    'Create Account',
                    style: TextStyle(
                      color: darkTeal,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      height: 1.08,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Set up your Impilo account so your profile, goals, and preferences can be connected.',
                    style: TextStyle(
                      color: darkTeal.withOpacity(0.62),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 28),
                  _buildFormCard(),
                  const SizedBox(height: 18),
                  _buildAgreementCard(),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _createAccount,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: deepTeal,
                        disabledBackgroundColor: deepTeal.withOpacity(0.35),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
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
                              'Create Account',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: TextButton(
                      onPressed: _goToLogin,
                      child: const Text(
                        'Already have an account? Sign in',
                        style: TextStyle(
                          color: deepTeal,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
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

  Widget _buildTopBar() {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: darkTeal,
            size: 20,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
          decoration: BoxDecoration(
            color: turquoise.withOpacity(0.12),
            borderRadius: BorderRadius.circular(999),
          ),
          child: const Text(
            'Secure setup',
            style: TextStyle(
              color: deepTeal,
              fontSize: 11,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.90),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: turquoise.withOpacity(0.15),
        ),
      ),
      child: Column(
        children: [
          _InputField(
            controller: _nameController,
            icon: Icons.person_rounded,
            label: 'Full name',
            hint: 'Example: Alex Gibson',
            onChanged: (value) {
              if (_usernameController.text.trim().isEmpty) {
                _usernameController.text = _suggestUsername(value);
              }
            },
          ),
          const SizedBox(height: 14),
          _InputField(
            controller: _usernameController,
            icon: Icons.alternate_email_rounded,
            label: 'Username',
            hint: 'Example: alex_gibson',
          ),
          const SizedBox(height: 14),
          _InputField(
            controller: _emailController,
            icon: Icons.email_rounded,
            label: 'Email',
            hint: 'Example: alex@email.com',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 14),
          _InputField(
            controller: _passwordController,
            icon: Icons.lock_rounded,
            label: 'Password',
            hint: 'At least 6 characters',
            obscureText: _obscurePassword,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() => _obscurePassword = !_obscurePassword);
              },
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_off_rounded
                    : Icons.visibility_rounded,
                color: deepTeal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAgreementCard() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _acceptedTerms = !_acceptedTerms;
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.88),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: _acceptedTerms
                ? turquoise.withOpacity(0.55)
                : turquoise.withOpacity(0.16),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: _acceptedTerms,
              activeColor: deepTeal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              onChanged: (value) {
                setState(() {
                  _acceptedTerms = value ?? false;
                });
              },
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 7),
                child: Text(
                  'I agree that this demo account stores my details locally during testing. Real authentication can later be connected to Supabase or Firebase.',
                  style: TextStyle(
                    color: darkTeal.withOpacity(0.68),
                    fontSize: 12.4,
                    fontWeight: FontWeight.w700,
                    height: 1.38,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return const Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE0FDF9),
              Color(0xFFCCFAF7),
              Color(0xFFFFFFFF),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPatternOverlay() {
    return const Positioned.fill(
      child: IgnorePointer(
        child: CustomPaint(
          painter: _AuthPatternPainter(),
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final IconData icon;
  final String label;
  final String hint;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;

  const _InputField({
    required this.controller,
    required this.icon,
    required this.label,
    required this.hint,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.onChanged,
  });

  static const Color deepTeal = Color(0xFF0A7A75);
  static const Color turquoise = Color(0xFF0DBFB0);
  static const Color darkTeal = Color(0xFF061A19);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      cursorColor: deepTeal,
      onChanged: onChanged,
      style: const TextStyle(
        color: darkTeal,
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          color: deepTeal,
          size: 21,
        ),
        suffixIcon: suffixIcon,
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF6FFFD),
        labelStyle: TextStyle(
          color: darkTeal.withOpacity(0.55),
          fontWeight: FontWeight.w700,
        ),
        hintStyle: TextStyle(
          color: darkTeal.withOpacity(0.32),
          fontWeight: FontWeight.w600,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: turquoise.withOpacity(0.16),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: turquoise.withOpacity(0.16),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: turquoise.withOpacity(0.70),
            width: 1.4,
          ),
        ),
      ),
    );
  }
}

class _AuthPatternPainter extends CustomPainter {
  const _AuthPatternPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1
      ..color = const Color(0xFF0DBFB0).withOpacity(0.08);

    canvas.drawCircle(
      Offset(size.width * 0.92, size.height * 0.08),
      size.width * 0.45,
      ringPaint,
    );

    canvas.drawCircle(
      Offset(size.width * 0.05, size.height * 0.72),
      size.width * 0.30,
      ringPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}