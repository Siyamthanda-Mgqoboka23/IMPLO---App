import 'package:flutter/material.dart';
import 'coach_style_screen.dart';

class NameSetupScreen extends StatefulWidget {
  const NameSetupScreen({super.key});

  @override
  State<NameSetupScreen> createState() => _NameSetupScreenState();
}

class _NameSetupScreenState extends State<NameSetupScreen> {
  static const Color deepTeal = Color(0xFF0A7A75);
  static const Color turquoise = Color(0xFF0DBFB0);
  static const Color lightAqua = Color(0xFFCCFAF7);
  static const Color softMint = Color(0xFFE0FDF9);
  static const Color darkTeal = Color(0xFF061A19);

  final TextEditingController _nameController = TextEditingController();

  bool get _canContinue => _nameController.text.trim().length >= 2;

  @override
  void initState() {
    super.initState();

    _nameController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _goToCoachStyle() {
    final String name = _nameController.text.trim();

    if (name.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: darkTeal,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          content: const Text(
            'Please enter a valid name to continue.',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
      return;
    }

    FocusScope.of(context).unfocus();

    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 700),
        pageBuilder: (_, __, ___) => CoachStyleScreen(userName: name),
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
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: softMint,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          _buildBackground(),
          _buildPatternOverlay(),

          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: EdgeInsets.fromLTRB(
                    26,
                    0,
                    26,
                    keyboardHeight > 0 ? keyboardHeight + 24 : 24,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
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

                        SizedBox(height: keyboardHeight > 0 ? 8 : 28),

                        _buildLogo(),

                        SizedBox(height: keyboardHeight > 0 ? 22 : 34),

                        const Text(
                          'Let’s Personalize Impilo',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: darkTeal,
                            fontSize: 31,
                            fontWeight: FontWeight.w900,
                            height: 1.1,
                          ),
                        ),

                        const SizedBox(height: 14),

                        Text(
                          'What should Impilo call you during your growth journey?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: darkTeal.withOpacity(0.64),
                            fontSize: 14.5,
                            fontWeight: FontWeight.w500,
                            height: 1.45,
                          ),
                        ),

                        SizedBox(height: keyboardHeight > 0 ? 24 : 34),

                        _buildNameInput(),

                        const SizedBox(height: 18),

                        _buildPersonalNote(),

                        SizedBox(height: keyboardHeight > 0 ? 24 : 54),

                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _canContinue ? _goToCoachStyle : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: deepTeal,
                              disabledBackgroundColor:
                                  deepTeal.withOpacity(0.25),
                              foregroundColor: Colors.white,
                              disabledForegroundColor:
                                  Colors.white.withOpacity(0.55),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child: Text(
                              _canContinue ? 'Continue' : 'Enter Your Name',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        Text(
                          'This helps Impilo make your experience feel more personal.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: darkTeal.withOpacity(0.45),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                          ),
                        ),

                        const SizedBox(height: 24),
                      ],
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
      width: 104,
      height: 104,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: turquoise.withOpacity(0.30),
            blurRadius: 36,
            offset: const Offset(0, 16),
          ),
          BoxShadow(
            color: deepTeal.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Image.asset(
        'assets/images/impilo_logo.png',
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) {
          return const Icon(
            Icons.spa_rounded,
            color: turquoise,
            size: 54,
          );
        },
      ),
    );
  }

  Widget _buildNameInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: _canContinue
              ? turquoise.withOpacity(0.50)
              : turquoise.withOpacity(0.14),
        ),
        boxShadow: [
          BoxShadow(
            color: deepTeal.withOpacity(0.06),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: TextField(
        controller: _nameController,
        textCapitalization: TextCapitalization.words,
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.done,
        onSubmitted: (_) {
          if (_canContinue) {
            _goToCoachStyle();
          }
        },
        cursorColor: deepTeal,
        style: const TextStyle(
          color: darkTeal,
          fontSize: 17,
          fontWeight: FontWeight.w700,
        ),
        decoration: InputDecoration(
          hintText: 'Enter your name',
          hintStyle: TextStyle(
            color: darkTeal.withOpacity(0.35),
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Icon(
            Icons.person_rounded,
            color: _canContinue ? deepTeal : darkTeal.withOpacity(0.35),
          ),
          suffixIcon: _canContinue
              ? const Icon(
                  Icons.check_circle_rounded,
                  color: turquoise,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildPersonalNote() {
    final String name = _nameController.text.trim();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: turquoise.withOpacity(0.10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: turquoise.withOpacity(0.20),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.auto_awesome_rounded,
            color: deepTeal,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name.isEmpty
                  ? 'Once you enter your name, Impilo will start shaping a more personal experience for you.'
                  : 'Nice to meet you, $name. Next, choose how you want Impilo to coach you.',
              style: TextStyle(
                color: darkTeal.withOpacity(0.68),
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
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
          painter: _NameSetupPatternPainter(),
        ),
      ),
    );
  }
}

class _NameSetupPatternPainter extends CustomPainter {
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

    final Paint pathPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.25
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFF0A7A75).withOpacity(0.055);

    final Path path = Path()
      ..moveTo(size.width * 0.18, -20)
      ..cubicTo(
        size.width * 0.08,
        size.height * 0.22,
        size.width * 0.38,
        size.height * 0.36,
        size.width * 0.24,
        size.height * 0.58,
      )
      ..cubicTo(
        size.width * 0.12,
        size.height * 0.75,
        size.width * 0.35,
        size.height * 0.90,
        size.width * 0.25,
        size.height + 30,
      );

    canvas.drawPath(path, pathPaint);

    final Paint bubblePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = const Color(0xFF0A7A75).withOpacity(0.06);

    final Rect bubble = Rect.fromLTWH(
      size.width * 0.08,
      size.height * 0.18,
      58,
      38,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(bubble, const Radius.circular(16)),
      bubblePaint,
    );

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