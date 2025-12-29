import 'package:flutter/material.dart';
import 'package:onomatopoeia_app/presentation/pages/quiz_page.dart';
import 'package:onomatopoeia_app/core/themes/app_text_styles.dart';

class QuizMenuPage extends StatelessWidget {
  const QuizMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Menu'),
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
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withAlpha(26),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 24, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  void _showCategoryDialog(BuildContext context) {
    final categories = ['All', 'Animal', 'Nature', 'Human', 'Object', 'Food'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Category'),
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
        );
      },
    );
  }

  void _showDifficultyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Difficulty'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(5, (index) {
              final difficulty = index + 1;
              String difficultyText;
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
        );
      },
    );
  }
}