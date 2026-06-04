import 'package:flutter/material.dart';
import 'auth_welcome_screen.dart';

class PurposeScreen extends StatefulWidget {
  const PurposeScreen({super.key});

  @override
  State<PurposeScreen> createState() => _PurposeScreenState();
}

class _PurposeScreenState extends State<PurposeScreen> {
  static const Color deepTeal = Color(0xFF0A7A75);
  static const Color turquoise = Color(0xFF0DBFB0);
  static const Color lightAqua = Color(0xFFCCFAF7);
  static const Color softMint = Color(0xFFE0FDF9);
  static const Color darkTeal = Color(0xFF061A19);

  final ScrollController _scrollController = ScrollController();

  bool _hasReachedBottom = false;
  bool _hasAcceptedDisclaimer = false;

  bool get _canContinue => _hasReachedBottom && _hasAcceptedDisclaimer;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (!_scrollController.hasClients) return;

      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.offset;

      if (currentScroll >= maxScroll - 20 && !_hasReachedBottom) {
        setState(() {
          _hasReachedBottom = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _handleContinue() {
    if (!_canContinue) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: darkTeal,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          content: const Text(
            'Please read the full notice and tick the agreement box first.',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
      return;
    }

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 700),
        pageBuilder: (_, __, ___) => AuthWelcomeScreen(),
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
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 26),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: deepTeal,
                              size: 20,
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        Container(
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                deepTeal,
                                turquoise,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: turquoise.withOpacity(0.30),
                                blurRadius: 34,
                                offset: const Offset(0, 15),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.verified_user_rounded,
                            color: Colors.white,
                            size: 46,
                          ),
                        ),

                        const SizedBox(height: 28),

                        const Text(
                          'Before We Begin',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: darkTeal,
                            fontSize: 31,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.2,
                            height: 1.1,
                          ),
                        ),

                        const SizedBox(height: 12),

