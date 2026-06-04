import 'package:flutter/material.dart';
import 'mood_checkin_screen.dart';

class GoalSetupScreen extends StatefulWidget {
  final String userName;
  final String coachStyle;

  const GoalSetupScreen({
    super.key,
    required this.userName,
    required this.coachStyle,
  });

  @override
  State<GoalSetupScreen> createState() => _GoalSetupScreenState();
}

class _GoalSetupScreenState extends State<GoalSetupScreen> {
  static const Color deepTeal = Color(0xFF0A7A75);
  static const Color turquoise = Color(0xFF0DBFB0);
  static const Color lightAqua = Color(0xFFCCFAF7);
  static const Color softMint = Color(0xFFE0FDF9);
  static const Color darkTeal = Color(0xFF061A19);

  final TextEditingController _goalController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();

  String? _selectedArea;
  String? _selectedTimeframe;

  final List<String> _timeframes = const [
    'This week',
    'This month',
    'Next 3 months',
    'Long term',
  ];

  final List<_GoalArea> _goalAreas = const [
    _GoalArea(
      title: 'Discipline',
      icon: Icons.bolt_rounded,
      goals: [
        'I want to become more disciplined and consistent.',
        'I want to stop procrastinating and follow through.',
        'I want to build a stronger daily routine.',
      ],
      reason:
          'Because I want to become more consistent and take better control of my life.',
    ),
    _GoalArea(
      title: 'Studies',
      icon: Icons.school_rounded,
      goals: [
        'I want to study more consistently every week.',
        'I want to complete my assignments earlier.',
        'I want to improve my focus when studying.',
      ],
      reason:
          'Because I want to improve my academic progress and feel more prepared.',
    ),
    _GoalArea(
      title: 'Fitness',
      icon: Icons.fitness_center_rounded,
      goals: [
        'I want to build a consistent fitness routine.',
        'I want to exercise at least three times per week.',
        'I want to improve my energy and health.',
      ],
      reason:
          'Because I want to feel healthier, stronger, and more confident.',
    ),
    _GoalArea(
      title: 'Mental clarity',
      icon: Icons.psychology_alt_rounded,
      goals: [
        'I want to feel more focused and mentally clear.',
        'I want to reduce overthinking and stay calm.',
        'I want to build a better reflection routine.',
      ],
      reason:
          'Because I want to feel calmer, clearer, and more in control of my thoughts.',
    ),
    _GoalArea(
      title: 'Money habits',
      icon: Icons.savings_rounded,
      goals: [
        'I want to manage my money better.',
        'I want to save more consistently.',
        'I want to become more disciplined with spending.',
      ],
      reason:
          'Because I want to build financial stability and make better money decisions.',
    ),
    _GoalArea(
      title: 'Confidence',
      icon: Icons.self_improvement_rounded,
      goals: [
        'I want to become more confident in myself.',
        'I want to stop doubting myself so much.',
        'I want to build stronger self-belief.',
      ],
      reason:
          'Because I want to grow as a person and trust myself more.',
    ),
  ];

  bool get _canContinue =>
      _goalController.text.trim().length >= 4 && _selectedTimeframe != null;

  List<String> get _suggestedGoals {
    final area = _goalAreas.firstWhere(
      (item) => item.title == _selectedArea,
      orElse: () => _goalAreas.first,
    );

    return area.goals;
  }

