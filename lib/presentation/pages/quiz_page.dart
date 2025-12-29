import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import 'dart:math' as math;

import 'package:onomatopoeia_app/core/themes/app_text_styles.dart';
import 'package:onomatopoeia_app/core/themes/app_colors.dart';
import 'package:onomatopoeia_app/data/models/onomatopoeia_model.dart';
import 'package:onomatopoeia_app/data/providers/onomatopoeia_provider.dart';
import 'package:onomatopoeia_app/data/providers/user_provider.dart';
import 'package:onomatopoeia_app/presentation/widgets/common/app_bar_custom.dart';
import 'package:onomatopoeia_app/presentation/widgets/common/gradient_button.dart';
import 'package:onomatopoeia_app/presentation/widgets/onomatopoeia/audio_player_widget.dart';
import 'package:onomatopoeia_app/presentation/animations/fade_animation.dart';
import 'package:onomatopoeia_app/presentation/animations/scale_animation.dart';

class QuizPage extends StatefulWidget {
  final String? category;
  final int? difficulty;

  const QuizPage({
    super.key,
    this.category,
    this.difficulty,
  });

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late List<Onomatopoeia> _quizQuestions;
  late List<QuizQuestion> _questions;
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _isAnswered = false;
  bool _showResult = false;
  bool _isLoading = true;
  int? _selectedAnswerIndex;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadQuizQuestions();
    });
  }

  void _loadQuizQuestions() {
    final provider = Provider.of<OnomatopoeiaProvider>(context, listen: false);

    // Filter questions based on category and difficulty
    List<Onomatopoeia> filtered = provider.onomatopoeiaList;

    if (widget.category != null && widget.category != 'All') {
      filtered = filtered.where((item) => item.category == widget.category).toList();
    }

    if (widget.difficulty != null) {
      filtered = filtered.where((item) => item.difficulty == widget.difficulty).toList();
    }

    // Shuffle and take 10 questions
    filtered.shuffle();
    _quizQuestions = filtered.take(10).toList();

    // Create quiz questions
    _questions = _quizQuestions.map((onomatopoeia) {
      return QuizQuestion.fromOnomatopoeia(
        onomatopoeia,
        provider.onomatopoeiaList,
      );
    }).toList();

    setState(() => _isLoading = false);
  }

  void _selectAnswer(int index) {
    if (_isAnswered) return;

    setState(() {
      _selectedAnswerIndex = index;
      _isAnswered = true;

      if (_questions[_currentQuestionIndex].correctAnswerIndex == index) {
        _score++;

        // Update user stats
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.incrementLearnedWords();

        // Update onomatopoeia mastery
        final onomatopoeiaProvider = Provider.of<OnomatopoeiaProvider>(context, listen: false);
        final currentOnomatopoeia = _quizQuestions[_currentQuestionIndex];

        // You could add a method to update mastery in the provider
      } else {
        // Wrong answer - you could update stats here too
      }
    });

    // Move to next question after delay
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (_currentQuestionIndex < _questions.length - 1) {
        _nextQuestion();
      } else {
        _showResults();
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      _currentQuestionIndex++;
      _isAnswered = false;
      _selectedAnswerIndex = null;
    });
  }

  void _showResults() {
    if (_score >= (_questions.length * 0.8)) {
      _confettiController.play();
    }

    setState(() => _showResult = true);

    // Update user stats for completing quiz
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    // You could add a method to track quizzes completed
  }

  void _restartQuiz() {
    setState(() {
      _currentQuestionIndex = 0;
      _score = 0;
      _isAnswered = false;
      _showResult = false;
      _selectedAnswerIndex = null;
    });

    _confettiController.stop();
    _loadQuizQuestions();
  }

  void _exitQuiz() {
    Navigator.pop(context);
  }

  Color _getAnswerColor(int index) {
    if (!_isAnswered) return Colors.transparent;

    if (index == _questions[_currentQuestionIndex].correctAnswerIndex) {
      return Color.alphaBlend(Colors.green.withAlpha(51), Colors.transparent); // 20% opacity
    }

    if (index == _selectedAnswerIndex) {
      return Color.alphaBlend(Colors.red.withAlpha(51), Colors.transparent); // 20% opacity
    }

    return Colors.transparent;
  }

  Widget _getAnswerIcon(int index) {
    if (!_isAnswered) return const SizedBox.shrink();

    if (index == _questions[_currentQuestionIndex].correctAnswerIndex) {
      return const Icon(
        Icons.check_circle,
        color: Colors.green,
        size: 24,
      );
    }

    if (index == _selectedAnswerIndex) {
      return const Icon(
        Icons.cancel,
        color: Colors.red,
        size: 24,
      );
    }

    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        appBar: AppBarCustom(
          title: 'Loading Quiz...',
          showBackButton: true,
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: const AppBarCustom(
        title: 'Quiz',
        showBackButton: true,
      ),
      body: Stack(
        children: [
          if (_showResult)
            _buildResultsScreen()
          else
            _buildQuizScreen(),

          // Confetti
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple,
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuizScreen() {
    final question = _questions[_currentQuestionIndex];

    return Column(
      children: [
        // Progress Bar
        LinearProgressIndicator(
          value: (_currentQuestionIndex + 1) / _questions.length,
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          color: Theme.of(context).colorScheme.primary,
          minHeight: 4,
        ),

        // Header
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Question Counter
              Text(
                'Question ${_currentQuestionIndex + 1}/${_questions.length}',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              // Score
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Color.alphaBlend(
                    Theme.of(context).colorScheme.primary.withAlpha(26),
                    Theme.of(context).colorScheme.surface,
                  ), // 10% opacity
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.emoji_events, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '$_score',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Question Type
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Color.alphaBlend(
                Theme.of(context).colorScheme.primary.withAlpha(26),
                Theme.of(context).colorScheme.surface,
              ), // 10% opacity
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              question.type == QuizType.meaningToWord
                  ? 'What\'s the word?'
                  : 'What\'s the meaning?',
              style: AppTextStyles.bodySmall.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Question Card
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Question
                ScaleAnimation(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(26), // 10% opacity
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        if (question.type == QuizType.meaningToWord)
                          Column(
                            children: [
                              // Audio Player (for sound-based questions)
                              AudioPlayerWidget(
                                soundPath: question.correctOnomatopoeia.soundPath,
                              ),

                              const SizedBox(height: 24),

                              // Meaning Question
                              Text(
                                question.correctOnomatopoeia.meaning,
                                style: AppTextStyles.headlineMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),

                              const SizedBox(height: 16),

                              // Example Sentence Hint
                              Text(
                                question.correctOnomatopoeia.exampleSentence,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontStyle: FontStyle.italic,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          )
                        else
                          Column(
                            children: [
                              // Japanese Word Question
                              Text(
                                question.correctOnomatopoeia.japanese,
                                style: AppTextStyles.japaneseLarge.copyWith(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),

                              const SizedBox(height: 16),

                              // Romaji Hint
                              Text(
                                question.correctOnomatopoeia.romaji,
                                style: AppTextStyles.bodyLarge.copyWith(
                                  fontStyle: FontStyle.italic,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Answers
                Column(
                  children: List.generate(question.options.length, (index) {
                    return FadeAnimation(
                      delay: index * 100,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Card(
                          color: _getAnswerColor(index),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            leading: Container(
                              width: 40,
                              height: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Color.alphaBlend(
                                  Theme.of(context).colorScheme.primary.withAlpha(26),
                                  Theme.of(context).colorScheme.surface,
                                ), // 10% opacity
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                String.fromCharCode(65 + index), // A, B, C, D
                                style: AppTextStyles.bodyLarge.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                            title: Text(
                              question.options[index],
                              style: AppTextStyles.bodyMedium,
                            ),
                            trailing: _getAnswerIcon(index),
                            onTap: () => _selectAnswer(index),
                          ),
                        ),
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),

        // Fixed Bottom Section with Navigation Button
        if (_isAnswered)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).dividerColor.withAlpha(51),
                  width: 1,
                ),
              ),
            ),
            child: ScaleAnimation(
              child: GradientButton(
                onPressed: () {
                  if (_currentQuestionIndex < _questions.length - 1) {
                    _nextQuestion();
                  } else {
                    _showResults();
                  }
                },
                gradient: AppColors.primaryGradient,
                child: Text(
                  _currentQuestionIndex < _questions.length - 1
                      ? 'Next Question'
                      : 'See Results',
                  style: AppTextStyles.buttonLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildResultsScreen() {
    final percentage = (_score / _questions.length) * 100;
    String message;
    Color color;

    if (percentage >= 90) {
      message = 'Excellent! You\'re a master!';
      color = Colors.green;
    } else if (percentage >= 70) {
      message = 'Great job! Keep practicing!';
      color = Colors.blue;
    } else if (percentage >= 50) {
      message = 'Good effort! Try again!';
      color = Colors.orange;
    } else {
      message = 'Keep learning! You\'ll improve!';
      color = Colors.red;
    }

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Result Icon
            ScaleAnimation(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Color.alphaBlend(color.withAlpha(26), Colors.transparent), // 10% opacity
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  percentage >= 70 ? Icons.emoji_events : Icons.school,
                  size: 60,
                  color: color,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Score
            FadeAnimation(
              delay: 200,
              child: Text(
                'Your Score',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(153), // 60% opacity
                ),
              ),
            ),

            FadeAnimation(
              delay: 300,
              child: Text(
                '$_score/${_questions.length}',
                style: AppTextStyles.headlineLarge.copyWith(
                  fontSize: 72,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),

            FadeAnimation(
              delay: 400,
              child: Text(
                '${percentage.toStringAsFixed(1)}%',
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Message
            FadeAnimation(
              delay: 500,
              child: Text(
                message,
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 48),

            // Buttons
            Column(
              children: [
                FadeAnimation(
                  delay: 600,
                  child: GradientButton(
                    onPressed: _restartQuiz,
                    gradient: AppColors.primaryGradient,
                    child: Text(
                      'Try Again',
                      style: AppTextStyles.buttonLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                FadeAnimation(
                  delay: 700,
                  child: OutlinedButton(
                    onPressed: _exitQuiz,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.primary,
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Exit Quiz',
                      style: AppTextStyles.buttonLarge,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Review Section
            FadeAnimation(
              delay: 800,
              child: Column(
                children: [
                  Text(
                    'Review Mistakes',
                    style: AppTextStyles.headlineSmall.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    'Take note of the words you missed and practice them more.',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withAlpha(153), // 60% opacity
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }
}

class QuizQuestion {
  final QuizType type;
  final Onomatopoeia correctOnomatopoeia;
  final List<String> options;
  final int correctAnswerIndex;

  QuizQuestion({
    required this.type,
    required this.correctOnomatopoeia,
    required this.options,
    required this.correctAnswerIndex,
  });

  factory QuizQuestion.fromOnomatopoeia(
      Onomatopoeia onomatopoeia,
      List<Onomatopoeia> allOnomatopoeia,
      ) {
    final random = QuizRandom();
    final type = random.nextBool() ? QuizType.meaningToWord : QuizType.wordToMeaning;

    // Get incorrect options from other onomatopoeia
    final incorrectOptions = allOnomatopoeia
        .where((item) => item.id != onomatopoeia.id)
        .map((item) => type == QuizType.meaningToWord ? item.japanese : item.meaning)
        .toList()
      ..shuffle();

    // Take 3 incorrect options
    final selectedIncorrect = incorrectOptions.take(3).toList();

    // Create options list
    final options = <String>[
      type == QuizType.meaningToWord
          ? onomatopoeia.japanese
          : onomatopoeia.meaning,
      ...selectedIncorrect,
    ];

    // Shuffle options
    options.shuffle();

    // Find correct answer index
    final correctAnswer = type == QuizType.meaningToWord
        ? onomatopoeia.japanese
        : onomatopoeia.meaning;

    final correctAnswerIndex = options.indexWhere((option) => option == correctAnswer);

    return QuizQuestion(
      type: type,
      correctOnomatopoeia: onomatopoeia,
      options: options,
      correctAnswerIndex: correctAnswerIndex,
    );
  }
}

enum QuizType {
  meaningToWord,
  wordToMeaning,
}

// Helper class for random
class QuizRandom {
  final math.Random _random = math.Random();

  bool nextBool() => _random.nextBool();
  int nextInt(int max) => _random.nextInt(max);
}