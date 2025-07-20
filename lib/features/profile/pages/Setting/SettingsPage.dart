import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = false;
  bool _accountPrivate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.arrow_back, color: Color(0xFF374151), size: 20),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Color(0xFF1F2937),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Section Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0088cc), Color(0xFF0066aa)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.settings,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Account Settings',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Manage your preferences and privacy',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Privacy & Security Section
              const Text(
                'Privacy & Security',
                style: TextStyle(
                  color: Color(0xFF374151),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              
              // Notifications Toggle
              _buildToggleCard(
                icon: Icons.notifications_outlined,
                iconColor: const Color(0xFF0088cc),
                title: 'Notifications',
                subtitle: 'Receive updates and alerts',
                value: _notificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                  _showNotificationPopup(value);
                },
              ),
              
              const SizedBox(height: 12),
              
              // Account Privacy Toggle
              _buildToggleCard(
                icon: Icons.lock_outline,
                iconColor: const Color(0xFF8B5CF6),
                title: 'Private Account',
                subtitle: 'Control who can see your content',
                value: _accountPrivate,
                onChanged: (value) {
                  setState(() {
                    _accountPrivate = value;
                  });
                  _showPrivacyPopup(value);
                },
              ),
              
              const SizedBox(height: 24),
              
              // Account Management Section
              const Text(
                'Account Management',
                style: TextStyle(
                  color: Color(0xFF374151),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              
              // Change Password
              _buildSettingCard(
                icon: Icons.lock,
                iconColor: const Color(0xFFF59E0B),
                title: 'Change Password',
                subtitle: 'Update your account password',
                onTap: () => context.push('/profile/settings/change-password'),
              ),
              
              const SizedBox(height: 12),
              
              // Points Explanation
              _buildSettingCard(
                icon: Icons.stars,
                iconColor: const Color(0xFF10B981),
                title: 'Points System',
                subtitle: 'Learn how points are earned',
                onTap: () => context.push('/profile/settings/points-explanation'),
              ),
              
              const SizedBox(height: 32),
              
              // Logout Section
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEE2E2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.logout,
                      color: Color(0xFFEF4444),
                      size: 20,
                    ),
                  ),
                  title: const Text(
                    'Log Out',
                    style: TextStyle(
                      color: Color(0xFFEF4444),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: const Text(
                    'Sign out of your account',
                    style: TextStyle(
                      color: Color(0xFF9CA3AF),
                      fontSize: 13,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0xFF9CA3AF),
                    size: 16,
                  ),
                  onTap: () => _showLogoutDialog(),
                ),
              ),
              
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF1F2937),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: Color(0xFF6B7280),
            fontSize: 13,
          ),
        ),
        trailing: Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF0088cc),
          activeTrackColor: const Color(0xFF0088cc).withOpacity(0.3),
          inactiveThumbColor: const Color(0xFF9CA3AF),
          inactiveTrackColor: const Color(0xFFE5E7EB),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
          thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.selected)) {
              return const Color(0xFF0088cc);
            }
            return const Color(0xFF9CA3AF);
          }),
          trackColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.selected)) {
              return const Color(0xFF0088cc).withOpacity(0.3);
            }
            return const Color(0xFFE5E7EB);
          }),
        ),
      ),
    );
  }

  Widget _buildSettingCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF1F2937),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: Color(0xFF6B7280),
            fontSize: 13,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Color(0xFF9CA3AF),
          size: 16,
        ),
        onTap: onTap,
      ),
    );
  }

  void _showNotificationPopup(bool isEnabled) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isEnabled 
                      ? const Color(0xFFDCFCE7) 
                      : const Color(0xFFFEE2E2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isEnabled ? Icons.notifications_active : Icons.notifications_off,
                  color: isEnabled 
                      ? const Color(0xFF10B981) 
                      : const Color(0xFFEF4444),
                  size: 28,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                isEnabled ? 'Notifications Enabled' : 'Notifications Disabled',
                style: const TextStyle(
                  color: Color(0xFF1F2937),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isEnabled 
                    ? 'You will now receive push notifications and updates.'
                    : 'You will no longer receive push notifications.',
                style: const TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0088cc),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Got it',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPrivacyPopup(bool isPrivate) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isPrivate 
                      ? const Color(0xFFF3E8FF) 
                      : const Color(0xFFDCFCE7),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isPrivate ? Icons.lock : Icons.public,
                  color: isPrivate 
                      ? const Color(0xFF8B5CF6) 
                      : const Color(0xFF10B981),
                  size: 28,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Account Privacy Updated',
                style: const TextStyle(
                  color: Color(0xFF1F2937),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isPrivate 
                    ? 'Your account is now private. Only approved followers can see your content.'
                    : 'Your account is now public. Anyone can see your posts and profile.',
                style: const TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0088cc),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Understood',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Color(0xFFFEE2E2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.logout,
                  color: Color(0xFFEF4444),
                  size: 28,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Log Out',
                style: TextStyle(
                  color: Color(0xFF1F2937),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Are you sure you want to log out of your account?',
                style: TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF6B7280),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Logged out successfully'),
                            backgroundColor: const Color(0xFF10B981),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEF4444),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Log Out',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}