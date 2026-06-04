import 'package:flutter/material.dart';

import 'create_account_screen.dart';
import 'login_screen.dart';

class AuthWelcomeScreen extends StatelessWidget {
  const AuthWelcomeScreen({super.key});

  static const Color deepTeal = Color(0xFF0A7A75);
  static const Color turquoise = Color(0xFF0DBFB0);
  static const Color softMint = Color(0xFFE0FDF9);
  static const Color darkTeal = Color(0xFF061A19);

  void _goToCreateAccount(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 450),
        pageBuilder: (_, __, ___) => const CreateAccountScreen(),
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

  void _goToLogin(BuildContext context) {
    Navigator.of(context).push(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softMint,
      body: Stack(
        children: [
          _buildBackground(),
          _buildPatternOverlay(),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(22, 18, 22, 24),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - 42,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          const SizedBox(height: 18),

                          _buildLogo(),

                          const SizedBox(height: 24),

                          const Text(
                            'Welcome to Impilo',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: darkTeal,
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              height: 1.08,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            'Create an account or sign in so Impilo can remember your profile, goals, preferences, and coaching setup.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: darkTeal.withOpacity(0.62),
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                              height: 1.42,
                            ),
                          ),

                          const SizedBox(height: 24),

                          const _InfoCard(
                            icon: Icons.person_add_alt_rounded,
                            title: 'Personal account',
                            subtitle:
                                'Your name, email, username, and coach setup can reflect in your profile.',
                          ),

                          const SizedBox(height: 12),

                          const _InfoCard(
                            icon: Icons.mark_email_read_rounded,
                            title: 'Email verification',
                            subtitle:
                                'For now, Impilo will simulate verification so you can test the full flow.',
                          ),

                          const Spacer(),

                          const SizedBox(height: 24),

                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () => _goToCreateAccount(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: deepTeal,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              child: const Text(
                                'Create Account',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: OutlinedButton(
                              onPressed: () => _goToLogin(context),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: deepTeal,
                                side: BorderSide(
                                  color: turquoise.withOpacity(0.45),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              child: const Text(
                                'I Already Have an Account',
                                style: TextStyle(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 4),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 88,
      height: 88,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          colors: [
            deepTeal,
            turquoise,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: turquoise.withOpacity(0.26),
            blurRadius: 30,
            offset: const Offset(0, 13),
          ),
        ],
      ),
      child: const Icon(
        Icons.verified_user_rounded,
        color: Colors.white,
        size: 40,
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

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  static const Color deepTeal = Color(0xFF0A7A75);
  static const Color turquoise = Color(0xFF0DBFB0);
  static const Color darkTeal = Color(0xFF061A19);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.88),
        borderRadius: BorderRadius.circular(23),
        border: Border.all(
          color: turquoise.withOpacity(0.15),
        ),
        boxShadow: [
          BoxShadow(
            color: deepTeal.withOpacity(0.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: turquoise.withOpacity(0.12),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              icon,
              color: deepTeal,
              size: 22,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: darkTeal,
                    fontSize: 14.3,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  subtitle,
                  style: TextStyle(
                    color: darkTeal.withOpacity(0.58),
                    fontSize: 11.8,
                    fontWeight: FontWeight.w600,
                    height: 1.33,
                  ),
                ),
              ],
            ),
          ),
        ],
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
      Offset(size.width * 0.95, size.height * 0.08),
      size.width * 0.46,
      ringPaint,
    );

    canvas.drawCircle(
      Offset(size.width * 0.08, size.height * 0.68),
      size.width * 0.30,
      ringPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}