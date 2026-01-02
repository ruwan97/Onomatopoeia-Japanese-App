import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:onomatopoeia_app/core/themes/app_text_styles.dart';
import 'package:onomatopoeia_app/data/providers/user_provider.dart';
import 'package:onomatopoeia_app/presentation/widgets/common/app_bar_custom.dart';
import 'package:onomatopoeia_app/presentation/pages/edit_profile_page.dart';
import 'package:onomatopoeia_app/presentation/pages/settings_pages/notifications_settings_page.dart';
import 'package:onomatopoeia_app/presentation/pages/settings_pages/language_settings_page.dart';
import 'package:onomatopoeia_app/services/navigation_service.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCustom(
        title: 'Profile',
        showBackButton: false,
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          return _buildProfileContent(context, userProvider);
        },
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, UserProvider userProvider) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Profile Header
          _buildProfileHeader(context, userProvider),

          // Stats Section
          _buildStatsSection(context, userProvider),

          // Settings Section
          _buildSettingsSection(context, userProvider),

          // About Section
          _buildAboutSection(context),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, UserProvider userProvider) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Create gradient colors based on theme
    final Color startColor = isDarkMode
        ? Color.alphaBlend(
            primaryColor.withAlpha(204), Colors.transparent) // 0.8 opacity
        : primaryColor;

    final Color endColor = isDarkMode
        ? Color.alphaBlend(
            primaryColor.withAlpha(153), Colors.transparent) // 0.6 opacity
        : Color.alphaBlend(Colors.white.withAlpha(51), primaryColor);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [startColor, endColor],
        ),
      ),
      child: Column(
        children: [
          // Avatar with Level Badge
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                child: Text(
                  userProvider.username.substring(0, 2).toUpperCase(),
                  style: AppTextStyles.headlineLarge.copyWith(
                    color: primaryColor,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Text(
                    'Lv${userProvider.userLevel}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // User Info
          Text(
            userProvider.username,
            style: AppTextStyles.headlineMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),

          Text(
            userProvider.email,
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white.withAlpha(204),
            ),
          ),
          const SizedBox(height: 8),

          // Level Progress
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(25),
              // Changed from withOpacity(0.1)
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Level ${userProvider.userLevel}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${userProvider.learnedWords} words',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white.withAlpha(180),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: (userProvider.learnedWords % 10) / 10,
                  backgroundColor: Colors.white.withAlpha(51),
                  // Changed from withOpacity(0.2)
                  color: Colors.amber,
                  minHeight: 4,
                  borderRadius: BorderRadius.circular(2),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Edit Profile Button
          OutlinedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditProfilePage(),
                ),
              );
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Edit Profile'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context, UserProvider userProvider) {
    final stats = userProvider.getUserStats();

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Learning Statistics',
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.5,
            children: [
              _buildStatCard(
                context,
                'Level',
                '${stats['level']}',
                Icons.star,
                Colors.amber,
              ),
              _buildStatCard(
                context,
                'Learned',
                '${stats['learnedWords']}',
                Icons.book,
                Colors.blue,
              ),
              _buildStatCard(
                context,
                'Favorites',
                '${stats['favorites']}',
                Icons.favorite,
                Colors.red,
              ),
              _buildStatCard(
                context,
                'Streak',
                '${stats['streak']} days',
                Icons.local_fire_department,
                Colors.orange,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Mastery Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Mastery Level',
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getMasteryColor(stats['mastery']),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          stats['mastery'] is double
                              ? '${(stats['mastery'] * 100).toStringAsFixed(1)}%'
                              : '${stats['mastery']}%',
                          style: AppTextStyles.caption.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: _getMasteryValue(stats['mastery']),
                    backgroundColor: Colors.grey.shade200,
                    color: _getMasteryColor(stats['mastery']),
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildMasteryLabel(
                          'Beginner', 0.3, _getMasteryValue(stats['mastery'])),
                      _buildMasteryLabel('Intermediate', 0.6,
                          _getMasteryValue(stats['mastery'])),
                      _buildMasteryLabel(
                          'Advanced', 0.9, _getMasteryValue(stats['mastery'])),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: AppTextStyles.headlineMedium.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: AppTextStyles.bodySmall.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(153),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMasteryLabel(
      String label, double threshold, double currentValue) {
    final isActive = currentValue >= threshold;
    return Column(
      children: [
        Icon(
          Icons.circle,
          size: 12,
          color:
              isActive ? _getMasteryColor(currentValue) : Colors.grey.shade300,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: isActive ? Colors.black : Colors.grey,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Color _getMasteryColor(dynamic mastery) {
    final value = _getMasteryValue(mastery);
    if (value < 0.3) return Colors.red;
    if (value < 0.6) return Colors.orange;
    if (value < 0.9) return Colors.blue;
    return Colors.green;
  }

  double _getMasteryValue(dynamic mastery) {
    if (mastery == null) return 0.0;
    return mastery is double ? mastery : (mastery as int) / 100;
  }

  Widget _buildSettingsSection(
      BuildContext context, UserProvider userProvider) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings',
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                _buildSettingItem(
                  context: context,
                  icon: Icons.notifications,
                  title: 'Notifications',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NotificationsSettingsPage(),
                      ),
                    );
                  },
                ),
                const Divider(height: 0, indent: 72),
                _buildSettingItem(
                  context: context,
                  icon: Icons.volume_up,
                  title: 'Sound',
                  onTap: () {
                    _showSoundSettings(context);
                  },
                ),
                const Divider(height: 0, indent: 72),
                _buildSettingItem(
                  context: context,
                  icon: Icons.language,
                  title: 'Language',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LanguageSettingsPage(),
                      ),
                    );
                  },
                ),
                const Divider(height: 0, indent: 72),
                _buildSettingItemWithSwitch(
                  context: context,
                  icon: Icons.auto_awesome,
                  title: 'Auto-play Audio',
                  value: userProvider.preferences['autoPlay'] ?? false,
                  onChanged: (value) {
                    // Handle preference update
                  },
                ),
                const Divider(height: 0, indent: 72),
                _buildSettingItem(
                  context: context,
                  icon: Icons.security,
                  title: 'Privacy',
                  onTap: () {
                    _showPrivacySettings(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildSettingItemWithSwitch({
    required BuildContext context,
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About',
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          Card(
            child: Column(
              children: [
                _buildAboutItem(
                  context: context,
                  icon: Icons.star,
                  title: 'Rate App',
                  onTap: () => _rateApp(context),
                ),
                const Divider(height: 0, indent: 72),
                _buildAboutItem(
                  context: context,
                  icon: Icons.share,
                  title: 'Share App',
                  onTap: () => _shareApp(context),
                ),
                const Divider(height: 0, indent: 72),
                _buildAboutItem(
                  context: context,
                  icon: Icons.help,
                  title: 'Help & Support',
                  onTap: () => _showHelpSupport(context),
                ),
                const Divider(height: 0, indent: 72),
                _buildAboutItem(
                  context: context,
                  icon: Icons.privacy_tip,
                  title: 'Privacy Policy',
                  onTap: () =>
                      _launchUrl(context, 'https://example.com/privacy'),
                ),
                const Divider(height: 0, indent: 72),
                _buildAboutItem(
                  context: context,
                  icon: Icons.description,
                  title: 'Terms of Service',
                  onTap: () => _launchUrl(context, 'https://example.com/terms'),
                ),
                const Divider(height: 0, indent: 72),
                ListTile(
                  leading: Icon(Icons.info,
                      color: Theme.of(context).colorScheme.primary),
                  title: const Text('App Version'),
                  trailing: Text(
                    '1.0.0',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withAlpha(153),
                    ),
                  ),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Onomatopoeia App v1.0.0'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Logout Button
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                _showLogoutDialog(context);
              },
              icon: const Icon(Icons.logout, size: 20),
              label: const Text(
                'Logout',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Reset Data Button
          Center(
            child: TextButton(
              onPressed: () {
                _showResetDataDialog(context);
              },
              child: Text(
                'Reset All Data',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final navigationService =
        Provider.of<NavigationService>(context, listen: false);

    await navigationService.showConfirmationDialog(
      title: 'Logout',
      content: 'Are you sure you want to logout?',
      confirmText: 'Logout',
      cancelText: 'Cancel',
      onConfirm: () async {
        await userProvider.resetData();
        navigationService.showSnackBar('Logged out successfully');
      },
    );
  }

  Future<void> _showResetDataDialog(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final navigationService =
        Provider.of<NavigationService>(context, listen: false);

    await navigationService.showConfirmationDialog(
      title: 'Reset All Data',
      content: 'This will delete all your progress, favorites, and settings. '
          'This action cannot be undone. Are you sure?',
      confirmText: 'Reset Data',
      cancelText: 'Cancel',
      onConfirm: () async {
        await userProvider.resetData();
        navigationService.showSnackBar('All data has been reset');
      },
    );
  }

  Future<void> _rateApp(BuildContext context) async {
    try {
      final url = Uri.parse(
        'https://play.google.com/store/apps/details?id=com.example.onomatopoeia_app',
      );
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not launch app store'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _shareApp(BuildContext context) async {
    try {
      await Share.share(
        'Check out this amazing Japanese Onomatopoeia learning app! '
        'Learn Japanese sound words in a fun and interactive way. '
        'https://example.com/onomatopoeia-app',
        subject: 'Japanese Onomatopoeia App',
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not share: $e'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _launchUrl(BuildContext context, String urlString) async {
    try {
      final url = Uri.parse(urlString);
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not open the link'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _showSoundSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sound Settings'),
          content: const Text('Sound settings feature coming soon!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showPrivacySettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Privacy Settings'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('• Data Collection: Minimal usage data for app improvement'),
              SizedBox(height: 8),
              Text('• Local Storage: All data stored locally on your device'),
              SizedBox(height: 8),
              Text('• No Third-party Sharing: We do not share your data'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _launchUrl(context, 'https://example.com/privacy');
              },
              child: const Text('Full Policy'),
            ),
          ],
        );
      },
    );
  }

  void _showHelpSupport(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Help & Support'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: Icon(Icons.email),
                title: Text('Email Support'),
                subtitle: Text('support@onomatopoeia.app'),
              ),
              ListTile(
                leading: Icon(Icons.help_center),
                title: Text('FAQ'),
                subtitle: Text('Frequently asked questions'),
              ),
              ListTile(
                leading: Icon(Icons.bug_report),
                title: Text('Report Issue'),
                subtitle: Text('Found a bug? Let us know'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _launchUrl(context, 'mailto:support@onomatopoeia.app');
              },
              child: const Text('Contact'),
            ),
          ],
        );
      },
    );
  }
}
