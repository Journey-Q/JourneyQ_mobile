import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
          'Settings and activity',
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
            _buildSection('Account', [
              _buildSettingItem(
                Icons.person_outline,
                'Account Center',
                'Manage your connected experiences and account settings across Meta technologies.',
                onTap: () => _navigateToPage('Account Center'),
              ),
              _buildSettingItem(
                Icons.star_outline,
                'Close Friends',
                '',
                onTap: () => _navigateToPage('Close Friends'),
              ),
              _buildSettingItem(
                Icons.bookmark_outline,
                'Saved',
                '',
                onTap: () => _navigateToPage('Saved'),
              ),
              _buildSettingItem(
                Icons.favorite_outline,
                'Favorites',
                '',
                onTap: () => _navigateToPage('Favorites'),
              ),
            ]),

            _buildSection('How you use JourneyQ', [
              _buildSettingItem(
                Icons.lock_outline,
                'Privacy and safety',
                '',
                onTap: () => _navigateToPage('Privacy and safety'),
              ),
              _buildSettingItem(
                Icons.account_box_outlined,
                'Supervision',
                '',
                onTap: () => _navigateToPage('Supervision'),
              ),
              _buildSettingItem(
                Icons.notifications_outlined,
                'Notifications',
                '',
                onTap: () => _navigateToPage('Notifications'),
              ),
              _buildSettingItem(
                Icons.schedule_outlined,
                'Time management',
                '',
                onTap: () => _navigateToPage('Time management'),
              ),
            ]),

            _buildSection('For professionals', [
              _buildSettingItem(
                Icons.business_outlined,
                'Creator tools and controls',
                '',
                onTap: () => _navigateToPage('Creator tools'),
              ),
              _buildSettingItem(
                Icons.insights_outlined,
                'Insights',
                '',
                onTap: () => _navigateToPage('Insights'),
              ),
            ]),

            _buildSection('Your activity', [
              _buildSettingItem(
                Icons.download_outlined,
                'Download your information',
                '',
                onTap: () => _navigateToPage('Download info'),
              ),
              _buildSettingItem(
                Icons.archive_outlined,
                'Archive',
                '',
                onTap: () => _navigateToPage('Archive'),
              ),
              _buildSettingItem(
                Icons.schedule_outlined,
                'Your activity',
                '',
                onTap: () => _navigateToPage('Your activity'),
              ),
            ]),

            _buildSection('More info and support', [
              _buildSettingItem(
                Icons.help_outline,
                'Help',
                '',
                onTap: () => _navigateToPage('Help'),
              ),
              _buildSettingItem(
                Icons.info_outline,
                'About',
                '',
                onTap: () => _navigateToPage('About'),
              ),
              _buildSettingItem(
                Icons.description_outlined,
                'Privacy Policy',
                '',
                onTap: () => _navigateToPage('Privacy Policy'),
              ),
              _buildSettingItem(
                Icons.gavel_outlined,
                'Terms of Service',
                '',
                onTap: () => _navigateToPage('Terms of Service'),
              ),
            ]),

            _buildSection('Logins', [
              _buildSettingItem(
                Icons.add_outlined,
                'Add account',
                '',
                onTap: () => _navigateToPage('Add account'),
              ),
              _buildSettingItem(
                Icons.logout_outlined,
                'Log out',
                '',
                onTap: () => _showLogoutDialog(),
              ),
            ]),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
        ...items,
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSettingItem(
      IconData icon,
      String title,
      String subtitle, {
        required VoidCallback onTap,
      }) {
    return Container(
      color: Colors.white,
      child: ListTile(
        leading: Icon(icon, color: Colors.black),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        subtitle: subtitle.isNotEmpty
            ? Text(
          subtitle,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        )
            : null,
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey,
          size: 16,
        ),
        onTap: onTap,
      ),
    );
  }

  void _navigateToPage(String pageName) {
    // In a real app, you would navigate to the respective pages
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Navigate to $pageName')),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          'Log Out',
          style: TextStyle(color: Colors.black),
        ),
        content: const Text(
          'Are you sure you want to log out?',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Implement logout logic here
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logged out successfully')),
              );
            },
            child: const Text(
              'Log Out',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}