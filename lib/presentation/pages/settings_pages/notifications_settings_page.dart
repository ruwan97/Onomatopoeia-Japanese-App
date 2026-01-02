import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:onomatopoeia_app/core/themes/app_text_styles.dart';
import 'package:onomatopoeia_app/data/providers/user_provider.dart';
import 'package:onomatopoeia_app/presentation/widgets/common/app_bar_custom.dart';

class NotificationsSettingsPage extends StatefulWidget {
  const NotificationsSettingsPage({super.key});

  @override
  State<NotificationsSettingsPage> createState() =>
      _NotificationsSettingsPageState();
}

class _NotificationsSettingsPageState extends State<NotificationsSettingsPage> {
  late Map<String, dynamic> _preferences;

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _preferences = Map.from(userProvider.preferences);
  }

  void _updatePreference(String key, dynamic value) {
    setState(() {
      _preferences[key] = value;
    });
    Provider.of<UserProvider>(context, listen: false)
        .updatePreference(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCustom(
        title: 'Notification Settings',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Push Notifications',
              style: AppTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Choose what notifications you want to receive',
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            _buildNotificationSetting(
              title: 'Daily Reminders',
              subtitle: 'Remind you to study every day',
              value: _preferences['notifications'] ?? true,
              onChanged: (value) => _updatePreference('notifications', value),
            ),
            const SizedBox(height: 8),
            _buildNotificationSetting(
              title: 'Study Progress',
              subtitle: 'Updates on your learning progress',
              value: _preferences['progressNotifications'] ?? true,
              onChanged: (value) =>
                  _updatePreference('progressNotifications', value),
            ),
            const SizedBox(height: 8),
            _buildNotificationSetting(
              title: 'Achievements',
              subtitle: 'When you earn new achievements',
              value: _preferences['achievementNotifications'] ?? true,
              onChanged: (value) =>
                  _updatePreference('achievementNotifications', value),
            ),
            const SizedBox(height: 8),
            _buildNotificationSetting(
              title: 'App Updates',
              subtitle: 'New features and improvements',
              value: _preferences['updateNotifications'] ?? true,
              onChanged: (value) =>
                  _updatePreference('updateNotifications', value),
            ),
            const SizedBox(height: 32),
            Text(
              'Notification Schedule',
              style: AppTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(Icons.access_time),
                title: const Text('Reminder Time'),
                subtitle: const Text('Set daily reminder time'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  _selectReminderTime(context);
                },
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Days of Week'),
                subtitle: const Text('Select days for reminders'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  _selectDaysOfWeek(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationSetting({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      child: SwitchListTile(
        title: Text(title, style: AppTextStyles.bodyLarge),
        subtitle: Text(subtitle, style: AppTextStyles.bodySmall),
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  void _selectReminderTime(BuildContext context) async {
    final initialTime = TimeOfDay.now();
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (selectedTime != null) {
      // Save the selected time
      _updatePreference(
        'reminderTime',
        '${selectedTime.hour}:${selectedTime.minute}',
      );
    }
  }

  void _selectDaysOfWeek(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final selectedDays = List<bool>.filled(7, false);
        return AlertDialog(
          title: const Text('Select Days'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDayCheckbox('Monday', 0, selectedDays),
              _buildDayCheckbox('Tuesday', 1, selectedDays),
              _buildDayCheckbox('Wednesday', 2, selectedDays),
              _buildDayCheckbox('Thursday', 3, selectedDays),
              _buildDayCheckbox('Friday', 4, selectedDays),
              _buildDayCheckbox('Saturday', 5, selectedDays),
              _buildDayCheckbox('Sunday', 6, selectedDays),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Save selected days
                final daysList = <String>[];
                for (int i = 0; i < selectedDays.length; i++) {
                  if (selectedDays[i]) {
                    daysList.add(_getDayName(i));
                  }
                }
                _updatePreference('reminderDays', daysList);
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDayCheckbox(String day, int index, List<bool> selectedDays) {
    return CheckboxListTile(
      title: Text(day),
      value: selectedDays[index],
      onChanged: (value) {
        selectedDays[index] = value ?? false;
      },
    );
  }

  String _getDayName(int index) {
    switch (index) {
      case 0:
        return 'Monday';
      case 1:
        return 'Tuesday';
      case 2:
        return 'Wednesday';
      case 3:
        return 'Thursday';
      case 4:
        return 'Friday';
      case 5:
        return 'Saturday';
      case 6:
        return 'Sunday';
      default:
        return '';
    }
  }
}
