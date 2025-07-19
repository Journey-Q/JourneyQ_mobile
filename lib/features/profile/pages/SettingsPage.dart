import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:journeyq/data/repositories/auth_repositories/auth_repository.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),

            // Account Section
            _buildSettingItem(
              Icons.person_outline,
              'Account Settings',
              'Manage your profile and personal information',
              onTap: () => _navigateToPage('Account Settings'),
            ),

            _buildSettingItem(
              Icons.lock_outline,
              'Privacy & Safety',
              'Control who can see your content and interact with you',
              onTap: () => _navigateToPage('Privacy & Safety'),
            ),

            _buildSettingItem(
              Icons.notifications_outlined,
              'Notifications',
              'Manage your notification preferences',
              onTap: () => _navigateToPage('Notifications'),
            ),

            _buildSettingItem(
              Icons.bookmark_outline,
              'Saved Posts',
              'View your saved content',
              onTap: () => _navigateToPage('Saved Posts'),
            ),

            _buildSettingItem(
              Icons.download_outlined,
              'Download Data',
              'Download a copy of your information',
              onTap: () => _navigateToPage('Download Data'),
            ),

            _buildSettingItem(
              Icons.help_outline,
              'Help & Support',
              'Get help and contact support',
              onTap: () => _navigateToPage('Help & Support'),
            ),

            _buildSettingItem(
              Icons.info_outline,
              'About JourneyQ',
              'App version and legal information',
              onTap: () => _navigateToPage('About JourneyQ'),
            ),

            const SizedBox(height: 20),

            // Logout Section
            ListTile(
              leading: const Icon(
                Icons.logout_outlined,
                color: Colors.red,
                size: 24,
              ),
              title: const Text(
                'Log Out',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
                size: 16,
              ),
              onTap: () => _showLogoutDialog(),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(
    IconData icon,
    String title,
    String subtitle, {
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.black, size: 24),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: Colors.grey, fontSize: 13),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: Colors.grey,
        size: 16,
      ),
      onTap: onTap,
    );
  }

  void _navigateToPage(String pageName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening $pageName...'),
        backgroundColor: Colors.grey[800],
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          'Log Out',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        content: const Text(
          'Are you sure you want to log out of your account?',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Go back to profile
              await AuthRepository.clearTokens();
            },
            child: const Text(
              'Log Out',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
