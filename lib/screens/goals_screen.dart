import 'package:flutter/material.dart';
import '../models/impilo_goal.dart';

class GoalsScreen extends StatefulWidget {
  final String userName;
  final String coachStyle;
  final List<ImpiloGoal> goals;
  final String activeGoalId;
  final ValueChanged<String> onGoalSelected;
  final ValueChanged<ImpiloGoal> onGoalAdded;
  final void Function(String goalId, String milestone, bool value)
      onMilestoneChanged;
  final bool isDarkTheme;

  const GoalsScreen({
    super.key,
    required this.userName,
    required this.coachStyle,
    required this.goals,
    required this.activeGoalId,
    required this.onGoalSelected,
    required this.onGoalAdded,
    required this.onMilestoneChanged,
    required this.isDarkTheme,
  });

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  static const Color deepTeal = Color(0xFF0A7A75);
  static const Color turquoise = Color(0xFF0DBFB0);
  static const Color softMint = Color(0xFFE0FDF9);
  static const Color lightAqua = Color(0xFFCCFAF7);
  static const Color darkTeal = Color(0xFF061A19);

  static const Color darkBackground = Color(0xFF031210);
  static const Color darkCard = Color(0xFF0B2624);
  static const Color darkCardSoft = Color(0xFF123C38);
  static const Color darkText = Color(0xFFE9FFFC);

  final TextEditingController _goalController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();

  String _newCategory = 'Personal Growth';
  String _newTimeframe = 'Today';
  String _newMood = 'Focused';
  String _newNeed = 'Focus';

  Color get _backgroundColor =>
      widget.isDarkTheme ? darkBackground : softMint;

  Color get _softCardColor => widget.isDarkTheme
      ? turquoise.withOpacity(0.16)
      : turquoise.withOpacity(0.10);

  Color get _textColor => widget.isDarkTheme ? darkText : darkTeal;

  Color get _subTextColor => widget.isDarkTheme
      ? Colors.white.withOpacity(0.65)
      : darkTeal.withOpacity(0.62);

