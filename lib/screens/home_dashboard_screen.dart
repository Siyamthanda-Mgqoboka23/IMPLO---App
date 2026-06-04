import 'dart:async';
import 'package:flutter/material.dart';

import '../models/impilo_goal.dart';
import '../services/demo_auth_service.dart';
import 'task_screen.dart';
import 'goals_screen.dart';
import 'profile_screen.dart';

class HomeDashboardScreen extends StatefulWidget {
  final String userName;
  final String coachStyle;
  final String goal;
  final String reason;
  final String timeframe;
  final String mood;
  final String need;
  final String? selectedArea;

  const HomeDashboardScreen({
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
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  static const Color deepTeal = Color(0xFF0A7A75);
  static const Color turquoise = Color(0xFF0DBFB0);
  static const Color softMint = Color(0xFFE0FDF9);
  static const Color darkBackground = Color(0xFF031210);

  int _selectedIndex = 0;
  bool _isDarkTheme = false;

  late List<ImpiloGoal> _goals;
  late String _activeGoalId;

  Color get _scaffoldColor => _isDarkTheme ? darkBackground : softMint;

  @override
  void initState() {
    super.initState();

    final currentUser = DemoAuthService.instance.currentUser;
    _isDarkTheme = currentUser?.isDarkTheme ?? false;

    final firstGoal = ImpiloGoal(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: widget.goal,
      category: widget.selectedArea ?? 'Personal Growth',
      reason: widget.reason,
      timeframe: widget.timeframe,
      mood: widget.mood,
      need: widget.need,
      coachStyle: widget.coachStyle,
      createdAt: DateTime.now(),
      isTodayFocus: true,
    );

    _goals = [firstGoal];
    _activeGoalId = firstGoal.id;
  }

  ImpiloGoal get _activeGoal {
    return _goals.firstWhere(
      (goal) => goal.id == _activeGoalId,
      orElse: () => _goals.first,
    );
  }

  String get _greeting {
    final hour = DateTime.now().hour;

    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  void _changePage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _setActiveGoal(String goalId) {
    setState(() {
      _activeGoalId = goalId;

      for (final goal in _goals) {
        goal.isTodayFocus = goal.id == goalId;
      }
    });
  }

  void _addGoal(ImpiloGoal goal) {
    setState(() {
      for (final existingGoal in _goals) {
        existingGoal.isTodayFocus = false;
      }

      goal.isTodayFocus = true;
      _goals.add(goal);
      _activeGoalId = goal.id;
    });
  }

  void _updateGoalMilestone(
    String goalId,
    String milestone,
    bool value,
  ) {
    setState(() {
      final goal = _goals.firstWhere(
        (item) => item.id == goalId,
        orElse: () => _activeGoal,
      );

      if (milestone == 'firstStep') {
        goal.firstStepDone = value;
      } else if (milestone == 'routine') {
        goal.routineStarted = value;
      } else if (milestone == 'reflection') {
        goal.reflectionAdded = value;
      }
    });
  }

  void _handleThemeChanged(bool value) {
    setState(() {
      _isDarkTheme = value;
    });

    final account = DemoAuthService.instance.currentUser;

    if (account != null) {
      DemoAuthService.instance.updateCurrentUser(
        account.copyWith(isDarkTheme: value),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _HomePage(
        userName: widget.userName,
        greeting: _greeting,
        activeGoal: _activeGoal,
        totalGoals: _goals.length,
        isDarkTheme: _isDarkTheme,
        onOpenTasks: () => _changePage(1),
        onOpenChat: () => _changePage(2),
        onOpenGoals: () => _changePage(3),
        onOpenProfile: () => _changePage(4),
      ),
      Theme(
        data: _buildThemeData(),
        child: TaskScreen(
          userName: widget.userName,
          coachStyle: widget.coachStyle,
          goals: _goals,
          activeGoalId: _activeGoalId,
          onGoalSelected: _setActiveGoal,
          onMilestoneChanged: _updateGoalMilestone,
          isDarkTheme: _isDarkTheme,
        ),
      ),
      _ChatPage(
        userName: widget.userName,
        coachStyle: widget.coachStyle,
        activeGoal: _activeGoal,
        isDarkTheme: _isDarkTheme,
      ),
      Theme(
        data: _buildThemeData(),
        child: GoalsScreen(
          userName: widget.userName,
          coachStyle: widget.coachStyle,
          goals: _goals,
          activeGoalId: _activeGoalId,
          onGoalSelected: _setActiveGoal,
          onGoalAdded: _addGoal,
          onMilestoneChanged: _updateGoalMilestone,
          isDarkTheme: _isDarkTheme,
        ),
      ),
      ProfileScreen(
        userName: widget.userName,
        coachStyle: widget.coachStyle,
        goals: _goals,
        activeGoal: _activeGoal,
        isDarkTheme: _isDarkTheme,
        onThemeChanged: _handleThemeChanged,
      ),
    ];

    return Scaffold(
      backgroundColor: _scaffoldColor,
      extendBody: true,
      body: Stack(
        children: [
          _buildBackground(),
          _buildPatternOverlay(),
          SafeArea(
            bottom: false,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: KeyedSubtree(
                key: ValueKey<String>('$_selectedIndex-$_isDarkTheme'),
                child: pages[_selectedIndex],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _CurvedBottomNavBar(
        selectedIndex: _selectedIndex,
        isDarkTheme: _isDarkTheme,
        onItemSelected: _changePage,
      ),
      floatingActionButton: _buildChatButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  ThemeData _buildThemeData() {
    return ThemeData(
      useMaterial3: true,
      brightness: _isDarkTheme ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor:
          _isDarkTheme ? const Color(0xFF031210) : softMint,
      colorScheme: ColorScheme.fromSeed(
        seedColor: turquoise,
        brightness: _isDarkTheme ? Brightness.dark : Brightness.light,
      ),
    );
  }

  Widget _buildChatButton() {
    final bool isSelected = _selectedIndex == 2;

    return GestureDetector(
      onTap: () => _changePage(2),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        width: 66,
        height: 66,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [
              deepTeal,
              turquoise,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: turquoise.withOpacity(isSelected ? 0.45 : 0.28),
              blurRadius: isSelected ? 30 : 22,
              offset: const Offset(0, 10),
            ),
          ],
          border: Border.all(
            color: _isDarkTheme ? const Color(0xFF031210) : Colors.white,
            width: 5,
          ),
        ),
        child: const Icon(
          Icons.chat_bubble_rounded,
          color: Colors.white,
          size: 28,
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
            colors: _isDarkTheme
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

  Widget _buildPatternOverlay() {
    return Positioned.fill(
      child: IgnorePointer(
        child: CustomPaint(
          painter: _DashboardPatternPainter(isDarkTheme: _isDarkTheme),
        ),
      ),
    );
  }
}

class _HomePage extends StatelessWidget {
  final String userName;
  final String greeting;
  final ImpiloGoal activeGoal;
  final int totalGoals;
  final bool isDarkTheme;
  final VoidCallback onOpenTasks;
  final VoidCallback onOpenChat;
  final VoidCallback onOpenGoals;
  final VoidCallback onOpenProfile;

  const _HomePage({
    required this.userName,
    required this.greeting,
    required this.activeGoal,
    required this.totalGoals,
    required this.isDarkTheme,
    required this.onOpenTasks,
    required this.onOpenChat,
    required this.onOpenGoals,
    required this.onOpenProfile,
  });

  static const Color deepTeal = Color(0xFF0A7A75);
  static const Color turquoise = Color(0xFF0DBFB0);
  static const Color darkTeal = Color(0xFF061A19);

  Color get _textColor =>
      isDarkTheme ? const Color(0xFFE9FFFC) : darkTeal;

  Color get _subTextColor =>
      isDarkTheme ? Colors.white.withOpacity(0.65) : darkTeal.withOpacity(0.56);

  String get _nextStep {
    if (!activeGoal.firstStepDone) {
      return 'Start with one small action for your active goal.';
    }

    if (!activeGoal.routineStarted) {
      return 'Turn this goal into a simple repeatable routine.';
    }

    if (!activeGoal.reflectionAdded) {
      return 'Add one short reflection so Impilo can understand your progress.';
    }

    return 'Keep your rhythm steady and continue building momentum.';
  }

  String get _rhythmMessage {
    final mood = activeGoal.mood.toLowerCase();
    final need = activeGoal.need.toLowerCase();

    if (mood.contains('tired')) {
      return 'Use a lighter rhythm today: small action first, rest, then continue gently.';
    }

    if (mood.contains('stressed')) {
      return 'Keep today simple: one clear task, one check-in, and one calm step.';
    }

    if (need.contains('focus')) {
      return 'Use focus mode: remove one distraction and work on one step.';
    }

    return 'Build momentum with one small action, one check-in, and one reflection.';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 130),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 12),
          _GoalQuoteCarousel(
            activeGoal: activeGoal,
            isDarkTheme: isDarkTheme,
          ),
          const SizedBox(height: 14),
          _buildFocusCard(),
          const SizedBox(height: 18),
          _buildNextStepCard(),
          const SizedBox(height: 20),
          _SectionHeader(
            title: 'Quick Access',
            subtitle: 'Move quickly between your main spaces.',
            isDarkTheme: isDarkTheme,
          ),
          const SizedBox(height: 10),
          _buildQuickAccessGrid(),
          const SizedBox(height: 10),
          _buildRhythmCard(),
          const SizedBox(height: 12),
          _buildProgressSnapshot(),
          const SizedBox(height: 18),
          _buildAskImpiloCard(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$greeting, $userName',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: _textColor,
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '$totalGoals active goal${totalGoals == 1 ? '' : 's'} in your growth space.',
                style: TextStyle(
                  color: _subTextColor,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: turquoise.withOpacity(isDarkTheme ? 0.18 : 0.12),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: turquoise.withOpacity(isDarkTheme ? 0.20 : 0.0),
            ),
          ),
          child: const Icon(
            Icons.notifications_none_rounded,
            color: turquoise,
          ),
        ),
      ],
    );
  }

  Widget _buildFocusCard() {
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
            color: turquoise.withOpacity(0.24),
            blurRadius: 30,
            offset: const Offset(0, 14),
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
              _HeroTag(text: activeGoal.category),
              _HeroTag(text: activeGoal.mood),
              _HeroTag(text: activeGoal.need),
            ],
          ),
          const SizedBox(height: 22),
          Text(
            'Today’s Active Goal',
            style: TextStyle(
              color: Colors.white.withOpacity(0.88),
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            activeGoal.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
              height: 1.18,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            activeGoal.reason.trim().isEmpty
                ? 'Your reason will help Impilo keep this goal meaningful.'
                : activeGoal.reason,
            style: TextStyle(
              color: Colors.white.withOpacity(0.80),
              fontSize: 12.7,
              fontWeight: FontWeight.w500,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextStepCard() {
    return _PremiumCard(
      icon: Icons.bolt_rounded,
      title: 'Automated Next Step',
      body: _nextStep,
      badge: 'Action',
      accent: true,
      isDarkTheme: isDarkTheme,
    );
  }

  Widget _buildQuickAccessGrid() {
    return GridView.count(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 10,
      childAspectRatio: 1.90,
      children: [
        _QuickAccessCard(
          icon: Icons.task_alt_rounded,
          title: 'Tasks',
          subtitle: 'Goal actions',
          isDarkTheme: isDarkTheme,
          onTap: onOpenTasks,
        ),
        _QuickAccessCard(
          icon: Icons.chat_bubble_rounded,
          title: 'AI Coach',
          subtitle: 'Talk to Impilo',
          isDarkTheme: isDarkTheme,
          onTap: onOpenChat,
        ),
        _QuickAccessCard(
          icon: Icons.flag_rounded,
          title: 'Goals',
          subtitle: 'Manage goals',
          isDarkTheme: isDarkTheme,
          onTap: onOpenGoals,
        ),
        _QuickAccessCard(
          icon: Icons.person_rounded,
          title: 'Profile',
          subtitle: 'Preferences',
          isDarkTheme: isDarkTheme,
          onTap: onOpenProfile,
        ),
      ],
    );
  }

  Widget _buildRhythmCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 15),
      decoration: BoxDecoration(
        color: turquoise.withOpacity(isDarkTheme ? 0.16 : 0.11),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: turquoise.withOpacity(isDarkTheme ? 0.25 : 0.20),
        ),
      ),
      child: Row(
        children: [
          Container(
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
            child: const Icon(
              Icons.timeline_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Text(
              _rhythmMessage,
              style: TextStyle(
                color: isDarkTheme
                    ? Colors.white.withOpacity(0.70)
                    : darkTeal.withOpacity(0.62),
                fontSize: 12.2,
                fontWeight: FontWeight.w600,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSnapshot() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
      decoration: BoxDecoration(
        color: isDarkTheme
            ? const Color(0xFF0B2624)
            : Colors.white.withOpacity(0.88),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: turquoise.withOpacity(isDarkTheme ? 0.24 : 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardTitleRow(
            icon: Icons.insights_rounded,
            title: 'Goal Snapshot',
            badge: activeGoal.progressLabel,
            isDarkTheme: isDarkTheme,
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              minHeight: 9,
              value: activeGoal.progress,
              backgroundColor:
                  isDarkTheme ? const Color(0xFF123C38) : const Color(0xFFCCFAF7),
              valueColor: const AlwaysStoppedAnimation<Color>(turquoise),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            activeGoal.healthText,
            style: TextStyle(
              color: isDarkTheme
                  ? Colors.white.withOpacity(0.65)
                  : darkTeal.withOpacity(0.58),
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAskImpiloCard() {
    return GestureDetector(
      onTap: onOpenChat,
      child: _PremiumCard(
        icon: Icons.auto_awesome_rounded,
        title: 'Ask Impilo',
        body: '“Help me take one small step toward ${activeGoal.title} today.”',
        badge: 'AI',
        accent: true,
        isDarkTheme: isDarkTheme,
      ),
    );
  }
}

class _GoalQuoteCarousel extends StatefulWidget {
  final ImpiloGoal activeGoal;
  final bool isDarkTheme;

  const _GoalQuoteCarousel({
    required this.activeGoal,
    required this.isDarkTheme,
  });

  @override
  State<_GoalQuoteCarousel> createState() => _GoalQuoteCarouselState();
}

class _GoalQuoteCarouselState extends State<_GoalQuoteCarousel> {
  static const Color deepTeal = Color(0xFF0A7A75);
  static const Color turquoise = Color(0xFF0DBFB0);
  static const Color darkTeal = Color(0xFF061A19);

  late final PageController _pageController;
  Timer? _quoteTimer;
  int _currentIndex = 0;

  Color get _textColor =>
      widget.isDarkTheme ? const Color(0xFFE9FFFC) : darkTeal;

  Color get _subTextColor =>
      widget.isDarkTheme ? Colors.white.withOpacity(0.68) : darkTeal.withOpacity(0.66);

  List<_GoalQuote> get _quotes {
    return [
      _GoalQuote(
        title: 'Small steps',
        body: 'Small steps still count. Keep moving toward your goal.',
        icon: Icons.directions_walk_rounded,
      ),
      _GoalQuote(
        title: 'Active goal',
        body:
            'Your active goal is ${widget.activeGoal.title}. Keep it simple today.',
        icon: Icons.flag_rounded,
      ),
      _GoalQuote(
        title: 'Support need',
        body:
            'Your need today is ${widget.activeGoal.need.toLowerCase()}. Let that shape your pace.',
        icon: Icons.favorite_rounded,
      ),
      _GoalQuote(
        title: 'Repeatable progress',
        body:
            'Progress becomes easier when your actions are small and repeatable.',
        icon: Icons.repeat_rounded,
      ),
    ];
  }

  @override
  void initState() {
    super.initState();

    _pageController = PageController();

    _quoteTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted || !_pageController.hasClients) return;

      final nextIndex = (_currentIndex + 1) % _quotes.length;

      _pageController.animateToPage(
        nextIndex,
        duration: const Duration(milliseconds: 550),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void didUpdateWidget(covariant _GoalQuoteCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.activeGoal.id != widget.activeGoal.id) {
      _currentIndex = 0;

      if (_pageController.hasClients) {
        _pageController.jumpToPage(0);
      }
    }
  }

  @override
  void dispose() {
    _quoteTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quotes = _quotes;

    return Container(
      height: 145,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: widget.isDarkTheme
                ? Colors.black.withOpacity(0.20)
                : deepTeal.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: widget.isDarkTheme
                        ? const [
                            Color(0xFF0B2624),
                            Color(0xFF123C38),
                            Color(0xFF0A2F2B),
                          ]
                        : const [
                            Colors.white,
                            Color(0xFFE9FFFC),
                            Color(0xFFD6FBF7),
                          ],
                  ),
                ),
              ),
            ),
            Positioned(
              right: -25,
              top: -28,
              child: Container(
                width: 105,
                height: 105,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: turquoise.withOpacity(widget.isDarkTheme ? 0.18 : 0.12),
                ),
              ),
            ),
            Positioned(
              right: 34,
              bottom: -32,
              child: Container(
                width: 92,
                height: 92,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: deepTeal.withOpacity(widget.isDarkTheme ? 0.14 : 0.06),
                    width: 1.1,
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: CustomPaint(
                painter: _QuotePatternPainter(isDarkTheme: widget.isDarkTheme),
              ),
            ),
            Positioned(
              right: 14,
              top: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: turquoise.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: turquoise.withOpacity(0.20),
                  ),
                ),
                child: const Text(
                  'Daily Quote',
                  style: TextStyle(
                    color: turquoise,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            PageView.builder(
              controller: _pageController,
              itemCount: quotes.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                final quote = quotes[index];

                return Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              deepTeal,
                              turquoise,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: turquoise.withOpacity(0.24),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Icon(
                          quote.icon,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 58),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                quote.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: _textColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                  height: 1.1,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                quote.body,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: _subTextColor,
                                  fontSize: 12.1,
                                  fontWeight: FontWeight.w600,
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Positioned(
              left: 84,
              bottom: 12,
              child: Row(
                children: List.generate(quotes.length, (index) {
                  final bool isSelected = _currentIndex == index;

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 240),
                    width: isSelected ? 18 : 6,
                    height: 6,
                    margin: const EdgeInsets.only(right: 6),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? turquoise
                          : turquoise.withOpacity(0.26),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoalQuote {
  final String title;
  final String body;
  final IconData icon;

  const _GoalQuote({
    required this.title,
    required this.body,
    required this.icon,
  });
}

class _QuotePatternPainter extends CustomPainter {
  final bool isDarkTheme;

  const _QuotePatternPainter({
    required this.isDarkTheme,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = const Color(0xFF0DBFB0).withOpacity(isDarkTheme ? 0.10 : 0.045);

    final firstPath = Path()
      ..moveTo(size.width * 0.12, -10)
      ..cubicTo(
        size.width * 0.18,
        size.height * 0.28,
        size.width * 0.04,
        size.height * 0.48,
        size.width * 0.18,
        size.height + 10,
      );

    final secondPath = Path()
      ..moveTo(size.width * 0.56, -8)
      ..cubicTo(
        size.width * 0.46,
        size.height * 0.34,
        size.width * 0.74,
        size.height * 0.52,
        size.width * 0.63,
        size.height + 12,
      );

    canvas.drawPath(firstPath, linePaint);
    canvas.drawPath(secondPath, linePaint);

    final dotPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFF0DBFB0).withOpacity(isDarkTheme ? 0.16 : 0.10);

    canvas.drawCircle(
      Offset(size.width * 0.82, size.height * 0.72),
      4,
      dotPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.88, size.height * 0.78),
      2.8,
      dotPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.78, size.height * 0.82),
      2.2,
      dotPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _QuotePatternPainter oldDelegate) {
    return oldDelegate.isDarkTheme != isDarkTheme;
  }
}

class _ChatPage extends StatelessWidget {
  final String userName;
  final String coachStyle;
  final ImpiloGoal activeGoal;
  final bool isDarkTheme;

  const _ChatPage({
    required this.userName,
    required this.coachStyle,
    required this.activeGoal,
    required this.isDarkTheme,
  });

  @override
  Widget build(BuildContext context) {
    return _PlaceholderPage(
      icon: Icons.chat_bubble_rounded,
      title: 'Chat',
      subtitle: 'Your brother can connect the OpenAI API here.',
      cardTitle: 'AI Context Ready',
      cardBody:
          '$userName, your chat can receive this active goal: ${activeGoal.title}. Coach style: $coachStyle.',
      isDarkTheme: isDarkTheme,
    );
  }
}

class _PlaceholderPage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String cardTitle;
  final String cardBody;
  final bool isDarkTheme;

  const _PlaceholderPage({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.cardTitle,
    required this.cardBody,
    required this.isDarkTheme,
  });

  static const Color deepTeal = Color(0xFF0A7A75);
  static const Color turquoise = Color(0xFF0DBFB0);
  static const Color darkTeal = Color(0xFF061A19);

  Color get _textColor =>
      isDarkTheme ? const Color(0xFFE9FFFC) : darkTeal;

  Color get _subTextColor =>
      isDarkTheme ? Colors.white.withOpacity(0.66) : darkTeal.withOpacity(0.58);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 130),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  deepTeal,
                  turquoise,
                ],
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 34,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: TextStyle(
              color: _textColor,
              fontSize: 33,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: TextStyle(
              color: _subTextColor,
              fontSize: 14.5,
              fontWeight: FontWeight.w500,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 26),
          _PremiumCard(
            icon: icon,
            title: cardTitle,
            body: cardBody,
            badge: 'Active',
            isDarkTheme: isDarkTheme,
          ),
        ],
      ),
    );
  }
}

class _PremiumCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  final String badge;
  final bool accent;
  final bool isDarkTheme;

  const _PremiumCard({
    required this.icon,
    required this.title,
    required this.body,
    required this.badge,
    required this.isDarkTheme,
    this.accent = false,
  });

  static const Color turquoise = Color(0xFF0DBFB0);
  static const Color darkTeal = Color(0xFF061A19);

  Color get _cardColor {
    if (isDarkTheme) {
      return accent
          ? turquoise.withOpacity(0.15)
          : const Color(0xFF0B2624);
    }

    return accent ? turquoise.withOpacity(0.10) : Colors.white.withOpacity(0.88);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: turquoise.withOpacity(accent ? 0.22 : 0.14),
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
          const SizedBox(height: 12),
          Text(
            body,
            style: TextStyle(
              color: isDarkTheme
                  ? Colors.white.withOpacity(0.68)
                  : darkTeal.withOpacity(0.65),
              fontSize: 12.8,
              fontWeight: FontWeight.w600,
              height: 1.42,
            ),
          ),
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
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: turquoise.withOpacity(isDarkTheme ? 0.18 : 0.13),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.insights_rounded,
            color: deepTeal,
            size: 20,
          ),
        ),
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
            color: turquoise.withOpacity(0.12),
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

class _QuickAccessCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isDarkTheme;
  final VoidCallback onTap;

  const _QuickAccessCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isDarkTheme,
    required this.onTap,
  });

  static const Color deepTeal = Color(0xFF0A7A75);
  static const Color turquoise = Color(0xFF0DBFB0);
  static const Color darkTeal = Color(0xFF061A19);

  @override
  Widget build(BuildContext context) {
    final textColor = isDarkTheme ? const Color(0xFFE9FFFC) : darkTeal;
    final subTextColor =
        isDarkTheme ? Colors.white.withOpacity(0.58) : darkTeal.withOpacity(0.50);

    return Material(
      color: isDarkTheme
          ? const Color(0xFF0B2624)
          : Colors.white.withOpacity(0.88),
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(11),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: turquoise.withOpacity(isDarkTheme ? 0.22 : 0.14),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 37,
                height: 37,
                decoration: BoxDecoration(
                  color: turquoise.withOpacity(isDarkTheme ? 0.18 : 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: deepTeal,
                  size: 20,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 14.2,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: subTextColor,
                        fontSize: 10.6,
                        fontWeight: FontWeight.w600,
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

class _CurvedBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final bool isDarkTheme;
  final ValueChanged<int> onItemSelected;

  const _CurvedBottomNavBar({
    required this.selectedIndex,
    required this.isDarkTheme,
    required this.onItemSelected,
  });

  static const Color deepTeal = Color(0xFF0A7A75);
  static const Color turquoise = Color(0xFF0DBFB0);
  static const Color darkTeal = Color(0xFF061A19);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 94,
      elevation: 0,
      color: Colors.transparent,
      notchMargin: 8,
      shape: const CircularNotchedRectangle(),
      child: Container(
        margin: const EdgeInsets.fromLTRB(14, 0, 14, 12),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: isDarkTheme
              ? const Color(0xFF0B2624).withOpacity(0.98)
              : Colors.white.withOpacity(0.98),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: isDarkTheme
                  ? Colors.black.withOpacity(0.24)
                  : deepTeal.withOpacity(0.12),
              blurRadius: 26,
              offset: const Offset(0, 12),
            ),
          ],
          border: Border.all(
            color: turquoise.withOpacity(isDarkTheme ? 0.24 : 0.12),
          ),
        ),
        child: Row(
          children: [
            _NavItem(
              icon: Icons.home_rounded,
              label: 'Home',
              isSelected: selectedIndex == 0,
              isDarkTheme: isDarkTheme,
              onTap: () => onItemSelected(0),
            ),
            _NavItem(
              icon: Icons.task_alt_rounded,
              label: 'Tasks',
              isSelected: selectedIndex == 1,
              isDarkTheme: isDarkTheme,
              onTap: () => onItemSelected(1),
            ),
            const SizedBox(width: 64),
            _NavItem(
              icon: Icons.flag_rounded,
              label: 'Goals',
              isSelected: selectedIndex == 3,
              isDarkTheme: isDarkTheme,
              onTap: () => onItemSelected(3),
            ),
            _NavItem(
              icon: Icons.person_rounded,
              label: 'Profile',
              isSelected: selectedIndex == 4,
              isDarkTheme: isDarkTheme,
              onTap: () => onItemSelected(4),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final bool isDarkTheme;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.isDarkTheme,
    required this.onTap,
  });

  static const Color deepTeal = Color(0xFF0A7A75);
  static const Color darkTeal = Color(0xFF061A19);

  @override
  Widget build(BuildContext context) {
    final inactiveColor = isDarkTheme
        ? Colors.white.withOpacity(0.34)
        : darkTeal.withOpacity(0.32);

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: SizedBox(
          height: 58,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? deepTeal : inactiveColor,
                size: 22,
              ),
              const SizedBox(height: 2),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isSelected ? deepTeal : inactiveColor,
                    fontSize: 9.5,
                    fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardPatternPainter extends CustomPainter {
  final bool isDarkTheme;

  const _DashboardPatternPainter({
    required this.isDarkTheme,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1
      ..color = const Color(0xFF0DBFB0).withOpacity(
        isDarkTheme ? 0.08 : 0.08,
      );

    canvas.drawCircle(
      Offset(size.width * 0.96, size.height * 0.06),
      size.width * 0.50,
      ringPaint,
    );

    final wavePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFF0DBFB0).withOpacity(
        isDarkTheme ? 0.035 : 0.045,
      );

    final wave = Path()
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
  bool shouldRepaint(covariant _DashboardPatternPainter oldDelegate) {
    return oldDelegate.isDarkTheme != isDarkTheme;
  }
}