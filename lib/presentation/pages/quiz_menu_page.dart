import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:onomatopoeia_app/presentation/pages/quiz_page.dart';
import 'package:onomatopoeia_app/core/themes/app_text_styles.dart';
import 'package:onomatopoeia_app/presentation/widgets/common/app_bar_custom.dart';
import 'package:onomatopoeia_app/data/providers/onomatopoeia_provider.dart';

class QuizMenuPage extends StatelessWidget {
  const QuizMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCustom(
        title: 'Quiz Menu',
        showBackButton: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Quiz Type',
              style: AppTextStyles.headlineMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Practice with different quiz modes',
              style: AppTextStyles.bodyMedium.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(153),
              ),
            ),
            const SizedBox(height: 24),
            _buildQuizOption(
              context,
              'Quick Quiz',
              'Random 10 questions from all categories',
              Icons.bolt,
              Colors.orange,
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const QuizPage(),
                  ),
                );
              },
            ),
            _buildQuizOption(
              context,
              'Category Quiz',
              'Focus on specific categories',
              Icons.category,
              Colors.blue,
                  () {
                _showCategoryDialog(context);
              },
            ),
            _buildQuizOption(
              context,
              'Difficulty Quiz',
              'Quiz by difficulty level',
              Icons.school,
              Colors.green,
                  () {
                _showDifficultyDialog(context);
              },
            ),
            _buildQuizOption(
              context,
              'Mixed Quiz',
              'All categories and difficulties',
              Icons.shuffle,
              Colors.purple,
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const QuizPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizOption(
      BuildContext context,
      String title,
      String subtitle,
      IconData icon,
      Color color,
      VoidCallback onTap,
      ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withAlpha(26),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 24, color: color),
        ),
        title: Text(
          title,
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: AppTextStyles.bodyMedium.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withAlpha(153),
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: Theme.of(context).colorScheme.primary,
        ),
        onTap: onTap,
      ),
    );
  }

  void _showCategoryDialog(BuildContext context) {
    // All categories from CategoryChip widget
    final categories = [
      'All',
      'Animal',
      'Nature',
      'Human',
      'Object',
      'Food',
      'Vehicle',
      'Music',
      'Technology'
    ];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Select Category',
            style: AppTextStyles.headlineSmall,
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(categories[index]),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuizPage(category: categories[index]),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        );
      },
    );
  }

  void _showDifficultyDialog(BuildContext context) {
    final provider = Provider.of<OnomatopoeiaProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Select Difficulty',
            style: AppTextStyles.headlineSmall,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(5, (index) {
              final difficulty = index + 1;
              String difficultyText;
              int questionCount = provider.onomatopoeiaList
                  .where((item) => item.difficulty == difficulty)
                  .length;

              bool hasEnoughQuestions = questionCount >= 4;

              switch (difficulty) {
                case 1:
                  difficultyText = 'Level 1 (Beginner)';
                  break;
                case 2:
                  difficultyText = 'Level 2 (Easy)';
                  break;
                case 3:
                  difficultyText = 'Level 3 (Intermediate)';
                  break;
                case 4:
                  difficultyText = 'Level 4 (Advanced)';
                  break;
                case 5:
                  difficultyText = 'Level 5 (Expert)';
                  break;
                default:
                  difficultyText = 'Level $difficulty';
              }

              return ListTile(
                title: Text(difficultyText),
                subtitle: !hasEnoughQuestions && difficulty >= 4
                    ? Text(
                  'Only $questionCount question${questionCount == 1 ? '' : 's'} available',
                  style: const TextStyle(
                    color: Colors.orange,
                    fontSize: 12,
                  ),
                )
                    : null,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuizPage(difficulty: difficulty),
                    ),
                  );
                },
              );
            }),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        );
      },
    );
  }
}