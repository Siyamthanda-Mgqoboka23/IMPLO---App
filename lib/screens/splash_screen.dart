import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'purpose_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  static const Color deepTeal = Color(0xFF0A7A75);
  static const Color turquoise = Color(0xFF0DBFB0);
  static const Color lightAqua = Color(0xFFCCFAF7);
  static const Color darkTeal = Color(0xFF061A19);

  AnimationController? _introController;
  AnimationController? _floatController;
  AnimationController? _loopController;

  Animation<double>? _logoFade;
  Animation<double>? _logoScale;
  Animation<double>? _textFade;
  Animation<Offset>? _textSlide;
  Animation<double>? _taglineFade;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: lightAqua,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    _setupAnimations();
    _navigateToPurpose();
  }

  void _setupAnimations() {
    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    );

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat(reverse: true);

    _loopController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();

    _logoFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _introController!,
        curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
      ),
    );

    _logoScale = Tween<double>(begin: 0.72, end: 1).animate(
      CurvedAnimation(
        parent: _introController!,
        curve: const Interval(0.05, 0.55, curve: Curves.easeOutBack),
      ),
    );

    _textFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _introController!,
        curve: const Interval(0.35, 0.70, curve: Curves.easeOut),
      ),
    );

    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.30),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _introController!,
        curve: const Interval(0.35, 0.75, curve: Curves.easeOutCubic),
      ),
    );

    _taglineFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _introController!,
        curve: const Interval(0.62, 1.0, curve: Curves.easeIn),
      ),
    );

    _introController!.forward();
  }

  void _navigateToPurpose() {
    Future.delayed(const Duration(seconds: 10), () {
      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) =>  PurposeScreen(),
        ),
      );
    });
  }

  @override
  void dispose() {
    _introController?.dispose();
    _floatController?.dispose();
    _loopController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final intro = _introController;
    final float = _floatController;
    final loop = _loopController;

    if (intro == null || float == null || loop == null) {
      return const Scaffold(
        backgroundColor: deepTeal,
        body: SizedBox.expand(),
      );
    }

    return Scaffold(
      backgroundColor: deepTeal,
      body: AnimatedBuilder(
        animation: Listenable.merge([intro, float, loop]),
        builder: (context, _) {
          return Stack(
            children: [
              _buildGradientBackground(),
              _buildMeaningfulBackground(loop.value),
              _buildSoftOverlay(),
              _buildTopDecoration(),
              _buildMainContent(float.value),
              _buildFeatureWords(),
              _buildLoadingDots(loop.value),
              _buildBottomText(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildGradientBackground() {
    return const Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF043F3D),
              Color(0xFF075D58),
              Color(0xFF087A73),
              Color(0xFF0DBFB0),
              Color(0xFF62E3D8),
              Color(0xFFB9F7F1),
            ],
            stops: [0.0, 0.18, 0.34, 0.62, 0.84, 1.0],
          ),
        ),
      ),
    );
  }

  Widget _buildMeaningfulBackground(double progress) {
    return Positioned.fill(
      child: IgnorePointer(
        child: CustomPaint(
          painter: _ImpiloMeaningBackgroundPainter(progress: progress),
        ),
      ),
    );
  }

  Widget _buildSoftOverlay() {
    return const Positioned.fill(
      child: IgnorePointer(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0, -0.22),
              radius: 0.88,
              colors: [
                Color(0x14FFFFFF),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopDecoration() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 28, right: 28, top: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '9:41',
              style: TextStyle(
                color: Colors.white.withOpacity(0.88),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            Row(
              children: List.generate(3, (index) {
                return Container(
                  width: 4,
                  height: 4,
                  margin: const EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.78),
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(double floatValue) {
    final double floatY = math.sin(floatValue * math.pi * 2) * 5.5;

    return SafeArea(
      child: Align(
        alignment: const Alignment(0, -0.24),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Transform.translate(
                offset: Offset(0, floatY),
                child: FadeTransition(
                  opacity: _logoFade!,
                  child: ScaleTransition(
                    scale: _logoScale!,
                    child: _buildLogoCard(),
                  ),
                ),
              ),
              const SizedBox(height: 26),
              FadeTransition(
                opacity: _textFade!,
                child: SlideTransition(
                  position: _textSlide!,
                  child: const Text(
                    'Impilo',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 46,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 1.4,
                      height: 1.0,
                      shadows: [
                        Shadow(
                          color: Color(0x44061A19),
                          blurRadius: 14,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              FadeTransition(
                opacity: _taglineFade!,
                child: Column(
                  children: [
                    Text(
                      'Your life.  Your journey.  Your Impilo.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12.4,
                        fontWeight: FontWeight.w800,
                        color: Colors.white.withOpacity(0.94),
                        letterSpacing: 0.15,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      'AI guidance for goals, habits, reflection & growth',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 10.4,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.58),
                        letterSpacing: 0.15,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoCard() {
    return Container(
      width: 112,
      height: 112,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(31),
        color: Colors.white,
        border: Border.all(
          color: Colors.white.withOpacity(0.75),
          width: 1.6,
        ),
        boxShadow: [
          BoxShadow(
            color: darkTeal.withOpacity(0.28),
            blurRadius: 30,
            offset: const Offset(0, 16),
          ),
          BoxShadow(
            color: turquoise.withOpacity(0.36),
            blurRadius: 44,
            spreadRadius: 4,
          ),
        ],
      ),
      padding: const EdgeInsets.all(15),
      child: Image.asset(
        'assets/images/impilo_logo.png',
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(
            Icons.spa_rounded,
            color: turquoise,
            size: 54,
          );
        },
      ),
    );
  }

  Widget _buildFeatureWords() {
    return Positioned(
      left: 24,
      right: 24,
      bottom: 132,
      child: FadeTransition(
        opacity: _taglineFade!,
        child: const Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: [
            _MiniFeatureChip(text: 'Reflect'),
            _MiniFeatureChip(text: 'Grow'),
            _MiniFeatureChip(text: 'Goals'),
            _MiniFeatureChip(text: 'Habits'),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingDots(double progress) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 86,
      child: FadeTransition(
        opacity: _taglineFade!,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            final double delay = index * 0.22;
            final double value = (progress + delay) % 1.0;
            final double scale = 0.72 + (math.sin(value * math.pi) * 0.34);
            final double opacity = 0.35 + (math.sin(value * math.pi) * 0.65);

            return Transform.scale(
              scale: scale,
              child: Opacity(
                opacity: opacity.clamp(0.2, 1.0),
                child: Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.30),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildBottomText() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 36,
      child: FadeTransition(
        opacity: _taglineFade!,
        child: Text(
          'AI-POWERED  •  ALWAYS WITH YOU',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w800,
            color: Colors.white.withOpacity(0.24),
            letterSpacing: 1.4,
          ),
        ),
      ),
    );
  }
}

class _MiniFeatureChip extends StatelessWidget {
  final String text;

  const _MiniFeatureChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.13),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: Colors.white.withOpacity(0.20),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white.withOpacity(0.76),
          fontSize: 9.6,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.35,
        ),
      ),
    );
  }
}

class _ImpiloMeaningBackgroundPainter extends CustomPainter {
  final double progress;

  const _ImpiloMeaningBackgroundPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final double drift = math.sin(progress * math.pi * 2) * 14;

    _drawGuidanceRings(canvas, size, drift);
    _drawLifePath(canvas, size, drift);
    _drawWellnessPulse(canvas, size);
    _drawChatBubbles(canvas, size, drift);
    _drawGoalMarks(canvas, size, drift);
    _drawLeaves(canvas, size, drift);
    _drawBottomWaves(canvas, size);
  }

  void _drawGuidanceRings(Canvas canvas, Size size, double drift) {
    final Paint ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.05;

    ringPaint.color = Colors.white.withOpacity(0.10);
    canvas.drawCircle(
      Offset(size.width * 0.98 + drift, size.height * 0.04),
      size.width * 0.66,
      ringPaint,
    );

    ringPaint.color = Colors.white.withOpacity(0.075);
    canvas.drawCircle(
      Offset(size.width * 0.92 + drift, size.height * 0.05),
      size.width * 0.48,
      ringPaint,
    );

    ringPaint.color = Colors.white.withOpacity(0.055);
    canvas.drawCircle(
      Offset(size.width * 0.86 + drift, size.height * 0.06),
      size.width * 0.30,
      ringPaint,
    );

    ringPaint.color = Colors.white.withOpacity(0.075);
    canvas.drawCircle(
      Offset(size.width * -0.08 - drift, size.height * 1.03),
      size.width * 0.55,
      ringPaint,
    );
  }

  void _drawLifePath(Canvas canvas, Size size, double drift) {
    final Paint pathPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round
      ..color = Colors.white.withOpacity(0.075);

    final Path path = Path()
      ..moveTo(size.width * 0.16, -20)
      ..cubicTo(
        size.width * 0.08,
        size.height * 0.18,
        size.width * 0.36 + drift,
        size.height * 0.28,
        size.width * 0.26,
        size.height * 0.48,
      )
      ..cubicTo(
        size.width * 0.18,
        size.height * 0.64,
        size.width * 0.42 - drift,
        size.height * 0.78,
        size.width * 0.28,
        size.height + 20,
      );

    canvas.drawPath(path, pathPaint);
  }

  void _drawWellnessPulse(Canvas canvas, Size size) {
    final Paint pulsePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round
      ..color = Colors.white.withOpacity(0.085);

    final Path pulse = Path()
      ..moveTo(size.width * 0.08, size.height * 0.58)
      ..lineTo(size.width * 0.18, size.height * 0.58)
      ..lineTo(size.width * 0.22, size.height * 0.53)
      ..lineTo(size.width * 0.27, size.height * 0.64)
      ..lineTo(size.width * 0.33, size.height * 0.50)
      ..lineTo(size.width * 0.39, size.height * 0.58)
      ..lineTo(size.width * 0.50, size.height * 0.58);

    canvas.drawPath(pulse, pulsePaint);
  }

  void _drawChatBubbles(Canvas canvas, Size size, double drift) {
    final Paint bubblePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = Colors.white.withOpacity(0.10);

    final Rect bubbleOne = Rect.fromLTWH(
      size.width * 0.70 + drift * 0.2,
      size.height * 0.18,
      52,
      34,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(bubbleOne, const Radius.circular(14)),
      bubblePaint,
    );

    final Path tailOne = Path()
      ..moveTo(bubbleOne.left + 12, bubbleOne.bottom)
      ..lineTo(bubbleOne.left + 5, bubbleOne.bottom + 8)
      ..lineTo(bubbleOne.left + 20, bubbleOne.bottom);

    canvas.drawPath(tailOne, bubblePaint);

    final Paint dotPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white.withOpacity(0.14);

    for (int i = 0; i < 3; i++) {
      canvas.drawCircle(
        Offset(bubbleOne.left + 17 + (i * 10), bubbleOne.top + 17),
        2.2,
        dotPaint,
      );
    }
  }

  void _drawGoalMarks(Canvas canvas, Size size, double drift) {
    final Paint circlePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3
      ..color = Colors.white.withOpacity(0.10);

    final Offset center = Offset(
      size.width * 0.78 - drift * 0.15,
      size.height * 0.63,
    );

    canvas.drawCircle(center, 22, circlePaint);

    circlePaint.color = Colors.white.withOpacity(0.075);
    canvas.drawCircle(center, 13, circlePaint);

    final Paint checkPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.7
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = Colors.white.withOpacity(0.14);

    final Path check = Path()
      ..moveTo(center.dx - 8, center.dy)
      ..lineTo(center.dx - 2, center.dy + 6)
      ..lineTo(center.dx + 10, center.dy - 8);

    canvas.drawPath(check, checkPaint);
  }

  void _drawLeaves(Canvas canvas, Size size, double drift) {
    final Paint leafPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white.withOpacity(0.055);

    final Path leafOne = Path()
      ..moveTo(size.width * 0.12, size.height * 0.34)
      ..cubicTo(
        size.width * 0.20,
        size.height * 0.25,
        size.width * 0.30,
        size.height * 0.31,
        size.width * 0.24,
        size.height * 0.41,
      )
      ..cubicTo(
        size.width * 0.18,
        size.height * 0.42,
        size.width * 0.13,
        size.height * 0.39,
        size.width * 0.12,
        size.height * 0.34,
      );

    canvas.save();
    canvas.translate(drift * 0.15, 0);
    canvas.drawPath(leafOne, leafPaint);
    canvas.restore();

    final Paint stemPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round
      ..color = Colors.white.withOpacity(0.055);

    canvas.drawLine(
      Offset(size.width * 0.14, size.height * 0.37),
      Offset(size.width * 0.23, size.height * 0.34),
      stemPaint,
    );
  }

  void _drawBottomWaves(Canvas canvas, Size size) {
    final Paint wavePaint1 = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white.withOpacity(0.060);

    final Path wave1 = Path()
      ..moveTo(0, size.height * 0.72)
      ..cubicTo(
        size.width * 0.25,
        size.height * 0.67,
        size.width * 0.48,
        size.height * 0.78,
        size.width,
        size.height * 0.68,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(wave1, wavePaint1);

    final Paint wavePaint2 = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white.withOpacity(0.038);

    final Path wave2 = Path()
      ..moveTo(0, size.height * 0.82)
      ..cubicTo(
        size.width * 0.28,
        size.height * 0.76,
        size.width * 0.62,
        size.height * 0.92,
        size.width,
        size.height * 0.80,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(wave2, wavePaint2);
  }

  @override
  bool shouldRepaint(covariant _ImpiloMeaningBackgroundPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}