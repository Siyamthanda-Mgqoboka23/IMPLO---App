import 'package:flutter/material.dart';

import '../services/demo_auth_service.dart';
import 'name_setup_screen.dart';

class VerifyEmailScreen extends StatefulWidget {
  final String email;
  final String verificationCode;

  const VerifyEmailScreen({
    super.key,
    required this.email,
    required this.verificationCode,
  });

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  static const Color deepTeal = Color(0xFF0A7A75);
  static const Color turquoise = Color(0xFF0DBFB0);
  static const Color softMint = Color(0xFFE0FDF9);
  static const Color darkTeal = Color(0xFF061A19);

  final TextEditingController _codeController = TextEditingController();

  late String _currentCode;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentCode = widget.verificationCode;
  }

  @override
  void dispose() {
    _codeController.dispose();
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

  void _verifyCode() async {
    final code = _codeController.text.trim();

    if (code.length != 6) {
      _showMessage('Please enter the 6-digit verification code.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      DemoAuthService.instance.verifyEmail(
        email: widget.email,
        code: code,
      );

      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 450),
          pageBuilder: (_, __, ___) => const NameSetupScreen(),
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

  void _resendCode() {
    try {
      final code = DemoAuthService.instance.resendVerificationCode(widget.email);

      setState(() {
        _currentCode = code;
        _codeController.clear();
      });

      _showMessage('New demo verification code generated.');
    } catch (error) {
      _showMessage(error.toString().replaceFirst('Exception: ', ''));
    }
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
                  const SizedBox(height: 34),
                  Center(
                    child: Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        gradient: const LinearGradient(
                          colors: [
                            deepTeal,
                            turquoise,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: turquoise.withOpacity(0.28),
                            blurRadius: 32,
                            offset: const Offset(0, 14),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.mark_email_read_rounded,
                        color: Colors.white,
                        size: 44,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Center(
                    child: Text(
                      'Verify Your Email',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: darkTeal,
                        fontSize: 31,
                        fontWeight: FontWeight.w900,
                        height: 1.08,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      'Enter the verification code for\n${widget.email}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: darkTeal.withOpacity(0.62),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 1.45,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  _buildDemoCodeCard(),
                  const SizedBox(height: 18),
                  _buildCodeInputCard(),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _verifyCode,
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
                              'Verify Email',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Center(
                    child: TextButton(
                      onPressed: _resendCode,
                      child: const Text(
                        'Resend demo code',
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
            'Email check',
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

  Widget _buildDemoCodeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: turquoise.withOpacity(0.10),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: turquoise.withOpacity(0.24),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              color: turquoise.withOpacity(0.16),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.password_rounded,
              color: deepTeal,
              size: 22,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Demo verification code',
                  style: TextStyle(
                    color: darkTeal,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  _currentCode,
                  style: const TextStyle(
                    color: deepTeal,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeInputCard() {
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
      child: TextField(
        controller: _codeController,
        keyboardType: TextInputType.number,
        maxLength: 6,
        textAlign: TextAlign.center,
        cursorColor: deepTeal,
        style: const TextStyle(
          color: darkTeal,
          fontSize: 24,
          fontWeight: FontWeight.w900,
          letterSpacing: 5,
        ),
        decoration: InputDecoration(
          counterText: '',
          hintText: '000000',
          hintStyle: TextStyle(
            color: darkTeal.withOpacity(0.25),
            letterSpacing: 5,
            fontWeight: FontWeight.w900,
          ),
          filled: true,
          fillColor: const Color(0xFFF6FFFD),
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
          painter: _VerifyPatternPainter(),
        ),
      ),
    );
  }
}

class _VerifyPatternPainter extends CustomPainter {
  const _VerifyPatternPainter();

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
      Offset(size.width * 0.06, size.height * 0.72),
      size.width * 0.30,
      ringPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}