  @override
  void initState() {
    super.initState();

    _goalController.addListener(() {
      setState(() {});
    });

    _reasonController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _goalController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  void _selectArea(_GoalArea area) {
    setState(() {
      _selectedArea = area.title;
    });
  }

  void _selectSuggestedGoal(String goal) {
    final selectedAreaData = _goalAreas.firstWhere(
      (area) => area.title == _selectedArea,
      orElse: () => _goalAreas.first,
    );

    setState(() {
      _goalController.text = goal;
      _reasonController.text = selectedAreaData.reason;
    });
  }

  void _suggestGoalAutomatically() {
    final _GoalArea area = _selectedArea == null
        ? _goalAreas.first
        : _goalAreas.firstWhere(
            (item) => item.title == _selectedArea,
            orElse: () => _goalAreas.first,
          );

    final String suggestedGoal = area.goals.first;

    setState(() {
      _selectedArea ??= area.title;
      _goalController.text = suggestedGoal;
      _reasonController.text = area.reason;
    });
  }

  void _continue() {
    final String goal = _goalController.text.trim();
    final String reason = _reasonController.text.trim();

    if (!_canContinue) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: darkTeal,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          content: const Text(
            'Please enter a goal and choose a timeframe.',
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
        pageBuilder: (_, __, ___) => MoodCheckInScreen(
          userName: widget.userName,
          coachStyle: widget.coachStyle,
          goal: goal,
          reason: reason,
          timeframe: _selectedTimeframe!,
          selectedArea: _selectedArea,
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

                        SizedBox(height: keyboardHeight > 0 ? 8 : 18),

                        _buildHeaderIcon(),

                        SizedBox(height: keyboardHeight > 0 ? 20 : 28),

                        Text(
                          '${widget.userName}, what is your first goal?',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: darkTeal,
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            height: 1.1,
                          ),
                        ),

                        const SizedBox(height: 14),

                        Text(
                          'Choose an area and let Impilo suggest a goal, or write your own.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: darkTeal.withOpacity(0.64),
                            fontSize: 14.3,
                            fontWeight: FontWeight.w500,
                            height: 1.45,
                          ),
                        ),

                        SizedBox(height: keyboardHeight > 0 ? 20 : 26),

                        _buildAutoSuggestButton(),

                        const SizedBox(height: 18),

                        _buildAreaSection(),

                        const SizedBox(height: 18),

                        if (_selectedArea != null) _buildSuggestedGoals(),

                        if (_selectedArea != null) const SizedBox(height: 18),

                        _buildGoalInput(),

                        const SizedBox(height: 16),

                        _buildReasonInput(),

                        const SizedBox(height: 20),

                        _buildTimeframeSection(),

                        const SizedBox(height: 18),

                        _buildCoachPreview(),

                        SizedBox(height: keyboardHeight > 0 ? 24 : 42),

                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _canContinue ? _continue : null,
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
                              _canContinue
                                  ? 'Continue to Check-In'
                                  : 'Add Goal Details',
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
                          'You can add more goals later from your dashboard.',
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

  Widget _buildHeaderIcon() {
    return Container(
      width: 104,
      height: 104,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            deepTeal,
            turquoise,
          ],
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: turquoise.withOpacity(0.30),
            blurRadius: 36,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: const Icon(
        Icons.flag_rounded,
        color: Colors.white,
        size: 50,
      ),
    );
  }

  Widget _buildAutoSuggestButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        onPressed: _suggestGoalAutomatically,
        icon: const Icon(Icons.auto_awesome_rounded),
        label: const Text('Let Impilo suggest a goal'),
        style: OutlinedButton.styleFrom(
          foregroundColor: deepTeal,
          side: BorderSide(
            color: turquoise.withOpacity(0.50),
            width: 1.2,
          ),
          backgroundColor: Colors.white.withOpacity(0.72),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.1,
          ),
        ),
      ),
    );
  }

  Widget _buildAreaSection() {
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
            'Choose a life area',
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
            children: _goalAreas.map((area) {
              final bool isSelected = _selectedArea == area.title;

              return GestureDetector(
                onTap: () => _selectArea(area),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? turquoise.withOpacity(0.18)
                        : softMint.withOpacity(0.80),
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
                        area.icon,
                        color: isSelected
                            ? deepTeal
                            : darkTeal.withOpacity(0.38),
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        area.title,
                        style: TextStyle(
                          color: isSelected
                              ? deepTeal
                              : darkTeal.withOpacity(0.62),
                          fontSize: 12.1,
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

  Widget _buildSuggestedGoals() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: turquoise.withOpacity(0.09),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: turquoise.withOpacity(0.18),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Suggested goals for $_selectedArea',
            style: const TextStyle(
              color: darkTeal,
              fontSize: 14.5,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 13),
          Column(
            children: _suggestedGoals.map((goal) {
              final bool isSelected = _goalController.text.trim() == goal;

              return GestureDetector(
                onTap: () => _selectSuggestedGoal(goal),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withOpacity(0.95)
                        : Colors.white.withOpacity(0.70),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isSelected
                          ? turquoise.withOpacity(0.80)
                          : Colors.white.withOpacity(0.35),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSelected
                            ? Icons.check_circle_rounded
                            : Icons.add_circle_outline_rounded,
                        color: isSelected
                            ? turquoise
                            : darkTeal.withOpacity(0.35),
                        size: 21,
                      ),
                      const SizedBox(width: 11),
                      Expanded(
                        child: Text(
                          goal,
                          style: TextStyle(
                            color: darkTeal.withOpacity(0.76),
                            fontSize: 12.6,
                            fontWeight: FontWeight.w700,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          Text(
            'Tap one to auto-fill your goal and reason.',
            style: TextStyle(
              color: darkTeal.withOpacity(0.46),
              fontSize: 10.8,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: _goalController.text.trim().length >= 4
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
        controller: _goalController,
        textCapitalization: TextCapitalization.sentences,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        cursorColor: deepTeal,
        maxLines: 2,
        minLines: 1,
        style: const TextStyle(
          color: darkTeal,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        decoration: InputDecoration(
          hintText: 'Or write your own goal',
          hintStyle: TextStyle(
            color: darkTeal.withOpacity(0.35),
            fontWeight: FontWeight.w500,
            fontSize: 13.5,
          ),
          prefixIcon: Icon(
            Icons.track_changes_rounded,
            color: _goalController.text.trim().length >= 4
                ? deepTeal
                : darkTeal.withOpacity(0.35),
          ),
          suffixIcon: _goalController.text.trim().length >= 4
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

  Widget _buildReasonInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.84),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: turquoise.withOpacity(0.12),
        ),
      ),
      child: TextField(
        controller: _reasonController,
        textCapitalization: TextCapitalization.sentences,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        cursorColor: deepTeal,
        maxLines: 3,
        minLines: 1,
        style: const TextStyle(
          color: darkTeal,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          hintText: 'Why does this goal matter to you? Optional',
          hintStyle: TextStyle(
            color: darkTeal.withOpacity(0.34),
            fontWeight: FontWeight.w500,
            fontSize: 13.5,
          ),
          prefixIcon: Icon(
            Icons.favorite_rounded,
            color: darkTeal.withOpacity(0.34),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildTimeframeSection() {
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
            'When do you want to focus on this?',
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
            children: _timeframes.map((timeframe) {
              final bool isSelected = _selectedTimeframe == timeframe;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedTimeframe = timeframe;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 13,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? turquoise.withOpacity(0.18)
                        : softMint.withOpacity(0.80),
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
                        isSelected
                            ? Icons.check_circle_rounded
                            : Icons.circle_outlined,
                        color: isSelected
                            ? deepTeal
                            : darkTeal.withOpacity(0.34),
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        timeframe,
                        style: TextStyle(
                          color: isSelected
                              ? deepTeal
                              : darkTeal.withOpacity(0.62),
                          fontSize: 12.2,
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

  Widget _buildCoachPreview() {
    final String goal = _goalController.text.trim();

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
              goal.isEmpty
                  ? 'Your goal helps Impilo create a more useful plan for you.'
                  : 'Great, ${widget.userName}. Impilo will shape your ${widget.coachStyle} coaching around this goal.',
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
          painter: _GoalSetupPatternPainter(),
        ),
      ),
    );
  }
}

class _GoalArea {
  final String title;
  final IconData icon;
  final List<String> goals;
  final String reason;

  const _GoalArea({
    required this.title,
    required this.icon,
    required this.goals,
    required this.reason,
  });
}

class _GoalSetupPatternPainter extends CustomPainter {
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

    final Paint targetPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = const Color(0xFF0A7A75).withOpacity(0.07);

    final Offset targetCenter = Offset(size.width * 0.82, size.height * 0.56);
    canvas.drawCircle(targetCenter, 27, targetPaint);
    canvas.drawCircle(targetCenter, 17, targetPaint);
    canvas.drawCircle(targetCenter, 7, targetPaint);

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