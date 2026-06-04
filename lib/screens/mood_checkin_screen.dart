import 'package:flutter/material.dart';
import 'ai_plan_loading_screen.dart';

class MoodCheckInScreen extends StatefulWidget {
  final String userName;
  final String coachStyle;
  final String goal;
  final String reason;
  final String timeframe;
  final String? selectedArea;

  const MoodCheckInScreen({
    super.key,
    required this.userName,
    required this.coachStyle,
    required this.goal,
    required this.reason,
    required this.timeframe,
    this.selectedArea,
  });

  @override
  State<MoodCheckInScreen> createState() => _MoodCheckInScreenState();
}

class _MoodCheckInScreenState extends State<MoodCheckInScreen> {
  static const Color deepTeal = Color(0xFF0A7A75);
  static const Color turquoise = Color(0xFF0DBFB0);
  static const Color lightAqua = Color(0xFFCCFAF7);
  static const Color softMint = Color(0xFFE0FDF9);
  static const Color darkTeal = Color(0xFF061A19);

  String? _selectedMood;
  String? _selectedNeed;

  bool get _canContinue => _selectedMood != null && _selectedNeed != null;

  final List<_MoodOption> _moods = const [
    _MoodOption(
      title: 'Motivated',
      emoji: '🔥',
      description: 'Ready to take action.',
      icon: Icons.local_fire_department_rounded,
    ),
    _MoodOption(
      title: 'Calm',
      emoji: '🌊',
      description: 'Steady and peaceful.',
      icon: Icons.waves_rounded,
    ),
    _MoodOption(
      title: 'Tired',
      emoji: '😴',
      description: 'Low energy today.',
      icon: Icons.bedtime_rounded,
    ),
    _MoodOption(
      title: 'Stressed',
      emoji: '😮‍💨',
      description: 'Need a lighter plan.',
      icon: Icons.spa_rounded,
    ),
    _MoodOption(
      title: 'Unfocused',
      emoji: '🌫️',
      description: 'Need structure.',
      icon: Icons.blur_on_rounded,
    ),
    _MoodOption(
      title: 'Hopeful',
      emoji: '✨',
      description: 'Looking forward.',
      icon: Icons.auto_awesome_rounded,
    ),
  ];

  final List<_NeedOption> _needs = const [
    _NeedOption(
      title: 'Encouragement',
      icon: Icons.favorite_rounded,
    ),
    _NeedOption(
      title: 'A clear plan',
      icon: Icons.task_alt_rounded,
    ),
    _NeedOption(
      title: 'Discipline',
      icon: Icons.bolt_rounded,
    ),
    _NeedOption(
      title: 'Focus',
      icon: Icons.center_focus_strong_rounded,
    ),
    _NeedOption(
      title: 'Reflection',
      icon: Icons.self_improvement_rounded,
    ),
    _NeedOption(
      title: 'Rest balance',
      icon: Icons.nightlight_round_rounded,
    ),
  ];

  void _continue() {
    if (!_canContinue) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: darkTeal,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          content: const Text(
            'Please choose your mood and what you need today.',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
      return;
    }

    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 700),
        pageBuilder: (_, __, ___) => AiPlanLoadingScreen(
          userName: widget.userName,
          coachStyle: widget.coachStyle,
          goal: widget.goal,
          reason: widget.reason,
          timeframe: widget.timeframe,
          selectedArea: widget.selectedArea,
          mood: _selectedMood!,
          need: _selectedNeed!,
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26),
              child: Column(
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

                  const SizedBox(height: 8),

                  const Text(
                    'How are you feeling?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: darkTeal,
                      fontSize: 31,
                      fontWeight: FontWeight.w900,
                      height: 1.1,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    '${widget.userName}, this helps Impilo shape your first plan around your energy today.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: darkTeal.withOpacity(0.64),
                      fontSize: 14.4,
                      fontWeight: FontWeight.w500,
                      height: 1.45,
                    ),
                  ),

                  const SizedBox(height: 18),

                  _buildGoalSummary(),

                  const SizedBox(height: 18),

                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          _buildMoodSection(),

                          const SizedBox(height: 18),

                          _buildNeedSection(),

                          const SizedBox(height: 18),

