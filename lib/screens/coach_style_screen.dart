import 'package:flutter/material.dart';
import 'goal_setup_screen.dart';

class CoachStyleScreen extends StatefulWidget {
  final String userName;

  const CoachStyleScreen({
    super.key,
    required this.userName,
  });

  @override
  State<CoachStyleScreen> createState() => _CoachStyleScreenState();
}

class _CoachStyleScreenState extends State<CoachStyleScreen> {
  static const Color deepTeal = Color(0xFF0A7A75);
  static const Color turquoise = Color(0xFF0DBFB0);
  static const Color softMint = Color(0xFFE0FDF9);
  static const Color darkTeal = Color(0xFF061A19);

  String? _selectedCoachId;
  String? _selectedCoachTitle;

  bool get _canContinue => _selectedCoachId != null;

  final List<_CoachStyleOption> _coachOptions = const [
    _CoachStyleOption(
      id: 'gentle',
      title: 'Gentle Coach',
      subtitle: 'Soft, kind, and encouraging.',
      icon: Icons.favorite_rounded,
    ),
    _CoachStyleOption(
      id: 'balanced',
      title: 'Balanced Coach',
      subtitle: 'Supportive, practical, and steady.',
      icon: Icons.balance_rounded,
    ),
    _CoachStyleOption(
      id: 'discipline',
      title: 'Discipline Coach',
      subtitle: 'Direct, focused, and action-driven.',
      icon: Icons.bolt_rounded,
    ),
    _CoachStyleOption(
      id: 'productivity',
      title: 'Productivity Coach',
      subtitle: 'Goal-based, structured, and efficient.',
      icon: Icons.track_changes_rounded,
    ),
    _CoachStyleOption(
      id: 'reflective',
      title: 'Reflective Coach',
      subtitle: 'Calm, thoughtful, and deeper.',
      icon: Icons.self_improvement_rounded,
    ),
  ];

  void _continue() {
    if (!_canContinue || _selectedCoachTitle == null) {
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => GoalSetupScreen(
          userName: widget.userName,
          coachStyle: _selectedCoachTitle!,
        ),
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
                    'Choose Your Coach',
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
                    '${widget.userName}, how should Impilo guide you?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: darkTeal.withOpacity(0.64),
                      fontSize: 14.5,
                      fontWeight: FontWeight.w500,
                      height: 1.45,
                    ),
                  ),

                  const SizedBox(height: 24),

                  Expanded(
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemCount: _coachOptions.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final option = _coachOptions[index];
                        final isSelected = _selectedCoachId == option.id;

                        return _CoachStyleCard(
                          option: option,
                          isSelected: isSelected,
                          onTap: () {
                            setState(() {
                              _selectedCoachId = option.id;
                              _selectedCoachTitle = option.title;
                            });
                          },
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 14),

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
                        _canContinue ? 'Continue' : 'Select a Coach Style',
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
          painter: _CoachPatternPainter(),
        ),
      ),
    );
  }
}

class _CoachStyleCard extends StatelessWidget {
  final _CoachStyleOption option;
  final bool isSelected;
  final VoidCallback onTap;

  const _CoachStyleCard({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  static const Color deepTeal = Color(0xFF0A7A75);
  static const Color turquoise = Color(0xFF0DBFB0);
  static const Color darkTeal = Color(0xFF061A19);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.90),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isSelected
              ? turquoise.withOpacity(0.85)
              : turquoise.withOpacity(0.13),
          width: isSelected ? 1.7 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isSelected
                ? turquoise.withOpacity(0.18)
                : deepTeal.withOpacity(0.05),
            blurRadius: isSelected ? 24 : 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? turquoise.withOpacity(0.18)
                        : turquoise.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    option.icon,
                    color: deepTeal,
                    size: 23,
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        option.title,
                        style: const TextStyle(
                          color: darkTeal,
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        option.subtitle,
                        style: TextStyle(
                          color: darkTeal.withOpacity(0.56),
                          fontSize: 12.4,
                          fontWeight: FontWeight.w500,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                Icon(
                  isSelected
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked_rounded,
                  color: isSelected ? turquoise : darkTeal.withOpacity(0.22),
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CoachStyleOption {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;

  const _CoachStyleOption({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

class _CoachPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1
      ..color = const Color(0xFF0DBFB0).withOpacity(0.09);

    canvas.drawCircle(
      Offset(size.width * 0.98, size.height * 0.06),
      size.width * 0.52,
      ringPaint,
    );

    ringPaint.color = const Color(0xFF0A7A75).withOpacity(0.055);

    canvas.drawCircle(
      Offset(size.width * 0.92, size.height * 0.09),
      size.width * 0.32,
      ringPaint,
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