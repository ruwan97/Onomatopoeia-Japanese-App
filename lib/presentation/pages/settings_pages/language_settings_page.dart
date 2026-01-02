import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:onomatopoeia_app/core/themes/app_text_styles.dart';
import 'package:onomatopoeia_app/core/utils/helpers/color_helper.dart';
import 'package:onomatopoeia_app/data/providers/user_provider.dart';
import 'package:onomatopoeia_app/presentation/widgets/common/app_bar_custom.dart';

class LanguageSettingsPage extends StatefulWidget {
  const LanguageSettingsPage({super.key});

  @override
  State<LanguageSettingsPage> createState() => _LanguageSettingsPageState();
}

class _LanguageSettingsPageState extends State<LanguageSettingsPage> {
  String? _selectedLanguage;

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _selectedLanguage = userProvider.preferences['language'] ?? 'system';
  }

  final List<Map<String, String>> languages = [
    {'code': 'system', 'name': 'System Default', 'native': 'Follow device'},
    {'code': 'en', 'name': 'English', 'native': 'English'},
    {'code': 'ja', 'name': 'Japanese', 'native': '日本語'},
    {'code': 'es', 'name': 'Spanish', 'native': 'Español'},
    {'code': 'fr', 'name': 'French', 'native': 'Français'},
    {'code': 'de', 'name': 'German', 'native': 'Deutsch'},
    {'code': 'ko', 'name': 'Korean', 'native': '한국어'},
    {'code': 'zh', 'name': 'Chinese', 'native': '中文'},
  ];

  void _selectLanguage(String languageCode) {
    setState(() {
      _selectedLanguage = languageCode;
    });
    Provider.of<UserProvider>(context, listen: false)
        .updatePreference('language', languageCode);
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: const AppBarCustom(
        title: 'Language Settings',
        showBackButton: true,
      ),
      body: ListView.builder(
        itemCount: languages.length,
        itemBuilder: (context, index) {
          final language = languages[index];
          final isSelected = _selectedLanguage == language['code'];

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: ColorHelper.primaryWithOpacity10(context),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    language['code'] == 'system'
                        ? '🌐'
                        : language['code']!.toUpperCase(),
                    style: language['code'] == 'system'
                        ? const TextStyle(fontSize: 20)
                        : AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                  ),
                ),
              ),
              title: Text(language['name']!),
              subtitle: Text(language['native']!),
              trailing: isSelected
                  ? Icon(
                      Icons.check_circle,
                      color: primaryColor,
                    )
                  : null,
              onTap: () => _selectLanguage(language['code']!),
            ),
          );
        },
      ),
    );
  }
}
