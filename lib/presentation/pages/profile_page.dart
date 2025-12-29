import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:onomatopoeia_app/core/themes/app_text_styles.dart';
import 'package:onomatopoeia_app/data/providers/user_provider.dart';
import 'package:onomatopoeia_app/presentation/widgets/common/app_bar_custom.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: const AppBarCustom(
        title: 'Profile',
        showBackButton: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            _buildProfileHeader(context, userProvider),

            // Stats Section
            _buildStatsSection(context, userProvider),

            // Settings Section
            _buildSettingsSection(context),

            // About Section
            _buildAboutSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, UserProvider userProvider) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryColor,
            Color.alphaBlend(Colors.white.withAlpha(51), primaryColor), // 20% lighter
          ],
        ),
      ),
      child: Column(
        children: [
          // Avatar
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: Text(
              userProvider.username.substring(0, 2).toUpperCase(),
              style: AppTextStyles.headlineLarge.copyWith(
                color: primaryColor,
              ),
            ),
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
              color: Colors.white.withAlpha(204), // 80% opacity: 255 * 0.8 = 204
            ),
          ),
          const SizedBox(height: 16),
          // Edit Profile Button
          OutlinedButton(
            onPressed: () {
              // Navigate to edit profile
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text('Edit Profile'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context, UserProvider userProvider) {
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
                'Total Words',
                '${userProvider.learnedWords}',
                Icons.book,
                Colors.blue,
              ),
              _buildStatCard(
                context,
                'Mastery Rate',
                '${userProvider.totalMastery}%',
                Icons.emoji_events,
                Colors.green,
              ),
              _buildStatCard(
                context,
                'Favorites',
                '${userProvider.favoriteCount}',
                Icons.favorite,
                Colors.red,
              ),
              _buildStatCard(
                context,
                'Study Streak',
                '${userProvider.streakDays} days',
                Icons.local_fire_department,
                Colors.orange,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12), // Reduced padding
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon with constrained size
            Container(
              constraints: const BoxConstraints(maxHeight: 32),
              child: Icon(icon, size: 28, color: color),
            ),
            const SizedBox(height: 6), // Reduced spacing
            // Value text with ellipsis
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  value,
                  style: AppTextStyles.headlineMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20, // Explicit font size
                  ),
                  maxLines: 1,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 4),
            // Title text with ellipsis
            Text(
              title,
              style: AppTextStyles.bodySmall.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(153),
                fontSize: 11, // Smaller font size
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

  Widget _buildSettingsSection(BuildContext context) {
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
                  context,
                  Icons.notifications,
                  'Notifications',
                  Icons.chevron_right,
                      () {},
                ),
                _buildSettingDivider(),
                _buildSettingItem(
                  context,
                  Icons.volume_up,
                  'Sound Settings',
                  Icons.chevron_right,
                      () {},
                ),
                _buildSettingDivider(),
                _buildSettingItem(
                  context,
                  Icons.language,
                  'Language',
                  Icons.chevron_right,
                      () {},
                ),
                _buildSettingDivider(),
                _buildSettingItem(
                  context,
                  Icons.backup,
                  'Backup & Sync',
                  Icons.chevron_right,
                      () {},
                ),
                _buildSettingDivider(),
                _buildSettingItem(
                  context,
                  Icons.security,
                  'Privacy',
                  Icons.chevron_right,
                      () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(
      BuildContext context,
      IconData icon,
      String title,
      IconData trailingIcon,
      VoidCallback onTap,
      ) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title),
      trailing: Icon(trailingIcon),
      onTap: onTap,
    );
  }

  Widget _buildSettingDivider() {
    return const Divider(height: 0, indent: 72);
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
                  context,
                  Icons.star,
                  'Rate App',
                      () {
                    _launchURL('https://play.google.com/store/apps/details?id=your.package.name');
                  },
                ),
                _buildSettingDivider(),
                _buildAboutItem(
                  context,
                  Icons.share,
                  'Share App',
                      () {
                    Share.share(
                      'Check out this awesome Japanese Onomatopoeia learning app!',
                    );
                  },
                ),
                _buildSettingDivider(),
                _buildAboutItem(
                  context,
                  Icons.help,
                  'Help & Support',
                      () {
                    _launchURL('mailto:support@onomatopoeia.com');
                  },
                ),
                _buildSettingDivider(),
                _buildAboutItem(
                  context,
                  Icons.privacy_tip,
                  'Privacy Policy',
                      () {
                    _launchURL('https://yourwebsite.com/privacy');
                  },
                ),
                _buildSettingDivider(),
                _buildAboutItem(
                  context,
                  Icons.description,
                  'Terms of Service',
                      () {
                    _launchURL('https://yourwebsite.com/terms');
                  },
                ),
                _buildSettingDivider(),
                _buildAboutItem(
                  context,
                  Icons.info,
                  'App Version',
                      () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Version 1.0.0')),
                    );
                  },
                  showTrailing: false,
                  trailingText: '1.0.0',
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
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutItem(
      BuildContext context,
      IconData icon,
      String title,
      VoidCallback onTap, {
        bool showTrailing = true,
        String trailingText = '',
      }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title),
      trailing: showTrailing
          ? const Icon(Icons.chevron_right)
          : Text(
        trailingText,
        style: AppTextStyles.bodySmall.copyWith(
          color: Theme.of(context).colorScheme.onSurface.withAlpha(153), // 60% opacity
        ),
      ),
      onTap: onTap,
    );
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle logout
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Colors.white,
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}