  @override
  void dispose() {
    _goalController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  ImpiloGoal get _activeGoal {
    return widget.goals.firstWhere(
      (goal) => goal.id == widget.activeGoalId,
      orElse: () => widget.goals.first,
    );
  }

  String get _automatedInsight {
    final mood = _activeGoal.mood.toLowerCase();
    final need = _activeGoal.need.toLowerCase();

    if (mood.contains('tired')) {
      return 'Because your energy is low, keep this goal light today. One small action is enough.';
    }

    if (mood.contains('stressed')) {
      return 'Because you feel stressed, reduce pressure. Choose one clear step instead of many.';
    }

    if (need.contains('focus')) {
      return 'Your main need is focus. Use short blocks and remove one distraction before starting.';
    }

    return 'Impilo suggests one small action, one check-in, and one reflection for this goal.';
  }

  void _openCreateGoalSheet() {
    _goalController.clear();
    _reasonController.clear();

    _newCategory = 'Personal Growth';
    _newTimeframe = 'Today';
    _newMood = 'Focused';
    _newNeed = 'Focus';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return FractionallySizedBox(
              heightFactor: 0.92,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
                  decoration: BoxDecoration(
                    color: widget.isDarkTheme
                        ? const Color(0xFF071C1B)
                        : softMint,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(32),
                    ),
                    border: Border.all(
                      color: turquoise.withOpacity(
                        widget.isDarkTheme ? 0.22 : 0.00,
                      ),
                    ),
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 48,
                            height: 5,
                            decoration: BoxDecoration(
                              color: turquoise.withOpacity(0.30),
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            const _IconBox(icon: Icons.flag_rounded),
                            const SizedBox(width: 13),
                            Expanded(
                              child: Text(
                                'Create New Goal',
                                style: TextStyle(
                                  color: _textColor,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'This goal will become available across Home, Tasks, Goals, Profile, and later AI Chat.',
                          style: TextStyle(
                            color: _subTextColor,
                            fontSize: 12.8,
                            fontWeight: FontWeight.w600,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _InputField(
                          controller: _goalController,
                          label: 'Goal title',
                          hint: 'Example: Study more consistently',
                          isDarkTheme: widget.isDarkTheme,
                        ),
                        const SizedBox(height: 12),
                        _InputField(
                          controller: _reasonController,
                          label: 'Reason',
                          hint: 'Why does this goal matter?',
                          maxLines: 3,
                          isDarkTheme: widget.isDarkTheme,
                        ),
                        const SizedBox(height: 12),
                        _DropField(
                          label: 'Category',
                          value: _newCategory,
                          items: const [
                            'Personal Growth',
                            'Study',
                            'Fitness',
                            'Money',
                            'Routine',
                            'Wellbeing',
                          ],
                          isDarkTheme: widget.isDarkTheme,
                          onChanged: (value) {
                            setModalState(() => _newCategory = value);
                          },
                        ),
                        const SizedBox(height: 12),
                        _DropField(
                          label: 'Timeframe',
                          value: _newTimeframe,
                          items: const [
                            'Today',
                            'This Week',
                            'This Month',
                            'Long Term',
                          ],
                          isDarkTheme: widget.isDarkTheme,
                          onChanged: (value) {
                            setModalState(() => _newTimeframe = value);
                          },
                        ),
                        const SizedBox(height: 12),
                        _DropField(
                          label: 'Mood',
                          value: _newMood,
                          items: const [
                            'Focused',
                            'Motivated',
                            'Tired',
                            'Stressed',
                            'Unfocused',
                          ],
                          isDarkTheme: widget.isDarkTheme,
                          onChanged: (value) {
                            setModalState(() => _newMood = value);
                          },
                        ),
                        const SizedBox(height: 12),
                        _DropField(
                          label: 'Support needed',
                          value: _newNeed,
                          items: const [
                            'Focus',
                            'Encouragement',
                            'Structure',
                            'Calm',
                            'Accountability',
                          ],
                          isDarkTheme: widget.isDarkTheme,
                          onChanged: (value) {
                            setModalState(() => _newNeed = value);
                          },
                        ),
                        const SizedBox(height: 22),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton.icon(
                            onPressed: _saveNewGoal,
                            icon: const Icon(Icons.check_rounded),
                            label: const Text(
                              'Save Goal',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: deepTeal,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _saveNewGoal() {
    final title = _goalController.text.trim();
    final reason = _reasonController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: deepTeal,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          content: const Text(
            'Please enter a goal title first.',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
      return;
    }

    final goal = ImpiloGoal(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      category: _newCategory,
      reason: reason,
      timeframe: _newTimeframe,
      mood: _newMood,
      need: _newNeed,
      coachStyle: widget.coachStyle,
      createdAt: DateTime.now(),
      isTodayFocus: true,
    );

    widget.onGoalAdded(goal);
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: deepTeal,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        content: const Text(
          'Goal created and set as today’s focus.',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  void _updateGoalSummary() {
    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: deepTeal,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        content: Text(
          _activeGoal.completedMilestones == 0
              ? 'Start with one small action to activate this goal.'
              : 'Your goal progress has been updated.',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.goals.isEmpty) {
      return Scaffold(
        backgroundColor: _backgroundColor,
        body: Center(
          child: Text(
            'No goals available yet.',
            style: TextStyle(
              color: _textColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: _backgroundColor,
      body: Stack(
        children: [
          _buildBackground(),
          SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 150),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 20),

                  // Green card moved above Create Goal
                  _buildHeroGoalCard(),

                  const SizedBox(height: 18),

                  // Create Goal moved below green card
                  _buildCreateGoalButton(),

                  const SizedBox(height: 18),
                  _buildProgressCard(),
                  const SizedBox(height: 18),
                  _buildAutomatedInsightCard(),
                  const SizedBox(height: 22),
                  _SectionHeader(
                    title: 'All Goals',
                    subtitle:
                        'Tap a goal to make it today’s focus across the app.',
                    isDarkTheme: widget.isDarkTheme,
                  ),
                  const SizedBox(height: 14),
                  _buildGoalsList(),
                  const SizedBox(height: 22),
                  _SectionHeader(
                    title: 'Milestones',
                    subtitle: 'Simple checkpoints for your active goal.',
                    isDarkTheme: widget.isDarkTheme,
                  ),
                  const SizedBox(height: 14),
                  _buildMilestones(_activeGoal),
                  const SizedBox(height: 18),
                  _buildImprovementCard(),
                  const SizedBox(height: 18),
                  _buildSummaryButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const _IconBox(icon: Icons.flag_rounded),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Goals',
                style: TextStyle(
                  color: _textColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '${widget.goals.length} goal${widget.goals.length == 1 ? '' : 's'} created.',
                style: TextStyle(
                  color: _subTextColor,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCreateGoalButton() {
    return GestureDetector(
      onTap: _openCreateGoalSheet,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: _softCardColor,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(
            color: turquoise.withOpacity(widget.isDarkTheme ? 0.24 : 0.22),
          ),
        ),
        child: Row(
          children: [
            const _IconBox(icon: Icons.add_rounded),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create a New Goal',
                    style: TextStyle(
                      color: _textColor,
                      fontSize: 15.5,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Add another goal and Impilo will sync it across Home, Tasks, Goals, Profile, and later Chat.',
                    style: TextStyle(
                      color: _subTextColor,
                      fontSize: 12.2,
                      fontWeight: FontWeight.w600,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: widget.isDarkTheme
                  ? Colors.white.withOpacity(0.35)
                  : darkTeal.withOpacity(0.35),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroGoalCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF075D58),
            Color(0xFF0A7A75),
            Color(0xFF0DBFB0),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: turquoise.withOpacity(widget.isDarkTheme ? 0.12 : 0.20),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _HeroTag(text: _activeGoal.category),
              _HeroTag(text: _activeGoal.timeframe),
              _HeroTag(text: _activeGoal.mood),
            ],
          ),
          const SizedBox(height: 22),
          Text(
            '${widget.userName}, today’s focus goal',
            style: TextStyle(
              color: Colors.white.withOpacity(0.84),
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _activeGoal.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
              height: 1.18,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _activeGoal.reason.trim().isEmpty
                ? 'Your reason will help Impilo keep this goal meaningful.'
                : _activeGoal.reason,
            style: TextStyle(
              color: Colors.white.withOpacity(0.78),
              fontSize: 12.7,
              fontWeight: FontWeight.w600,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard() {
    return _StandardCard(
      icon: Icons.insights_rounded,
      title: 'Goal Progress',
      badge: _activeGoal.progressLabel,
      isDarkTheme: widget.isDarkTheme,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              minHeight: 10,
              value: _activeGoal.progress,
              backgroundColor: widget.isDarkTheme ? darkCardSoft : lightAqua,
              valueColor: const AlwaysStoppedAnimation<Color>(turquoise),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            _activeGoal.healthText,
            style: TextStyle(
              color: _subTextColor,
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAutomatedInsightCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: _softCardColor,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: turquoise.withOpacity(0.22)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _IconBox(icon: Icons.auto_awesome_rounded),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Automated Goal Insight',
                  style: TextStyle(
                    color: _textColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _automatedInsight,
                  style: TextStyle(
                    color: _subTextColor,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalsList() {
    return Column(
      children: widget.goals.map((goal) {
        final isActive = goal.id == widget.activeGoalId;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _GoalListCard(
            goal: goal,
            isActive: isActive,
            isDarkTheme: widget.isDarkTheme,
            onTap: () => widget.onGoalSelected(goal.id),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMilestones(ImpiloGoal goal) {
    return Column(
      children: [
        _MilestoneCard(
          icon: Icons.bolt_rounded,
          title: 'First small step',
          description: 'Mark this when you have taken one action.',
          isCompleted: goal.firstStepDone,
          isDarkTheme: widget.isDarkTheme,
          onTap: () {
            widget.onMilestoneChanged(
              goal.id,
              'firstStep',
              !goal.firstStepDone,
            );
          },
        ),
        const SizedBox(height: 12),
        _MilestoneCard(
          icon: Icons.repeat_rounded,
          title: 'Routine started',
          description: 'Mark this when this goal has a repeatable rhythm.',
          isCompleted: goal.routineStarted,
          isDarkTheme: widget.isDarkTheme,
          onTap: () {
            widget.onMilestoneChanged(
              goal.id,
              'routine',
              !goal.routineStarted,
            );
          },
        ),
        const SizedBox(height: 12),
        _MilestoneCard(
          icon: Icons.edit_note_rounded,
          title: 'Reflection added',
          description: 'Mark this when you have reflected on progress.',
          isCompleted: goal.reflectionAdded,
          isDarkTheme: widget.isDarkTheme,
          onTap: () {
            widget.onMilestoneChanged(
              goal.id,
              'reflection',
              !goal.reflectionAdded,
            );
          },
        ),
      ],
    );
  }

  Widget _buildImprovementCard() {
    return _StandardCard(
      icon: Icons.trending_up_rounded,
      title: 'What To Improve',
      badge: 'Focus',
      isDarkTheme: widget.isDarkTheme,
      child: Column(
        children: [
          _ImprovementRow(
            title: 'Consistency',
            description:
                'Keep the goal active through small repeatable actions.',
            isDarkTheme: widget.isDarkTheme,
          ),
          const SizedBox(height: 12),
          _ImprovementRow(
            title: 'Reflection',
            description: 'Notice what works so Impilo can guide you better.',
            isDarkTheme: widget.isDarkTheme,
          ),
          const SizedBox(height: 12),
          _ImprovementRow(
            title: 'Simplicity',
            description: 'Avoid making the goal too heavy. Start small.',
            isDarkTheme: widget.isDarkTheme,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _updateGoalSummary,
        style: ElevatedButton.styleFrom(
          backgroundColor: deepTeal,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: const Text(
          'Update Goal Summary',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: widget.isDarkTheme
                ? const [
                    Color(0xFF031210),
                    Color(0xFF06211F),
                    Color(0xFF0A2F2B),
                  ]
                : const [
                    Color(0xFFE0FDF9),
                    Color(0xFFCCFAF7),
                    Color(0xFFFFFFFF),
                  ],
          ),
        ),
      ),
    );
  }
}

class _GoalListCard extends StatelessWidget {
  final ImpiloGoal goal;
  final bool isActive;
  final bool isDarkTheme;
  final VoidCallback onTap;

  const _GoalListCard({
    required this.goal,
    required this.isActive,
    required this.isDarkTheme,
    required this.onTap,
  });

  static const Color deepTeal = Color(0xFF0A7A75);
  static const Color turquoise = Color(0xFF0DBFB0);
  static const Color lightAqua = Color(0xFFCCFAF7);
  static const Color darkTeal = Color(0xFF061A19);
  static const Color darkCard = Color(0xFF0B2624);
  static const Color darkCardSoft = Color(0xFF123C38);

  @override
  Widget build(BuildContext context) {
    final textColor = isDarkTheme ? const Color(0xFFE9FFFC) : darkTeal;
    final subTextColor = isDarkTheme
        ? Colors.white.withOpacity(0.62)
        : darkTeal.withOpacity(0.58);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      decoration: BoxDecoration(
        color: isActive
            ? turquoise.withOpacity(isDarkTheme ? 0.18 : 0.13)
            : isDarkTheme
                ? darkCard
                : Colors.white.withOpacity(0.90),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: isActive
              ? turquoise.withOpacity(0.45)
              : turquoise.withOpacity(isDarkTheme ? 0.22 : 0.15),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(26),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _IconBox(
                  icon: isActive ? Icons.star_rounded : Icons.flag_rounded,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        goal.title,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        '${goal.category} • ${goal.timeframe} • ${goal.progressLabel}',
                        style: TextStyle(
                          color: subTextColor,
                          fontSize: 12.2,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: LinearProgressIndicator(
                          minHeight: 6,
                          value: goal.progress,
                          backgroundColor:
                              isDarkTheme ? darkCardSoft : lightAqua,
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(turquoise),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MilestoneCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool isCompleted;
  final bool isDarkTheme;
  final VoidCallback onTap;

  const _MilestoneCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.isDarkTheme,
    required this.onTap,
  });

  static const Color turquoise = Color(0xFF0DBFB0);
  static const Color darkTeal = Color(0xFF061A19);
  static const Color darkCard = Color(0xFF0B2624);

  @override
  Widget build(BuildContext context) {
    final textColor = isDarkTheme ? const Color(0xFFE9FFFC) : darkTeal;
    final subTextColor = isDarkTheme
        ? Colors.white.withOpacity(0.62)
        : darkTeal.withOpacity(0.58);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      decoration: BoxDecoration(
        color: isCompleted
            ? turquoise.withOpacity(isDarkTheme ? 0.18 : 0.13)
            : isDarkTheme
                ? darkCard
                : Colors.white.withOpacity(0.90),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: isCompleted
              ? turquoise.withOpacity(0.45)
              : turquoise.withOpacity(isDarkTheme ? 0.22 : 0.15),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(26),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _IconBox(icon: isCompleted ? Icons.check_rounded : icon),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          decoration: isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        description,
                        style: TextStyle(
                          color: subTextColor,
                          fontSize: 12.4,
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ImprovementRow extends StatelessWidget {
  final String title;
  final String description;
  final bool isDarkTheme;

  const _ImprovementRow({
    required this.title,
    required this.description,
    required this.isDarkTheme,
  });

  static const Color turquoise = Color(0xFF0DBFB0);
  static const Color darkTeal = Color(0xFF061A19);

  @override
  Widget build(BuildContext context) {
    final textColor = isDarkTheme ? const Color(0xFFE9FFFC) : darkTeal;
    final subTextColor = isDarkTheme
        ? Colors.white.withOpacity(0.62)
        : darkTeal.withOpacity(0.60);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 9,
          height: 9,
          margin: const EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
            color: turquoise,
            borderRadius: BorderRadius.circular(99),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$title: ',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 12.8,
                    fontWeight: FontWeight.w900,
                    height: 1.4,
                  ),
                ),
                TextSpan(
                  text: description,
                  style: TextStyle(
                    color: subTextColor,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final int maxLines;
  final bool isDarkTheme;

  const _InputField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.isDarkTheme,
    this.maxLines = 1,
  });

  static const Color turquoise = Color(0xFF0DBFB0);
  static const Color darkTeal = Color(0xFF061A19);
  static const Color darkCardSoft = Color(0xFF123C38);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      cursorColor: turquoise,
      style: TextStyle(
        color: isDarkTheme ? const Color(0xFFE9FFFC) : darkTeal,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor:
            isDarkTheme ? darkCardSoft : Colors.white.withOpacity(0.92),
        labelStyle: TextStyle(
          color: isDarkTheme
              ? Colors.white.withOpacity(0.58)
              : darkTeal.withOpacity(0.55),
          fontWeight: FontWeight.w700,
        ),
        hintStyle: TextStyle(
          color: isDarkTheme
              ? Colors.white.withOpacity(0.40)
              : darkTeal.withOpacity(0.40),
          fontWeight: FontWeight.w600,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: turquoise.withOpacity(0.18)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: turquoise.withOpacity(0.18)),
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

class _DropField extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;
  final bool isDarkTheme;

  const _DropField({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.isDarkTheme,
  });

  static const Color turquoise = Color(0xFF0DBFB0);
  static const Color darkTeal = Color(0xFF061A19);
  static const Color darkCard = Color(0xFF0B2624);
  static const Color darkCardSoft = Color(0xFF123C38);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      isExpanded: true,
      dropdownColor: isDarkTheme ? darkCard : Colors.white,
      style: TextStyle(
        color: isDarkTheme ? const Color(0xFFE9FFFC) : darkTeal,
        fontWeight: FontWeight.w700,
      ),
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(
            item,
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) onChanged(value);
      },
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor:
            isDarkTheme ? darkCardSoft : Colors.white.withOpacity(0.92),
        labelStyle: TextStyle(
          color: isDarkTheme
              ? Colors.white.withOpacity(0.58)
              : darkTeal.withOpacity(0.55),
          fontWeight: FontWeight.w700,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: turquoise.withOpacity(0.18)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: turquoise.withOpacity(0.18)),
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

class _StandardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String badge;
  final Widget child;
  final bool isDarkTheme;

  const _StandardCard({
    required this.icon,
    required this.title,
    required this.badge,
    required this.child,
    required this.isDarkTheme,
  });

  static const Color turquoise = Color(0xFF0DBFB0);
  static const Color darkCard = Color(0xFF0B2624);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDarkTheme ? darkCard : Colors.white.withOpacity(0.90),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: turquoise.withOpacity(isDarkTheme ? 0.22 : 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardTitleRow(
            icon: icon,
            title: title,
            badge: badge,
            isDarkTheme: isDarkTheme,
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _CardTitleRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String badge;
  final bool isDarkTheme;

  const _CardTitleRow({
    required this.icon,
    required this.title,
    required this.badge,
    required this.isDarkTheme,
  });

  static const Color deepTeal = Color(0xFF0A7A75);
  static const Color turquoise = Color(0xFF0DBFB0);
  static const Color darkTeal = Color(0xFF061A19);

  @override
  Widget build(BuildContext context) {
    final textColor = isDarkTheme ? const Color(0xFFE9FFFC) : darkTeal;

    return Row(
      children: [
        _IconBox(icon: icon),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: textColor,
              fontSize: 15.5,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
          decoration: BoxDecoration(
            color: turquoise.withOpacity(isDarkTheme ? 0.18 : 0.12),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            badge,
            style: const TextStyle(
              color: deepTeal,
              fontSize: 10,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}

class _IconBox extends StatelessWidget {
  final IconData icon;

  const _IconBox({required this.icon});

  static const Color deepTeal = Color(0xFF0A7A75);
  static const Color turquoise = Color(0xFF0DBFB0);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 43,
      height: 43,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [deepTeal, turquoise]),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(icon, color: Colors.white, size: 22),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isDarkTheme;

  const _SectionHeader({
    required this.title,
    required this.subtitle,
    required this.isDarkTheme,
  });

  static const Color darkTeal = Color(0xFF061A19);

  @override
  Widget build(BuildContext context) {
    final textColor = isDarkTheme ? const Color(0xFFE9FFFC) : darkTeal;
    final subTextColor =
        isDarkTheme ? Colors.white.withOpacity(0.58) : darkTeal.withOpacity(0.50);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: textColor,
            fontSize: 19,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            color: subTextColor,
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _HeroTag extends StatelessWidget {
  final String text;

  const _HeroTag({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.16),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white.withOpacity(0.88),
          fontSize: 10.5,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}