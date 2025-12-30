import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import 'dart:math' as math;

import 'package:onomatopoeia_app/core/themes/app_text_styles.dart';
import 'package:onomatopoeia_app/data/models/onomatopoeia_model.dart';
import 'package:onomatopoeia_app/data/providers/onomatopoeia_provider.dart';
import 'package:onomatopoeia_app/data/providers/user_provider.dart';
import 'package:onomatopoeia_app/presentation/widgets/common/app_bar_custom.dart';
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

  // Track answer state for each question
  final Map<int, bool> _questionAnswered = {};
  final Map<int, int?> _selectedAnswers = {};

  bool _showResult = false;
  bool _isLoading = true;
  bool _notEnoughQuestions = false;
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

    // Check if we have enough questions (minimum 1 for a quiz)
    if (filtered.isEmpty) {
      setState(() {
        _isLoading = false;
        _notEnoughQuestions = true;
      });
      return;
    }

    // Shuffle and take 10 questions (or all if less than 10)
    filtered.shuffle();
    final int questionsToTake = filtered.length >= 10 ? 10 : filtered.length;
    _quizQuestions = filtered.take(questionsToTake).toList();

    // Create quiz questions
    _questions = _quizQuestions.map((onomatopoeia) {
      return QuizQuestion.fromOnomatopoeia(
        onomatopoeia,
        provider.onomatopoeiaList,
      );
    }).toList();

    // Initialize answer tracking
    for (int i = 0; i < _questions.length; i++) {
      _questionAnswered[i] = false;
      _selectedAnswers[i] = null;
    }

    setState(() {
      _isLoading = false;
      _notEnoughQuestions = false;
    });
  }

  void _selectAnswer(int index) {
    if (_questionAnswered[_currentQuestionIndex] == true) return;

    setState(() {
      _selectedAnswers[_currentQuestionIndex] = index;
      _questionAnswered[_currentQuestionIndex] = true;

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
  }

  void _nextQuestion() {
    setState(() {
      _currentQuestionIndex++;
    });
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

  void _showResults() {
    if (_questions.isNotEmpty && _score >= (_questions.length * 0.8)) {
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
      _showResult = false;

      // Reset all answer tracking
      for (int i = 0; i < _questions.length; i++) {
        _questionAnswered[i] = false;
        _selectedAnswers[i] = null;
      }
    });

    _confettiController.stop();
    _loadQuizQuestions();
  }

  void _exitQuiz() {
    Navigator.pop(context);
  }

  Color _getAnswerColor(int index) {
    if (_questionAnswered[_currentQuestionIndex] != true) return Colors.transparent;

    if (index == _questions[_currentQuestionIndex].correctAnswerIndex) {
      return Color.alphaBlend(Colors.green.withAlpha(51), Colors.transparent); // 20% opacity
    }

    if (index == _selectedAnswers[_currentQuestionIndex]) {
      return Color.alphaBlend(Colors.red.withAlpha(51), Colors.transparent); // 20% opacity
    }

    return Colors.transparent;
  }

  Widget _getAnswerIcon(int index) {
    if (_questionAnswered[_currentQuestionIndex] != true) return const SizedBox.shrink();

    if (index == _questions[_currentQuestionIndex].correctAnswerIndex) {
      return const Icon(
        Icons.check_circle,
        color: Colors.green,
        size: 24,
      );
    }

    if (index == _selectedAnswers[_currentQuestionIndex]) {
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

    if (_notEnoughQuestions) {
      return Scaffold(
        appBar: const AppBarCustom(
          title: 'Quiz',
          showBackButton: true,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.sentiment_dissatisfied,
                  size: 80,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
                ),
                const SizedBox(height: 24),
                Text(
                  'Not Enough Questions',
                  style: AppTextStyles.headlineMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  widget.difficulty != null
                      ? 'There are no words with difficulty level ${widget.difficulty} to create a quiz.'
                      : widget.category != null && widget.category != 'All'
                      ? 'There are no words in the "${widget.category}" category to create a quiz.'
                      : 'There are no words available to create a quiz.',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Go Back'),
                ),
              ],
            ),
          ),
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
    final isLastQuestion = _currentQuestionIndex == _questions.length - 1;
    final isAnswered = _questionAnswered[_currentQuestionIndex] == true;

    return Column(
      children: [
        // Progress Bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: LinearProgressIndicator(
            value: (_currentQuestionIndex + 1) / _questions.length,
            backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            color: Theme.of(context).colorScheme.primary,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ),

        // Header with score and question counter
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).dividerColor,
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              // Question Counter
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.help_outline,
                      size: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${_currentQuestionIndex + 1}/${_questions.length}',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Score
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.emoji_events,
                      size: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 6),
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

        // Question Type Badge
        Container(
          padding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              question.type == QuizType.meaningToWord
                  ? '🎯 What\'s the word?'
                  : '📖 What\'s the meaning?',
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        // Question Card (Fixed Height)
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (question.type == QuizType.meaningToWord)
                      Column(
                        children: [
                          // Audio Player
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

                          const SizedBox(height: 12),

                          // Example Sentence Hint
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '"${question.correctOnomatopoeia.exampleSentence}"',
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontStyle: FontStyle.italic,
                              ),
                              textAlign: TextAlign.center,
                            ),
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
                              fontSize: 56,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 16),

                          // Romaji Hint
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              question.correctOnomatopoeia.romaji,
                              style: AppTextStyles.bodyLarge.copyWith(
                                fontStyle: FontStyle.italic,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Answers Section (Fixed Height)
        Container(
          height: 220,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.5,
            ),
            itemCount: question.options.length,
            itemBuilder: (context, index) {
              return FadeAnimation(
                delay: index * 100,
                child: Material(
                  borderRadius: BorderRadius.circular(12),
                  color: _getAnswerColor(index),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => _selectAnswer(index),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(context).dividerColor,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          // Option Letter
                          Container(
                            width: 36,
                            height: 36,
                            margin: const EdgeInsets.only(left: 12),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                String.fromCharCode(65 + index), // A, B, C, D
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Option Text
                          Expanded(
                            child: Text(
                              question.options[index],
                              style: AppTextStyles.bodyMedium,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // Answer Icon
                          Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: _getAnswerIcon(index),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // Navigation Buttons (Inline)
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border(
              top: BorderSide(
                color: Theme.of(context).dividerColor,
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              // Back Button
              Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: _currentQuestionIndex > 0
                        ? LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                      ],
                    )
                        : null,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ElevatedButton(
                    onPressed: _currentQuestionIndex > 0 ? _previousQuestion : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: _currentQuestionIndex > 0
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.arrow_back, size: 18),
                        SizedBox(width: 8),
                        Text('Back'),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Next/Results Button
              Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: isAnswered
                        ? LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                        : null,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: isAnswered
                        ? [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ]
                        : null,
                  ),
                  child: ElevatedButton(
                    onPressed: isAnswered
                        ? () {
                      if (isLastQuestion) {
                        _showResults();
                      } else {
                        _nextQuestion();
                      }
                    }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: isAnswered ? Colors.white : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isLastQuestion ? 'See Results' : 'Next Question',
                          style: AppTextStyles.buttonMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (!isLastQuestion) const SizedBox(width: 8),
                        if (!isLastQuestion)
                          Icon(
                            Icons.arrow_forward,
                            size: 18,
                            color: isAnswered ? Colors.white : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResultsScreen() {
    final percentage = _questions.isNotEmpty ? (_score / _questions.length) * 100 : 0;
    String message;
    Color color;

    if (percentage >= 90) {
      message = 'Excellent! You\'re a master! 🏆';
      color = Colors.green;
    } else if (percentage >= 70) {
      message = 'Great job! Keep practicing! ⭐';
      color = Colors.blue;
    } else if (percentage >= 50) {
      message = 'Good effort! Try again! 💪';
      color = Colors.orange;
    } else {
      message = 'Keep learning! You\'ll improve! 📚';
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
            Row(
              children: [
                // Try Again Button
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: _restartQuiz,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Try Again',
                        style: AppTextStyles.buttonLarge.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Exit Button
                Expanded(
                  child: OutlinedButton(
                    onPressed: _exitQuiz,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.primary,
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
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

    // Take 3 incorrect options (or fewer if not enough)
    final int incorrectToTake = incorrectOptions.length >= 3 ? 3 : incorrectOptions.length;
    final selectedIncorrect = incorrectOptions.take(incorrectToTake).toList();

    // Create options list
    final options = <String>[
      type == QuizType.meaningToWord ? onomatopoeia.japanese : onomatopoeia.meaning,
      ...selectedIncorrect,
    ];

    // Shuffle options
    options.shuffle();

    // Find correct answer index
    final correctAnswer = type == QuizType.meaningToWord ? onomatopoeia.japanese : onomatopoeia.meaning;
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