                          _buildPreviewCard(),

                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _canContinue ? _continue : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: deepTeal,
                        disabledBackgroundColor: deepTeal.withOpacity(0.25),
                        foregroundColor: Colors.white,
                        disabledForegroundColor: Colors.white.withOpacity(0.55),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: Text(
                        _canContinue
                            ? 'Continue to My Plan'
                            : 'Choose Mood & Need',
                        style: const TextStyle(
                          fontSize: 15.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalSummary() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.86),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: turquoise.withOpacity(0.15),
        ),
        boxShadow: [
          BoxShadow(
            color: deepTeal.withOpacity(0.05),
            blurRadius: 18,
            offset: const Offset(0, 9),
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
              size: 22,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your first goal',
                  style: TextStyle(
                    color: darkTeal,
                    fontSize: 13.8,
                    fontWeight: FontWeight.w900,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  widget.goal,
                  style: TextStyle(
                    color: darkTeal.withOpacity(0.65),
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 7,
                  runSpacing: 7,
                  children: [
                    _SmallTag(text: widget.coachStyle),
                    _SmallTag(text: widget.timeframe),
                    if (widget.selectedArea != null)
                      _SmallTag(text: widget.selectedArea!),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.86),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: turquoise.withOpacity(0.14),
        ),
        boxShadow: [
          BoxShadow(
            color: deepTeal.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Choose your current mood',
            style: TextStyle(
              color: darkTeal,
              fontSize: 14.5,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 13),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _moods.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 2.15,
            ),
            itemBuilder: (context, index) {
              final mood = _moods[index];
              final bool isSelected = _selectedMood == mood.title;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedMood = mood.title;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? turquoise.withOpacity(0.18)
                        : softMint.withOpacity(0.78),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isSelected
                          ? turquoise.withOpacity(0.85)
                          : turquoise.withOpacity(0.14),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        mood.emoji,
                        style: const TextStyle(fontSize: 19),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          mood.title,
                          style: TextStyle(
                            color: isSelected
                                ? deepTeal
                                : darkTeal.withOpacity(0.68),
                            fontSize: 12.2,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      Icon(
                        isSelected
                            ? Icons.check_circle_rounded
                            : Icons.circle_outlined,
                        color: isSelected
                            ? turquoise
                            : darkTeal.withOpacity(0.25),
                        size: 17,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNeedSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.86),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: turquoise.withOpacity(0.14),
        ),
        boxShadow: [
          BoxShadow(
            color: deepTeal.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'What do you need most today?',
            style: TextStyle(
              color: darkTeal,
              fontSize: 14.5,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 13),
          Wrap(
            spacing: 9,
            runSpacing: 9,
            children: _needs.map((need) {
              final bool isSelected = _selectedNeed == need.title;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedNeed = need.title;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? turquoise.withOpacity(0.18)
                        : softMint.withOpacity(0.78),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: isSelected
                          ? turquoise.withOpacity(0.85)
                          : turquoise.withOpacity(0.14),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        need.icon,
                        color: isSelected
                            ? deepTeal
                            : darkTeal.withOpacity(0.36),
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        need.title,
                        style: TextStyle(
                          color: isSelected
                              ? deepTeal
                              : darkTeal.withOpacity(0.62),
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewCard() {
    final String mood = _selectedMood ?? 'your current mood';
    final String need = _selectedNeed ?? 'what you need today';

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
              _canContinue
                  ? 'Great, ${widget.userName}. Impilo will build your first plan around feeling $mood and needing $need.'
                  : 'Your mood helps Impilo adjust your first plan so it feels realistic for today.',
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
          painter: _MoodPatternPainter(),
        ),
      ),
    );
  }
}

class _SmallTag extends StatelessWidget {
  final String text;

  const _SmallTag({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFE0FDF9),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: const Color(0xFF0DBFB0).withOpacity(0.20),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: const Color(0xFF061A19).withOpacity(0.58),
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _MoodOption {
  final String title;
  final String emoji;
  final String description;
  final IconData icon;

  const _MoodOption({
    required this.title,
    required this.emoji,
    required this.description,
    required this.icon,
  });
}

class _NeedOption {
  final String title;
  final IconData icon;

  const _NeedOption({
    required this.title,
    required this.icon,
  });
}

class _MoodPatternPainter extends CustomPainter {
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

    ringPaint.color = const Color(0xFF0A7A75).withOpacity(0.06);
    canvas.drawCircle(
      Offset(size.width * 0.90, size.height * 0.10),
      size.width * 0.30,
      ringPaint,
    );

    final Paint pulsePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.35
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFF0A7A75).withOpacity(0.06);

    final Path pulse = Path()
      ..moveTo(size.width * 0.10, size.height * 0.64)
      ..lineTo(size.width * 0.20, size.height * 0.64)
      ..lineTo(size.width * 0.24, size.height * 0.59)
      ..lineTo(size.width * 0.30, size.height * 0.70)
      ..lineTo(size.width * 0.36, size.height * 0.56)
      ..lineTo(size.width * 0.42, size.height * 0.64)
      ..lineTo(size.width * 0.52, size.height * 0.64);

    canvas.drawPath(pulse, pulsePaint);

    final Paint wavePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFF0DBFB0).withOpacity(0.07);

    final Path wave = Path()
      ..moveTo(0, size.height * 0.84)
      ..cubicTo(
        size.width * 0.28,
        size.height * 0.78,
        size.width * 0.55,
        size.height * 0.93,
        size.width,
        size.height * 0.82,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(wave, wavePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}