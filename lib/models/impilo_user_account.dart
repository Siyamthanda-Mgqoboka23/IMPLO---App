class ImpiloUserAccount {
  final String id;
  String displayName;
  String username;
  String email;
  String password;
  bool isEmailVerified;
  String verificationCode;
  String coachStyle;
  String coachTone;
  bool isDarkTheme;
  DateTime createdAt;

  ImpiloUserAccount({
    required this.id,
    required this.displayName,
    required this.username,
    required this.email,
    required this.password,
    required this.isEmailVerified,
    required this.verificationCode,
    required this.coachStyle,
    required this.coachTone,
    required this.isDarkTheme,
    required this.createdAt,
  });

  String get initial {
    if (displayName.trim().isEmpty) return 'U';
    return displayName.trim().substring(0, 1).toUpperCase();
  }

  String get safeUsername {
    if (username.trim().isEmpty) {
      return displayName.toLowerCase().replaceAll(' ', '_');
    }

    return username.trim().replaceAll(' ', '_').toLowerCase();
  }

  ImpiloUserAccount copyWith({
    String? displayName,
    String? username,
    String? email,
    String? password,
    bool? isEmailVerified,
    String? verificationCode,
    String? coachStyle,
    String? coachTone,
    bool? isDarkTheme,
  }) {
    return ImpiloUserAccount(
      id: id,
      displayName: displayName ?? this.displayName,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      verificationCode: verificationCode ?? this.verificationCode,
      coachStyle: coachStyle ?? this.coachStyle,
      coachTone: coachTone ?? this.coachTone,
      isDarkTheme: isDarkTheme ?? this.isDarkTheme,
      createdAt: createdAt,
    );
  }
}