                        Text(
                          'Please read this carefully before using Impilo.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: darkTeal.withOpacity(0.68),
                            fontSize: 14.5,
                            fontWeight: FontWeight.w600,
                            height: 1.45,
                          ),
                        ),

                        const SizedBox(height: 24),

                        const _PurposeCard(
                          icon: Icons.psychology_alt_rounded,
                          title: 'AI life coaching',
                          description:
                              'Impilo can help you reflect, plan, stay motivated, and build better routines.',
                        ),

                        const SizedBox(height: 12),

                        const _PurposeCard(
                          icon: Icons.favorite_rounded,
                          title: 'Wellness support',
                          description:
                              'You can use Impilo for check-ins, encouragement, mood tracking, and self-improvement.',
                        ),

                        const SizedBox(height: 12),

                        const _PurposeCard(
                          icon: Icons.health_and_safety_rounded,
                          title: 'Not a medical service',
                          description:
                              'Impilo is not a medical practice and is not a replacement for a doctor, therapist, counsellor, psychologist, psychiatrist, emergency service, or other licensed professional.',
                        ),

                        const SizedBox(height: 12),

                        const _PurposeCard(
                          icon: Icons.warning_amber_rounded,
                          title: 'Emergency situations',
                          description:
                              'Impilo is not designed for emergencies. If you are in danger, feel unsafe, or need urgent help, contact local emergency services or someone you trust immediately.',
                        ),

                        const SizedBox(height: 12),

                        const _PurposeCard(
                          icon: Icons.lock_rounded,
                          title: 'Your responsibility',
                          description:
                              'By continuing, you understand that Impilo gives general coaching support only. You remain responsible for your choices, actions, and seeking professional help when needed.',
                        ),

                        const SizedBox(height: 20),

                        _buildReadStatus(),

                        const SizedBox(height: 14),

                        _buildAgreementBox(),

                        const SizedBox(height: 110),
                      ],
                    ),
                  ),
                ),

                _buildBottomActionArea(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadStatus() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: _hasReachedBottom
            ? turquoise.withOpacity(0.12)
            : Colors.white.withOpacity(0.72),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: _hasReachedBottom
              ? turquoise.withOpacity(0.35)
              : darkTeal.withOpacity(0.08),
        ),
      ),
      child: Row(
        children: [
          Icon(
            _hasReachedBottom
                ? Icons.check_circle_rounded
                : Icons.keyboard_arrow_down_rounded,
            color: _hasReachedBottom ? deepTeal : darkTeal.withOpacity(0.45),
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _hasReachedBottom
                  ? 'You have reached the end of the notice.'
                  : 'Scroll to the bottom to unlock the agreement box.',
              style: TextStyle(
                color: _hasReachedBottom
                    ? deepTeal
                    : darkTeal.withOpacity(0.58),
                fontSize: 12.2,
                fontWeight: FontWeight.w700,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAgreementBox() {
    final bool canTick = _hasReachedBottom;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 250),
      opacity: canTick ? 1.0 : 0.45,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.88),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _hasAcceptedDisclaimer
                ? turquoise.withOpacity(0.45)
                : darkTeal.withOpacity(0.08),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: _hasAcceptedDisclaimer,
              activeColor: deepTeal,
              checkColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              onChanged: canTick
                  ? (value) {
                      setState(() {
                        _hasAcceptedDisclaimer = value ?? false;
                      });
                    }
                  : null,
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 7),
                child: Text(
                  'I confirm that I have read and understood that Impilo is an AI life coach and wellness companion, not a medical practice, not therapy, and not emergency support.',
                  style: TextStyle(
                    color: darkTeal.withOpacity(0.72),
                    fontSize: 12.4,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActionArea() {
    return Container(
      padding: const EdgeInsets.fromLTRB(26, 14, 26, 22),
      decoration: BoxDecoration(
        color: softMint.withOpacity(0.94),
        boxShadow: [
          BoxShadow(
            color: deepTeal.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _canContinue ? _handleContinue : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: deepTeal,
                disabledBackgroundColor: deepTeal.withOpacity(0.28),
                foregroundColor: Colors.white,
                disabledForegroundColor: Colors.white.withOpacity(0.55),
                elevation: 0,
                shadowColor: turquoise.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: Text(
                _canContinue ? 'Continue to Account Setup' : 'Read & Accept to Continue',
                style: const TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          Text(
            'This acceptance can later be saved securely with your account.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: darkTeal.withOpacity(0.45),
              fontSize: 10.8,
              fontWeight: FontWeight.w500,
              height: 1.3,
            ),
          ),
        ],
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
    return Positioned.fill(
      child: IgnorePointer(
        child: CustomPaint(
          painter: _PurposePatternPainter(),
        ),
      ),
    );
  }
}

class _PurposeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _PurposeCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  static const Color deepTeal = Color(0xFF0A7A75);
  static const Color turquoise = Color(0xFF0DBFB0);
  static const Color darkTeal = Color(0xFF061A19);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.88),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: turquoise.withOpacity(0.14),
        ),
        boxShadow: [
          BoxShadow(
            color: deepTeal.withOpacity(0.06),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: darkTeal,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  description,
                  style: TextStyle(
                    color: darkTeal.withOpacity(0.58),
                    fontSize: 12.3,
                    fontWeight: FontWeight.w500,
                    height: 1.34,
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

class _PurposePatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1
      ..color = const Color(0xFF0DBFB0).withOpacity(0.10);

    canvas.drawCircle(
      Offset(size.width * 0.96, size.height * 0.08),
      size.width * 0.48,
      ringPaint,
    );

    ringPaint.color = const Color(0xFF0A7A75).withOpacity(0.065);
    canvas.drawCircle(
      Offset(size.width * 0.90, size.height * 0.10),
      size.width * 0.30,
      ringPaint,
    );

    final Paint bubblePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = const Color(0xFF0A7A75).withOpacity(0.07);

    final Rect bubble = Rect.fromLTWH(
      size.width * 0.07,
      size.height * 0.18,
      58,
      38,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(bubble, const Radius.circular(16)),
      bubblePaint,
    );

    final Path tail = Path()
      ..moveTo(bubble.left + 14, bubble.bottom)
      ..lineTo(bubble.left + 7, bubble.bottom + 8)
      ..lineTo(bubble.left + 24, bubble.bottom);

    canvas.drawPath(tail, bubblePaint);

    final Paint pulsePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.35
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFF0A7A75).withOpacity(0.06);

    final Path pulse = Path()
      ..moveTo(size.width * 0.10, size.height * 0.62)
      ..lineTo(size.width * 0.20, size.height * 0.62)
      ..lineTo(size.width * 0.24, size.height * 0.57)
      ..lineTo(size.width * 0.30, size.height * 0.68)
      ..lineTo(size.width * 0.36, size.height * 0.54)
      ..lineTo(size.width * 0.42, size.height * 0.62)
      ..lineTo(size.width * 0.52, size.height * 0.62);

    canvas.drawPath(pulse, pulsePaint);

    final Paint wavePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFF0DBFB0).withOpacity(0.07);

    final Path wave = Path()
      ..moveTo(0, size.height * 0.82)
      ..cubicTo(
        size.width * 0.28,
        size.height * 0.76,
        size.width * 0.55,
        size.height * 0.91,
        size.width,
        size.height * 0.80,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(wave, wavePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}