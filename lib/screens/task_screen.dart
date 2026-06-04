import 'package:flutter/material.dart';
import '../models/impilo_goal.dart';

class TaskScreen extends StatefulWidget {
  final String userName;
  final String coachStyle;
  final List<ImpiloGoal> goals;
  final String activeGoalId;
  final ValueChanged<String> onGoalSelected;
  final void Function(String goalId, String milestone, bool value)
      onMilestoneChanged;
  final bool isDarkTheme;

  const TaskScreen({
    super.key,
    required this.userName,
    required this.coachStyle,
    required this.goals,
    required this.activeGoalId,
    required this.onGoalSelected,
    required this.onMilestoneChanged,
    required this.isDarkTheme,
  });

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  static const Color deepTeal = Color(0xFF0A7A75);
  static const Color turquoise = Color(0xFF0DBFB0);
  static const Color softMint = Color(0xFFE0FDF9);
  static const Color lightAqua = Color(0xFFCCFAF7);
  static const Color darkTeal = Color(0xFF061A19);

  static const Color darkBackground = Color(0xFF031210);
  static const Color darkCard = Color(0xFF0B2624);
  static const Color darkCardSoft = Color(0xFF123C38);
  static const Color darkText = Color(0xFFE9FFFC);

  late String _selectedGoalId;

  final TextEditingController _reflectionController = TextEditingController();
  final TextEditingController _taskTitleController = TextEditingController();
  final TextEditingController _taskDescriptionController =
      TextEditingController();

  final Map<String, List<_ImpiloTask>> _taskCache = {};
  bool _dayFinished = false;

  Color get _backgroundColor =>
      widget.isDarkTheme ? darkBackground : softMint;

  Color get _cardColor =>
      widget.isDarkTheme ? darkCard : Colors.white.withOpacity(0.90);

  Color get _softCardColor => widget.isDarkTheme
      ? turquoise.withOpacity(0.16)
      : turquoise.withOpacity(0.10);

  Color get _textColor => widget.isDarkTheme ? darkText : darkTeal;

  Color get _subTextColor => widget.isDarkTheme
      ? Colors.white.withOpacity(0.65)
      : darkTeal.withOpacity(0.62);

  Color get _fieldColor =>
      widget.isDarkTheme ? darkCardSoft : Colors.white.withOpacity(0.92);

  @override
  void initState() {
    super.initState();
    _selectedGoalId = widget.activeGoalId;
  }

  @override
  void didUpdateWidget(covariant TaskScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    final selectedGoalStillExists =
        widget.goals.any((goal) => goal.id == _selectedGoalId);

    if (!selectedGoalStillExists && widget.goals.isNotEmpty) {
      _selectedGoalId = widget.activeGoalId;
    }
  }

  @override
  void dispose() {
    _reflectionController.dispose();
    _taskTitleController.dispose();
    _taskDescriptionController.dispose();
    super.dispose();
  }

  ImpiloGoal get _selectedGoal {
    return widget.goals.firstWhere(
      (goal) => goal.id == _selectedGoalId,
      orElse: () => widget.goals.first,
    );
  }

  List<_ImpiloTask> get _tasks {
    return _taskCache.putIfAbsent(
      _selectedGoal.id,
      () => _generateTasks(_selectedGoal),
    );
  }

  int get _completedCount {
    return _tasks.where((task) => task.isCompleted).length;
  }

  int get _remainingCount {
    return _tasks.length - _completedCount;
  }

  double get _progress {
    if (_tasks.isEmpty) return 0;
    return _completedCount / _tasks.length;
  }

  String get _encouragementMessage {
    if (_tasks.isEmpty) {
      return 'Add one task to begin your day.';
    }

    if (_completedCount == 0) {
      return 'Start small. You only need to complete one task to build momentum.';
    }

    if (_completedCount < _tasks.length) {
      return 'Good start. You have $_remainingCount task${_remainingCount == 1 ? '' : 's'} left.';
    }

    return 'Excellent work. Add a reflection and finish today.';
  }

