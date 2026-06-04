import 'dart:async';
import 'package:flutter/material.dart';

import 'home_dashboard_screen.dart';

class AiPlanLoadingScreen extends StatefulWidget {
  final String userName;
  final String coachStyle;
  final String goal;
  final String reason;
  final String timeframe;
  final String mood;
  final String need;
  final String? selectedArea;

  const AiPlanLoadingScreen({
    super.key,
    required this.userName,
    required this.coachStyle,
    required this.goal,
    required this.reason,
    required this.timeframe,
    required this.mood,
    required this.need,
    this.selectedArea,
  });

  @override
  State<AiPlanLoadingScreen> createState() => _AiPlanLoadingScreenState();
}

class _AiPlanLoadingScreenState extends State<AiPlanLoadingScreen>
    with SingleTickerProviderStateMixin {
  static const Color deepTeal = Color(0xFF0A7A75);
  static const Color turquoise = Color(0xFF0DBFB0);
  static const Color softMint = Color(0xFFE0FDF9);
  static const Color darkTeal = Color(0xFF061A19);

  late final AnimationController _pulseController;

  int _currentStep = 0;
  Timer? _stepTimer;
  Timer? _navigationTimer;

  final List<_LoadingStep> _steps = const [
    _LoadingStep(
      icon: Icons.psychology_alt_rounded,
      title: 'Understanding your goal',
      subtitle: 'Impilo is reading your goal and support needs.',
    ),
    _LoadingStep(
      icon: Icons.auto_awesome_rounded,
      title: 'Preparing your guidance',
      subtitle: 'Creating a personalised starting point.',
    ),
    _LoadingStep(
      icon: Icons.task_alt_rounded,
      title: 'Building your first steps',
      subtitle: 'Turning your goal into simple actions.',
    ),
    _LoadingStep(
      icon: Icons.favorite_rounded,
      title: 'Setting your support tone',
      subtitle: 'Matching the experience to your chosen coach style.',
    ),
  ];

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
      lowerBound: 0.92,
      upperBound: 1.05,
    )..repeat(reverse: true);

    _stepTimer = Timer.periodic(const Duration(milliseconds: 900), (_) {
      if (!mounted) return;

      setState(() {
        _currentStep = (_currentStep + 1) % _steps.length;
      });
    });

    _navigationTimer = Timer(const Duration(seconds: 5), () {
      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 650),
          pageBuilder: (_, __, ___) => HomeDashboardScreen(
            userName: widget.userName,
            coachStyle: widget.coachStyle,
            goal: widget.goal,
            reason: widget.reason,
            timeframe: widget.timeframe,
            mood: widget.mood,
            need: widget.need,
            selectedArea: widget.selectedArea,
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
    });
  }

  @override
  void dispose() {
    _stepTimer?.cancel();
    _navigationTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentStep = _steps[_currentStep];

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
                  padding: const EdgeInsets.fromLTRB(26, 18, 26, 24),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - 42,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 12),
                        _buildTopBadge(),
                        const SizedBox(height: 22),
                        AnimatedBuilder(
                          animation: _pulseController,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _pulseController.value,
                              child: child,
                            );
                          },
                          child: _buildMainIcon(),
                        ),
                        const SizedBox(height: 22),
                        const Text(
                          'Preparing Your Impilo Plan',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: darkTeal,
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 9),
                        Text(
                          'We are setting up your first personalised support flow based on your goal, mood, and coach style.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: darkTeal.withOpacity(0.62),
                            fontSize: 13.2,
                            fontWeight: FontWeight.w600,
                            height: 1.38,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildGoalPreviewCard(),
                        const SizedBox(height: 16),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 350),
                          child: _buildLoadingStepCard(
                            key: ValueKey<int>(_currentStep),
                            step: currentStep,
                          ),
                        ),
                        const SizedBox(height: 18),
                        _buildProgressDots(),
                        const SizedBox(height: 20),
                        Text(
                          'This is currently a local demo setup. Later, this can be powered by your OpenAI service and stored securely.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: darkTeal.withOpacity(0.42),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            height: 1.32,
                          ),
                        ),
                        const SizedBox(height: 10),
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

  Widget _buildTopBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: turquoise.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: turquoise.withOpacity(0.22),
        ),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.auto_awesome_rounded,
            color: deepTeal,
            size: 16,
          ),
          SizedBox(width: 7),
          Text(
            'AI plan setup',
            style: TextStyle(
              color: deepTeal,
              fontSize: 11.5,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainIcon() {
    return Container(
      width: 98,
      height: 98,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            deepTeal,
            turquoise,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: turquoise.withOpacity(0.30),
            blurRadius: 32,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: const Icon(
        Icons.psychology_alt_rounded,
        color: Colors.white,
        size: 48,
      ),
    );
  }

  Widget _buildGoalPreviewCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.90),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: turquoise.withOpacity(0.16),
        ),
        boxShadow: [
          BoxShadow(
            color: deepTeal.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
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
            child: const Icon(
              Icons.flag_rounded,
              color: deepTeal,
              size: 21,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your active goal',
                  style: TextStyle(
                    color: darkTeal,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  widget.goal.trim().isEmpty
                      ? 'Personal growth goal'
                      : widget.goal,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: darkTeal.withOpacity(0.62),
                    fontSize: 12.2,
                    fontWeight: FontWeight.w600,
                    height: 1.32,
                  ),
                ),
                const SizedBox(height: 9),
                Wrap(
                  spacing: 7,
                  runSpacing: 7,
                  children: [
                    _MiniTag(text: widget.coachStyle),
                    _MiniTag(text: widget.mood),
                    _MiniTag(text: widget.need),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingStepCard({
    required Key key,
    required _LoadingStep step,
  }) {
    return Container(
      key: key,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: turquoise.withOpacity(0.10),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: turquoise.withOpacity(0.22),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  deepTeal,
                  turquoise,
                ],
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              step.icon,
              color: Colors.white,
              size: 21,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  style: const TextStyle(
                    color: darkTeal,
                    fontSize: 14.2,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  step.subtitle,
                  style: TextStyle(
                    color: darkTeal.withOpacity(0.60),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    height: 1.32,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_steps.length, (index) {
        final bool selected = index == _currentStep;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: selected ? 22 : 7,
          height: 7,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: selected ? turquoise : turquoise.withOpacity(0.25),
            borderRadius: BorderRadius.circular(999),
          ),
        );
      }),
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
          painter: _AiLoadingPatternPainter(),
        ),
      ),
    );
  }
}

class _LoadingStep {
  final IconData icon;
  final String title;
  final String subtitle;

  const _LoadingStep({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}

class _MiniTag extends StatelessWidget {
  final String text;

  const _MiniTag({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final label = text.trim().isEmpty ? 'Setup' : text.trim();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF0DBFB0).withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: const Color(0xFF0DBFB0).withOpacity(0.18),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF0A7A75),
          fontSize: 10.2,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _AiLoadingPatternPainter extends CustomPainter {
  const _AiLoadingPatternPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final Paint ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1
      ..color = const Color(0xFF0DBFB0).withOpacity(0.08);

    canvas.drawCircle(
      Offset(size.width * 0.96, size.height * 0.08),
      size.width * 0.48,
      ringPaint,
    );

    canvas.drawCircle(
      Offset(size.width * 0.08, size.height * 0.72),
      size.width * 0.30,
      ringPaint,
    );

    final Paint wavePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFF0DBFB0).withOpacity(0.05);

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