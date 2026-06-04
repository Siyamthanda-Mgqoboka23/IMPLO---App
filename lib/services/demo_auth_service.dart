import '../models/impilo_user_account.dart';

class DemoAuthService {
  DemoAuthService._privateConstructor();

  static final DemoAuthService instance = DemoAuthService._privateConstructor();

  final List<ImpiloUserAccount> _accounts = [];
  ImpiloUserAccount? _currentUser;

  ImpiloUserAccount? get currentUser => _currentUser;

  List<ImpiloUserAccount> get accounts => List.unmodifiable(_accounts);

  bool emailExists(String email) {
    final cleanedEmail = email.trim().toLowerCase();

    return _accounts.any(
      (account) => account.email.trim().toLowerCase() == cleanedEmail,
    );
  }

  ImpiloUserAccount createAccount({
    required String displayName,
    required String username,
    required String email,
    required String password,
  }) {
    final cleanedEmail = email.trim().toLowerCase();
    final cleanedUsername = username.trim().replaceAll(' ', '_').toLowerCase();

    if (emailExists(cleanedEmail)) {
      throw Exception('An account with this email already exists.');
    }

    final account = ImpiloUserAccount(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      displayName: displayName.trim(),
      username: cleanedUsername,
      email: cleanedEmail,
      password: password.trim(),
      isEmailVerified: false,
      verificationCode: _generateVerificationCode(),
      coachStyle: 'Discipline Coach',
      coachTone: 'Balanced',
      isDarkTheme: false,
      createdAt: DateTime.now(),
    );

    _accounts.add(account);
    _currentUser = account;

    return account;
  }

  ImpiloUserAccount login({
    required String email,
    required String password,
  }) {
    final cleanedEmail = email.trim().toLowerCase();
    final cleanedPassword = password.trim();

    final account = _accounts.firstWhere(
      (item) =>
          item.email.trim().toLowerCase() == cleanedEmail &&
          item.password == cleanedPassword,
      orElse: () {
        throw Exception('Invalid email or password.');
      },
    );

    if (!account.isEmailVerified) {
      _currentUser = account;
      throw Exception('Please verify your email before logging in.');
    }

    _currentUser = account;
    return account;
  }

  bool verifyEmail({
    required String email,
    required String code,
  }) {
    final cleanedEmail = email.trim().toLowerCase();
    final cleanedCode = code.trim();

    final account = _accounts.firstWhere(
      (item) => item.email.trim().toLowerCase() == cleanedEmail,
      orElse: () {
        throw Exception('Account not found.');
      },
    );

    if (account.verificationCode != cleanedCode) {
      throw Exception('Invalid verification code.');
    }

    account.isEmailVerified = true;
    _currentUser = account;

    return true;
  }

  String resendVerificationCode(String email) {
    final cleanedEmail = email.trim().toLowerCase();

    final account = _accounts.firstWhere(
      (item) => item.email.trim().toLowerCase() == cleanedEmail,
      orElse: () {
        throw Exception('Account not found.');
      },
    );

    account.verificationCode = _generateVerificationCode();
    return account.verificationCode;
  }

  void updateCurrentUser(ImpiloUserAccount updatedUser) {
    final index = _accounts.indexWhere((item) => item.id == updatedUser.id);

    if (index != -1) {
      _accounts[index] = updatedUser;
      _currentUser = updatedUser;
    }
  }

  void logout() {
    _currentUser = null;
  }

  String _generateVerificationCode() {
    final number = DateTime.now().millisecondsSinceEpoch % 900000;
    return (number + 100000).toString();
  }
}