  String get _automatedNextStep {
    if (_tasks.isEmpty) {
      return 'Add your first task for today.';
    }

    if (_completedCount == 0) {
      return 'Do the easiest task first. One small win makes the rest easier.';
    }

    if (_completedCount == _tasks.length) {
      return 'All tasks are complete. Add a reflection and finish today.';
    }

    if (_selectedGoal.mood.toLowerCase().contains('tired')) {
      return 'Keep the next step light. Complete one small action, then pause.';
    }

    if (_selectedGoal.need.toLowerCase().contains('focus')) {
      return 'Use a short focus block. Remove one distraction and continue.';
    }

    return 'Choose one remaining task and complete it calmly.';
  }

  List<_ImpiloTask> _generateTasks(ImpiloGoal goal) {
    final title = goal.title.toLowerCase();

    if (title.contains('study') ||
        title.contains('assignment') ||
        title.contains('college')) {
      return [
        _ImpiloTask(
          title: 'Start one focused study block',
          description: 'Spend 25 minutes on one clear study task.',
          icon: Icons.school_rounded,
          tag: 'Focus',
          isAutomated: true,
        ),
        _ImpiloTask(
          title: 'Prepare your study space',
          description: 'Remove one distraction and keep only what you need.',
          icon: Icons.center_focus_strong_rounded,
          tag: 'Setup',
          isAutomated: true,
        ),
        _ImpiloTask(
          title: 'Reflect after studying',
          description: 'Write one sentence about what helped you focus.',
          icon: Icons.edit_note_rounded,
          tag: 'Reflect',
          isAutomated: true,
        ),
      ];
    }

    if (title.contains('gym') ||
        title.contains('fitness') ||
        title.contains('exercise')) {
      return [
        _ImpiloTask(
          title: 'Complete one movement session',
          description:
              'Do a short workout, walk, stretch, or movement activity.',
          icon: Icons.fitness_center_rounded,
          tag: 'Body',
          isAutomated: true,
        ),
        _ImpiloTask(
          title: 'Support your energy',
          description: 'Drink water and avoid pushing beyond your limit.',
          icon: Icons.water_drop_rounded,
          tag: 'Energy',
          isAutomated: true,
        ),
        _ImpiloTask(
          title: 'Record how you feel',
          description: 'Write one short note about your energy after moving.',
          icon: Icons.favorite_rounded,
          tag: 'Check-in',
          isAutomated: true,
        ),
      ];
    }

    if (title.contains('money') ||
        title.contains('budget') ||
        title.contains('save')) {
      return [
        _ImpiloTask(
          title: 'Review one spending choice',
          description: 'Look at one recent spending choice and learn from it.',
          icon: Icons.savings_rounded,
          tag: 'Money',
          isAutomated: true,
        ),
        _ImpiloTask(
          title: 'Choose one better habit',
          description: 'Pick one small money habit to improve today.',
          icon: Icons.check_circle_rounded,
          tag: 'Habit',
          isAutomated: true,
        ),
        _ImpiloTask(
          title: 'Write your money intention',
          description: 'Write why this goal matters to your future.',
          icon: Icons.edit_note_rounded,
          tag: 'Reflect',
          isAutomated: true,
        ),
      ];
    }

    if (title.contains('procrastinat') ||
        title.contains('discipline') ||
        title.contains('routine')) {
      return [
        _ImpiloTask(
          title: 'Start with one small task',
          description:
              'Choose one task you have delayed and work on it for 10 minutes.',
          icon: Icons.bolt_rounded,
          tag: 'Start',
          isAutomated: true,
        ),
        _ImpiloTask(
          title: 'Remove one distraction',
          description: 'Put away one distraction before starting.',
          icon: Icons.center_focus_strong_rounded,
          tag: 'Focus',
          isAutomated: true,
        ),
        _ImpiloTask(
          title: 'Reflect on what helped',
          description:
              'Write one sentence about what made it easier or harder to act.',
          icon: Icons.psychology_alt_rounded,
          tag: 'Reflect',
          isAutomated: true,
        ),
      ];
    }

    return [
      _ImpiloTask(
        title: 'Take one small action',
        description: 'Do one realistic step that moves this goal forward.',
        icon: Icons.flag_rounded,
        tag: 'Action',
        isAutomated: true,
      ),
      _ImpiloTask(
        title: 'Support your progress',
        description: 'Choose one thing that makes this goal easier today.',
        icon: Icons.auto_awesome_rounded,
        tag: 'Support',
        isAutomated: true,
      ),
      _ImpiloTask(
        title: 'Reflect honestly',
        description: 'Write one sentence about what helped or slowed you down.',
        icon: Icons.edit_note_rounded,
        tag: 'Reflect',
        isAutomated: true,
      ),
    ];
  }

