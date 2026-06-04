class ImpiloGoal {
  final String id;
  final String title;
  final String category;
  final String reason;
  final String timeframe;
  final String mood;
  final String need;
  final String coachStyle;
  final DateTime createdAt;

  bool isTodayFocus;
  bool firstStepDone;
  bool routineStarted;
  bool reflectionAdded;

  ImpiloGoal({
    required this.id,
    required this.title,
    required this.category,
    required this.reason,
    required this.timeframe,
    required this.mood,
    required this.need,
    required this.coachStyle,
    required this.createdAt,
    this.isTodayFocus = false,
    this.firstStepDone = false,
    this.routineStarted = false,
    this.reflectionAdded = false,
  });

  int get completedMilestones {
    int count = 0;

    if (firstStepDone) count++;
    if (routineStarted) count++;
    if (reflectionAdded) count++;

    return count;
  }

  double get progress {
    return completedMilestones / 3;
  }

  String get progressLabel {
    if (completedMilestones == 0) return 'Not started';
    if (completedMilestones == 1) return 'Started';
    if (completedMilestones == 2) return 'Building';
    return 'On track';
  }

  String get healthText {
    if (completedMilestones == 0) {
      return 'This goal is created, but it needs a first action.';
    }

    if (completedMilestones == 1) {
      return 'Good start. You have taken the first step.';
    }

    if (completedMilestones == 2) {
      return 'Nice progress. You are building rhythm.';
    }

    return 'Strong progress. You have action, rhythm, and reflection.';
  }
}