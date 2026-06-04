import 'package:flutter/material.dart';

import '../models/impilo_goal.dart';
import '../models/impilo_user_account.dart';
import '../services/demo_auth_service.dart';
import 'auth_welcome_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String userName;
  final String coachStyle;
  final List<ImpiloGoal> goals;
  final ImpiloGoal activeGoal;
  final bool isDarkTheme;
  final ValueChanged<bool> onThemeChanged;

  const ProfileScreen({
    super.key,
    required this.userName,
    required this.coachStyle,
    required this.goals,
    required this.activeGoal,
    required this.isDarkTheme,
    required this.onThemeChanged,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const Color deepTeal = Color(0xFF0A7A75);
  static const Color turquoise = Color(0xFF0DBFB0);
  static const Color softMint = Color(0xFFE0FDF9);
  static const Color darkTeal = Color(0xFF061A19);

  late String _displayName;
  late String _username;
  late String _email;
  late String _password;
  late String _coachTone;

  bool _dailyReminders = true;
  bool _wellnessReminders = true;
  bool _privacyMode = true;

  ImpiloUserAccount? get _account => DemoAuthService.instance.currentUser;

  bool get _hasAccount => _account != null;

  Color get _backgroundColor {
    return widget.isDarkTheme ? const Color(0xFF031210) : softMint;
  }

  Color get _cardColor {
    return widget.isDarkTheme
        ? const Color(0xFF0B2624)
        : Colors.white.withOpacity(0.92);
  }

  Color get _textColor {
    return widget.isDarkTheme ? const Color(0xFFE9FFFC) : darkTeal;
  }

  Color get _subTextColor {
    return widget.isDarkTheme
        ? Colors.white.withOpacity(0.65)
        : darkTeal.withOpacity(0.58);
  }

  @override
  void initState() {
    super.initState();

    final account = _account;

    _displayName = account?.displayName.trim().isNotEmpty == true
        ? account!.displayName
        : widget.userName;

    _username = account?.username.trim().isNotEmpty == true
        ? account!.username
        : widget.userName.toLowerCase().replaceAll(' ', '_');

    _email = account?.email.trim().isNotEmpty == true
        ? account!.email
        : 'demo@impilo.app';

    _password = account?.password ?? 'password123';

    _coachTone = account?.coachTone.trim().isNotEmpty == true
        ? account!.coachTone
        : 'Balanced';
  }

  void _saveAccountChanges() {
    final account = _account;

    if (account == null) return;

    final updatedAccount = account.copyWith(
      displayName: _displayName,
      username: _username,
      email: _email,
      password: _password,
      coachTone: _coachTone,
      isDarkTheme: widget.isDarkTheme,
    );

    DemoAuthService.instance.updateCurrentUser(updatedAccount);
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
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  Future<void> _editField({
    required String title,
    required String initialValue,
    required ValueChanged<String> onSaved,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) async {
    final controller = TextEditingController(text: initialValue);

    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor:
              widget.isDarkTheme ? const Color(0xFF0B2624) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: Text(
            title,
            style: TextStyle(
              color: widget.isDarkTheme ? Colors.white : darkTeal,
              fontWeight: FontWeight.w900,
            ),
          ),
          content: TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            cursorColor: turquoise,
            style: TextStyle(
              color: widget.isDarkTheme ? Colors.white : darkTeal,
              fontWeight: FontWeight.w700,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: widget.isDarkTheme
                  ? const Color(0xFF123C38)
                  : const Color(0xFFF6FFFD),
              hintText: 'Enter $title',
              hintStyle: TextStyle(
                color: widget.isDarkTheme
                    ? Colors.white.withOpacity(0.42)
                    : darkTeal.withOpacity(0.35),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: turquoise.withOpacity(0.22),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: turquoise,
                  width: 1.4,
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: widget.isDarkTheme
                      ? Colors.white.withOpacity(0.65)
                      : darkTeal.withOpacity(0.60),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, controller.text.trim()),
              style: ElevatedButton.styleFrom(
                backgroundColor: deepTeal,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Save',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (result == null || result.trim().isEmpty) return;

    setState(() {
      onSaved(result.trim());
    });

    _saveAccountChanges();
    _showMessage('$title updated.');
  }

  void _openSettingsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, modalSetState) {
            final bool dark = widget.isDarkTheme;

            return DraggableScrollableSheet(
              initialChildSize: 0.72,
              minChildSize: 0.45,
              maxChildSize: 0.92,
              expand: false,
              builder: (context, scrollController) {
                return Container(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 26),
                  decoration: BoxDecoration(
                    color: dark
                        ? const Color(0xFF071C1B)
                        : const Color(0xFFF5FFFD),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                    border: Border.all(
                      color: turquoise.withOpacity(0.20),
                    ),
                  ),
                  child: SafeArea(
                    top: false,
                    child: SingleChildScrollView(
                      controller: scrollController,
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
                          const SizedBox(height: 18),
                          Text(
                            'Settings',
                            style: TextStyle(
                              color: dark ? Colors.white : darkTeal,
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Manage appearance, reminders, and privacy.',
                            style: TextStyle(
                              color: dark
                                  ? Colors.white.withOpacity(0.65)
                                  : darkTeal.withOpacity(0.58),
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 18),
                          _SettingsSwitchTile(
                            icon: dark
                                ? Icons.dark_mode_rounded
                                : Icons.light_mode_rounded,
                            title: 'Dark theme',
                            subtitle: 'Use a calm dark teal theme.',
                            value: widget.isDarkTheme,
                            isDarkTheme: dark,
                            onChanged: (value) {
                              widget.onThemeChanged(value);

                              final account = _account;
                              if (account != null) {
                                DemoAuthService.instance.updateCurrentUser(
                                  account.copyWith(isDarkTheme: value),
                                );
                              }

                              modalSetState(() {});
                              setState(() {});
                            },
                          ),
                          const SizedBox(height: 12),
                          _SettingsSwitchTile(
                            icon: Icons.notifications_active_rounded,
                            title: 'Daily reminders',
                            subtitle: 'Allow Impilo to remind you to check in.',
                            value: _dailyReminders,
                            isDarkTheme: dark,
                            onChanged: (value) {
                              modalSetState(() {
                                _dailyReminders = value;
                              });

                              setState(() {
                                _dailyReminders = value;
                              });
                            },
                          ),
                          const SizedBox(height: 12),
                          _SettingsSwitchTile(
                            icon: Icons.favorite_rounded,
                            title: 'Wellness reminders',
                            subtitle: 'Receive gentle wellbeing reminders.',
                            value: _wellnessReminders,
                            isDarkTheme: dark,
                            onChanged: (value) {
                              modalSetState(() {
                                _wellnessReminders = value;
                              });

                              setState(() {
                                _wellnessReminders = value;
                              });
                            },
                          ),
                          const SizedBox(height: 12),
                          _SettingsSwitchTile(
                            icon: Icons.privacy_tip_rounded,
                            title: 'Privacy mode',
                            subtitle: 'Keep sensitive information more protected.',
                            value: _privacyMode,
                            isDarkTheme: dark,
                            onChanged: (value) {
                              modalSetState(() {
                                _privacyMode = value;
                              });

                              setState(() {
                                _privacyMode = value;
                              });
                            },
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void _signOut() {
    DemoAuthService.instance.logout();

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => const AuthWelcomeScreen(),
      ),
      (route) => false,
    );
  }

  void _confirmSignOut() {
    showDialog(
      context: context,
      builder: (context) {
        final bool dark = widget.isDarkTheme;

        return AlertDialog(
          backgroundColor: dark ? const Color(0xFF0B2624) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: Text(
            'Sign out',
            style: TextStyle(
              color: dark ? Colors.white : darkTeal,
              fontWeight: FontWeight.w900,
            ),
          ),
          content: Text(
            'Are you sure you want to sign out of Impilo?',
            style: TextStyle(
              color: dark
                  ? Colors.white.withOpacity(0.68)
                  : darkTeal.withOpacity(0.62),
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: dark
                      ? Colors.white.withOpacity(0.65)
                      : darkTeal.withOpacity(0.60),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _signOut();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: deepTeal,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Sign out',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: Stack(
        children: [
          _buildBackground(),
          _buildPatternOverlay(),
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
                  _buildHeroCard(),
                  const SizedBox(height: 22),
                  _buildSectionTitle(
                    'Account',
                    _hasAccount
                        ? 'Details from the account you created.'
                        : 'Demo details are being shown because no account is active.',
                  ),
                  const SizedBox(height: 12),
                  _buildAccountCard(),
                  const SizedBox(height: 18),
                  _buildSectionTitle(
                    'Coach Preferences',
                    'Control how Impilo speaks to you.',
                  ),
                  const SizedBox(height: 12),
                  _buildCoachCard(),
                  const SizedBox(height: 18),
                  _buildSectionTitle(
                    'Security & Privacy',
                    'Manage account safety and privacy settings.',
                  ),
                  const SizedBox(height: 12),
                  _buildSecurityCard(),
                  const SizedBox(height: 18),
                  _buildSectionTitle(
                    'Session',
                    'Control your current session.',
                  ),
                  const SizedBox(height: 12),
                  _buildSessionCard(),
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
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Profile',
                style: TextStyle(
                  color: _textColor,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  height: 1.05,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Manage your account and preferences.',
                style: TextStyle(
                  color: _subTextColor,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: _openSettingsSheet,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: turquoise.withOpacity(0.13),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: turquoise.withOpacity(0.20),
              ),
            ),
            child: const Icon(
              Icons.settings_rounded,
              color: deepTeal,
              size: 23,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF075D58),
            Color(0xFF0A7A75),
            Color(0xFF0DBFB0),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: turquoise.withOpacity(0.24),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.16),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withOpacity(0.18),
              ),
            ),
            child: Center(
              child: Text(
                _displayName.trim().isEmpty
                    ? 'U'
                    : _displayName.trim().substring(0, 1).toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '@$_username',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.82),
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _HeroChip(
                      text: _hasAccount ? 'Verified account' : 'Demo mode',
                    ),
                    _HeroChip(text: _coachTone),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountCard() {
    return _ProfileCard(
      isDarkTheme: widget.isDarkTheme,
      child: Column(
        children: [
          _ProfileActionTile(
            icon: Icons.person_rounded,
            title: 'Display name',
            value: _displayName,
            isDarkTheme: widget.isDarkTheme,
            onTap: () => _editField(
              title: 'Display name',
              initialValue: _displayName,
              onSaved: (value) => _displayName = value,
            ),
          ),
          _divider(),
          _ProfileActionTile(
            icon: Icons.alternate_email_rounded,
            title: 'Username',
            value: '@$_username',
            isDarkTheme: widget.isDarkTheme,
            onTap: () => _editField(
              title: 'Username',
              initialValue: _username,
              onSaved: (value) =>
                  _username = value.replaceAll(' ', '_').toLowerCase(),
            ),
          ),
          _divider(),
          _ProfileActionTile(
            icon: Icons.email_rounded,
            title: 'Email',
            value: _email,
            isDarkTheme: widget.isDarkTheme,
            onTap: () => _editField(
              title: 'Email',
              initialValue: _email,
              keyboardType: TextInputType.emailAddress,
              onSaved: (value) => _email = value.toLowerCase(),
            ),
          ),
          _divider(),
          _ProfileActionTile(
            icon: Icons.lock_rounded,
            title: 'Password',
            value: '••••••••',
            isDarkTheme: widget.isDarkTheme,
            onTap: () => _editField(
              title: 'Password',
              initialValue: _password,
              obscureText: true,
              onSaved: (value) => _password = value,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoachCard() {
    final tones = [
      'Gentle',
      'Balanced',
      'Direct',
      'Motivational',
      'Strict',
    ];

    return _ProfileCard(
      isDarkTheme: widget.isDarkTheme,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Coach tone',
            style: TextStyle(
              color: _textColor,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Choose how Impilo should speak to you during support and guidance.',
            style: TextStyle(
              color: _subTextColor,
              fontSize: 12.2,
              fontWeight: FontWeight.w600,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tones.map((tone) {
              final selected = _coachTone == tone;

              return ChoiceChip(
                label: Text(
                  tone,
                  style: TextStyle(
                    color: selected ? Colors.white : _textColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 12.2,
                  ),
                ),
                selected: selected,
                onSelected: (_) {
                  setState(() {
                    _coachTone = tone;
                  });

                  _saveAccountChanges();
                  _showMessage('Coach tone changed to $tone.');
                },
                selectedColor: deepTeal,
                backgroundColor: widget.isDarkTheme
                    ? const Color(0xFF123C38)
                    : const Color(0xFFF3FCFB),
                side: BorderSide(
                  color: selected ? deepTeal : turquoise.withOpacity(0.20),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
                showCheckmark: false,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityCard() {
    return _ProfileCard(
      isDarkTheme: widget.isDarkTheme,
      child: Column(
        children: [
          _ProfileSwitchTile(
            icon: Icons.privacy_tip_rounded,
            title: 'Privacy mode',
            subtitle: 'Keep profile information more private.',
            value: _privacyMode,
            isDarkTheme: widget.isDarkTheme,
            onChanged: (value) {
              setState(() => _privacyMode = value);
            },
          ),
          _divider(),
          _ProfileSwitchTile(
            icon: Icons.notifications_active_rounded,
            title: 'Daily reminders',
            subtitle: 'Receive helpful reminders from Impilo.',
            value: _dailyReminders,
            isDarkTheme: widget.isDarkTheme,
            onChanged: (value) {
              setState(() => _dailyReminders = value);
            },
          ),
          _divider(),
          _ProfileSwitchTile(
            icon: Icons.favorite_rounded,
            title: 'Wellness reminders',
            subtitle: 'Receive gentle wellbeing nudges.',
            value: _wellnessReminders,
            isDarkTheme: widget.isDarkTheme,
            onChanged: (value) {
              setState(() => _wellnessReminders = value);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSessionCard() {
    return _ProfileCard(
      isDarkTheme: widget.isDarkTheme,
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton.icon(
          onPressed: _confirmSignOut,
          icon: const Icon(Icons.logout_rounded),
          label: const Text(
            'Sign Out',
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
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: _textColor,
            fontSize: 19,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            color: _subTextColor,
            fontSize: 12.3,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _divider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      height: 1,
      color: widget.isDarkTheme
          ? Colors.white.withOpacity(0.08)
          : darkTeal.withOpacity(0.08),
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
                    Color(0xFFD2FCF8),
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
          painter: _ProfilePatternPainter(isDarkTheme: widget.isDarkTheme),
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final Widget child;
  final bool isDarkTheme;

  const _ProfileCard({
    required this.child,
    required this.isDarkTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDarkTheme
            ? const Color(0xFF0B2624)
            : Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: const Color(0xFF0DBFB0).withOpacity(0.18),
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkTheme
                ? Colors.black.withOpacity(0.22)
                : const Color(0xFF0A7A75).withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _ProfileActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final VoidCallback onTap;
  final bool isDarkTheme;

  const _ProfileActionTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.onTap,
    required this.isDarkTheme,
  });

  @override
  Widget build(BuildContext context) {
    final textColor =
        isDarkTheme ? const Color(0xFFE9FFFC) : const Color(0xFF061A19);

    final subTextColor = isDarkTheme
        ? Colors.white.withOpacity(0.65)
        : const Color(0xFF061A19).withOpacity(0.58);

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Row(
        children: [
          _SmallIcon(
            icon: icon,
            isDarkTheme: isDarkTheme,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: subTextColor,
                    fontSize: 12.1,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios_rounded,
            color: subTextColor.withOpacity(0.72),
            size: 15,
          ),
        ],
      ),
    );
  }
}

class _ProfileSwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool isDarkTheme;

  const _ProfileSwitchTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    required this.isDarkTheme,
  });

  @override
  Widget build(BuildContext context) {
    final textColor =
        isDarkTheme ? const Color(0xFFE9FFFC) : const Color(0xFF061A19);

    final subTextColor = isDarkTheme
        ? Colors.white.withOpacity(0.65)
        : const Color(0xFF061A19).withOpacity(0.58);

    return Row(
      children: [
        _SmallIcon(
          icon: icon,
          isDarkTheme: isDarkTheme,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: textColor,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: subTextColor,
                  fontSize: 12.1,
                  fontWeight: FontWeight.w600,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          activeColor: const Color(0xFF0DBFB0),
          activeTrackColor: const Color(0xFF0DBFB0).withOpacity(0.28),
          inactiveThumbColor: const Color(0xFF0A7A75).withOpacity(0.72),
          inactiveTrackColor: const Color(0xFF0A7A75).withOpacity(0.12),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _SettingsSwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool isDarkTheme;

  const _SettingsSwitchTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    required this.isDarkTheme,
  });

  @override
  Widget build(BuildContext context) {
    final textColor =
        isDarkTheme ? const Color(0xFFE9FFFC) : const Color(0xFF061A19);

    final subTextColor = isDarkTheme
        ? Colors.white.withOpacity(0.65)
        : const Color(0xFF061A19).withOpacity(0.58);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDarkTheme
            ? const Color(0xFF0B2624)
            : Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF0DBFB0).withOpacity(0.18),
        ),
      ),
      child: Row(
        children: [
          _SmallIcon(
            icon: icon,
            isDarkTheme: isDarkTheme,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: subTextColor,
                    fontSize: 11.8,
                    fontWeight: FontWeight.w600,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            activeColor: const Color(0xFF0DBFB0),
            activeTrackColor: const Color(0xFF0DBFB0).withOpacity(0.28),
            inactiveThumbColor: const Color(0xFF0A7A75).withOpacity(0.72),
            inactiveTrackColor: const Color(0xFF0A7A75).withOpacity(0.12),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _SmallIcon extends StatelessWidget {
  final IconData icon;
  final bool isDarkTheme;

  const _SmallIcon({
    required this.icon,
    required this.isDarkTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: const Color(0xFF0DBFB0).withOpacity(0.13),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFF0DBFB0).withOpacity(0.18),
        ),
      ),
      child: Icon(
        icon,
        color: const Color(0xFF0A7A75),
        size: 21,
      ),
    );
  }
}

class _HeroChip extends StatelessWidget {
  final String text;

  const _HeroChip({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: Colors.white.withOpacity(0.18),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white.withOpacity(0.90),
          fontSize: 10.8,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _ProfilePatternPainter extends CustomPainter {
  final bool isDarkTheme;

  const _ProfilePatternPainter({
    required this.isDarkTheme,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = const Color(0xFF0DBFB0).withOpacity(
        isDarkTheme ? 0.08 : 0.07,
      );

    canvas.drawCircle(
      Offset(size.width * 0.96, size.height * 0.10),
      size.width * 0.45,
      paint,
    );

    canvas.drawCircle(
      Offset(size.width * 0.82, size.height * 0.08),
      size.width * 0.24,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}