  void _toggleTask(int index) {
    setState(() {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
      _dayFinished = false;
    });

    if (_completedCount >= 1) {
      widget.onMilestoneChanged(_selectedGoal.id, 'firstStep', true);
    }

    if (_completedCount >= 2) {
      widget.onMilestoneChanged(_selectedGoal.id, 'routine', true);
    }
  }

  void _completeNextSmallStep() {
    final index = _tasks.indexWhere((task) => !task.isCompleted);

    if (index == -1) {
      _finishToday();
      return;
    }

    setState(() {
      _tasks[index].isCompleted = true;
      _dayFinished = false;
    });

    if (_completedCount >= 1) {
      widget.onMilestoneChanged(_selectedGoal.id, 'firstStep', true);
    }

    if (_completedCount >= 2) {
      widget.onMilestoneChanged(_selectedGoal.id, 'routine', true);
    }

    _showMessage('Nice. One task completed.');
  }

  void _openAddTaskSheet() {
    _taskTitleController.clear();
    _taskDescriptionController.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
            decoration: BoxDecoration(
              color: widget.isDarkTheme
                  ? const Color(0xFF071C1B)
                  : const Color(0xFFF5FFFD),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(30),
              ),
              border: Border.all(
                color: turquoise.withOpacity(widget.isDarkTheme ? 0.22 : 0),
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
                      const _IconBox(icon: Icons.add_task_rounded),
                      const SizedBox(width: 13),
                      Expanded(
                        child: Text(
                          'Add Task',
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
                    'Create a personal task linked to your active goal.',
                    style: TextStyle(
                      color: _subTextColor,
                      fontSize: 12.8,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _taskTitleController,
                    cursorColor: turquoise,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(
                      color: _textColor,
                      fontWeight: FontWeight.w700,
                    ),
                    decoration: _inputDecoration('Task title'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _taskDescriptionController,
                    maxLines: 3,
                    cursorColor: turquoise,
                    style: TextStyle(
                      color: _textColor,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: _inputDecoration('Small description'),
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: _saveCustomTask,
                      icon: const Icon(Icons.check_rounded),
                      label: const Text(
                        'Save Task',
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _saveCustomTask() {
    final title = _taskTitleController.text.trim();
    final description = _taskDescriptionController.text.trim();

    if (title.isEmpty) {
      _showMessage('Please enter a task title first.');
      return;
    }

    setState(() {
      _tasks.insert(
        0,
        _ImpiloTask(
          title: title,
          description: description.isEmpty
              ? 'A personal task you added for today.'
              : description,
          icon: Icons.checklist_rounded,
          tag: 'Custom',
          isAutomated: false,
        ),
      );

      _dayFinished = false;
    });

    Navigator.pop(context);
    _showMessage('Task added to today.');
  }

  void _finishToday() {
    if (_completedCount == 0) {
      _showMessage('Complete one small task first, then finish your day.');
      return;
    }

    if (_reflectionController.text.trim().isNotEmpty) {
      widget.onMilestoneChanged(_selectedGoal.id, 'reflection', true);
    }

    setState(() {
      _dayFinished = true;
    });

    if (_completedCount < _tasks.length) {
      _showMessage(
        'Day saved. You completed $_completedCount of ${_tasks.length} tasks.',
      );
    } else {
      _showMessage('Great work! All tasks are complete.');
    }
  }

  void _clearReflection() {
    setState(() {
      _reflectionController.clear();
      _dayFinished = false;
    });
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
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 130),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 18),
                  _buildGoalCard(),
                  const SizedBox(height: 16),
                  _buildAddTaskButton(),
                  const SizedBox(height: 16),
                  _buildSmartStarterCard(),
                  const SizedBox(height: 18),
                  _buildProgressCard(),
                  const SizedBox(height: 22),
                  _SectionHeader(
                    title: 'Today’s Actions',
                    subtitle: 'Tap a task when you complete it.',
                    isDarkTheme: widget.isDarkTheme,
                  ),
                  const SizedBox(height: 14),
                  _buildTaskList(),
                  const SizedBox(height: 18),
                  _buildReflectionCard(),
                  const SizedBox(height: 18),
                  _buildFinishButton(),
                  if (_dayFinished) ...[
                    const SizedBox(height: 18),
                    _buildSummaryCard(),
                  ],
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
        const _IconBox(icon: Icons.task_alt_rounded),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Today’s Tasks',
                style: TextStyle(
                  color: _textColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Start small. Finish one step at a time.',
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

  Widget _buildGoalCard() {
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
              _HeroTag(text: _selectedGoal.category),
              _HeroTag(text: _selectedGoal.mood),
              _HeroTag(text: _selectedGoal.need),
            ],
          ),
          const SizedBox(height: 22),
          Text(
            '${widget.userName}, your selected goal',
            style: TextStyle(
              color: Colors.white.withOpacity(0.84),
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _selectedGoal.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
              height: 1.18,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            _selectedGoal.reason.trim().isEmpty
                ? 'Add a reason on the Goals page to make this goal more meaningful.'
                : _selectedGoal.reason,
            style: TextStyle(
              color: Colors.white.withOpacity(0.80),
              fontSize: 12.7,
              fontWeight: FontWeight.w600,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddTaskButton() {
    return GestureDetector(
      onTap: _openAddTaskSheet,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: _softCardColor,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(
            color: turquoise.withOpacity(widget.isDarkTheme ? 0.26 : 0.22),
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
                    'Add Your Own Task',
                    style: TextStyle(
                      color: _textColor,
                      fontSize: 15.5,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Create a task that fits what you need to do today.',
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

  Widget _buildSmartStarterCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: _softCardColor,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: turquoise.withOpacity(widget.isDarkTheme ? 0.26 : 0.22),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _IconBox(icon: Icons.bolt_rounded),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Smart Next Step',
                  style: TextStyle(
                    color: _textColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _automatedNextStep,
                  style: TextStyle(
                    color: _subTextColor,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 13),
                SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: ElevatedButton.icon(
                    onPressed: _completeNextSmallStep,
                    icon: const Icon(Icons.flash_on_rounded, size: 18),
                    label: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        _completedCount == _tasks.length
                            ? 'Finish Today'
                            : 'Do Easiest Task First',
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: deepTeal,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard() {
    return _StandardCard(
      icon: Icons.insights_rounded,
      title: 'Task Progress',
      badge: '$_completedCount/${_tasks.length}',
      isDarkTheme: widget.isDarkTheme,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              minHeight: 9,
              value: _progress,
              backgroundColor: widget.isDarkTheme ? darkCardSoft : lightAqua,
              valueColor: const AlwaysStoppedAnimation<Color>(turquoise),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            _encouragementMessage,
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

  Widget _buildTaskList() {
    return Column(
      children: List.generate(_tasks.length, (index) {
        final task = _tasks[index];

        return Padding(
          padding: EdgeInsets.only(bottom: index == _tasks.length - 1 ? 0 : 12),
          child: _TaskCard(
            task: task,
            isDarkTheme: widget.isDarkTheme,
            onTap: () => _toggleTask(index),
          ),
        );
      }),
    );
  }

  Widget _buildReflectionCard() {
    return _StandardCard(
      icon: Icons.edit_note_rounded,
      title: 'Quick Reflection',
      badge: 'Optional',
      isDarkTheme: widget.isDarkTheme,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What helped you take action today?',
            style: TextStyle(
              color: _subTextColor,
              fontSize: 12.8,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _reflectionController,
            maxLines: 3,
            cursorColor: turquoise,
            style: TextStyle(
              color: _textColor,
              fontWeight: FontWeight.w600,
            ),
            onChanged: (_) {
              if (_dayFinished) {
                setState(() => _dayFinished = false);
              }
            },
            decoration: _inputDecoration('Write a short reflection...'),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: _clearReflection,
              icon: const Icon(Icons.refresh_rounded, size: 17),
              label: const Text('Clear reflection'),
              style: TextButton.styleFrom(foregroundColor: turquoise),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinishButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _finishToday,
        style: ElevatedButton.styleFrom(
          backgroundColor: deepTeal,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: Text(
          _completedCount == _tasks.length && _tasks.isNotEmpty
              ? 'Finish Today'
              : 'Save Today’s Progress',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return _StandardCard(
      icon: Icons.verified_rounded,
      title: 'Daily Summary Ready',
      badge: 'Done',
      isDarkTheme: widget.isDarkTheme,
      child: Text(
        'Impilo saved your progress for "${_selectedGoal.title}". You completed $_completedCount of ${_tasks.length} tasks today.',
        style: TextStyle(
          color: _subTextColor,
          fontSize: 12.6,
          fontWeight: FontWeight.w600,
          height: 1.45,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: _fieldColor,
      labelStyle: TextStyle(
        color: widget.isDarkTheme
            ? Colors.white.withOpacity(0.56)
            : darkTeal.withOpacity(0.55),
        fontWeight: FontWeight.w700,
      ),
      hintStyle: TextStyle(
        color: widget.isDarkTheme
            ? Colors.white.withOpacity(0.40)
            : darkTeal.withOpacity(0.40),
        fontWeight: FontWeight.w600,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: turquoise.withOpacity(0.16)),
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

class _ImpiloTask {
  final String title;
  final String description;
  final IconData icon;
  final String tag;
  final bool isAutomated;
  bool isCompleted;

  _ImpiloTask({
    required this.title,
    required this.description,
    required this.icon,
    required this.tag,
    required this.isAutomated,
    this.isCompleted = false,
  });
}

class _TaskCard extends StatelessWidget {
  final _ImpiloTask task;
  final bool isDarkTheme;
  final VoidCallback onTap;

  const _TaskCard({
    required this.task,
    required this.isDarkTheme,
    required this.onTap,
  });

  static const Color deepTeal = Color(0xFF0A7A75);
  static const Color turquoise = Color(0xFF0DBFB0);
  static const Color softMint = Color(0xFFE0FDF9);
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
      width: double.infinity,
      decoration: BoxDecoration(
        color: task.isCompleted
            ? turquoise.withOpacity(isDarkTheme ? 0.18 : 0.13)
            : isDarkTheme
                ? darkCard
                : Colors.white.withOpacity(0.88),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: task.isCompleted
              ? turquoise.withOpacity(0.45)
              : turquoise.withOpacity(isDarkTheme ? 0.22 : 0.15),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(26),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: task.isCompleted
                        ? turquoise
                        : turquoise.withOpacity(isDarkTheme ? 0.18 : 0.12),
                    borderRadius: BorderRadius.circular(17),
                  ),
                  child: Icon(
                    task.isCompleted ? Icons.check_rounded : task.icon,
                    color: task.isCompleted ? Colors.white : deepTeal,
                    size: 23,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        task.description,
                        style: TextStyle(
                          color: subTextColor,
                          fontSize: 12.4,
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _SmallTag(
                            text: task.tag,
                            isDarkTheme: isDarkTheme,
                          ),
                          _SmallTag(
                            text: task.isAutomated ? 'Impilo' : 'Personal',
                            isDarkTheme: isDarkTheme,
                          ),
                          _SmallTag(
                            text: task.isCompleted ? 'Done' : 'Tap to finish',
                            isDarkTheme: isDarkTheme,
                          ),
                        ],
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

class _SmallTag extends StatelessWidget {
  final String text;
  final bool isDarkTheme;

  const _SmallTag({
    required this.text,
    required this.isDarkTheme,
  });

  static const Color softMint = Color(0xFFE0FDF9);
  static const Color darkTeal = Color(0xFF061A19);
  static const Color darkCardSoft = Color(0xFF123C38);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: isDarkTheme ? darkCardSoft : softMint,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isDarkTheme
              ? Colors.white.withOpacity(0.70)
              : darkTeal.withOpacity(0.56),
          fontSize: 9.5,
          fontWeight: FontWeight.w900,
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
        gradient: const LinearGradient(
          colors: [
            deepTeal,
            turquoise,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 22,
      ),
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

    final subTextColor = isDarkTheme
        ? Colors.white.withOpacity(0.58)
        : darkTeal.withOpacity(0.50);

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