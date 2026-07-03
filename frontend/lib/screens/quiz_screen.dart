import 'package:flutter/material.dart';
import '../models/quiz_model.dart';
import '../app_colors.dart';

class QuizScreen extends StatefulWidget {
  final Quiz quiz;

  const QuizScreen({required this.quiz, Key? key}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late PageController _pageController;
  int _currentQuestionIndex = 0;
  Map<int, String> _answers = {};
  bool _isSubmitted = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _answerQuestion(String answer) {
    setState(() {
      _answers[_currentQuestionIndex] = answer;
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < widget.quiz.questions.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _submitQuiz() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Submit Quiz'),
        content: Text(
          'You answered ${_answers.length} out of ${widget.quiz.questions.length} questions.\n\nAre you sure you want to submit?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _isSubmitted = true);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Quiz submitted successfully!'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                ),
              );
              Future.delayed(const Duration(seconds: 2), () {
                if (mounted) Navigator.pop(context);
              });
            },
            child: const Text(
              'Submit',
              style: TextStyle(color: Colors.green),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentYear = DateTime.now().year;
    final isLastQuestion =
        _currentQuestionIndex == widget.quiz.questions.length - 1;

    if (widget.quiz.questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.quiz.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Year: $currentYear',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
        body: const Center(
          child: Text('No questions available'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.quiz.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Year: $currentYear',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        elevation: 0,
      ),
      body: _isSubmitted
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 80,
                    color: AppColors.success,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Quiz Completed!',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You answered ${_answers.length} out of ${widget.quiz.questions.length} questions',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Back to Dashboard'),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                // Progress Bar
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Question ${_currentQuestionIndex + 1}/${widget.quiz.questions.length}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            '${((_currentQuestionIndex + 1) / widget.quiz.questions.length * 100).toStringAsFixed(0)}%',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: (_currentQuestionIndex + 1) /
                              widget.quiz.questions.length,
                          minHeight: 6,
                          backgroundColor: AppColors.primary.withOpacity(0.2),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Questions PageView
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (index) {
                      setState(() => _currentQuestionIndex = index);
                    },
                    itemCount: widget.quiz.questions.length,
                    itemBuilder: (context, index) {
                      final question = widget.quiz.questions[index];
                      final selectedAnswer = _answers[index];

                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Question Text
                            Text(
                              question.question,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 32),
                            // Answer Options
                            ...List.generate(
                              question.options.length,
                              (optionIndex) {
                                final option = question.options[optionIndex];
                                final isSelected = selectedAnswer == option;

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: ElevatedButton(
                                    onPressed: () => _answerQuestion(option),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isSelected
                                          ? AppColors.primary
                                          : Colors.grey[200],
                                      foregroundColor: isSelected
                                          ? Colors.white
                                          : Colors.black,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 16,
                                      ),
                                      alignment: Alignment.centerLeft,
                                      elevation: isSelected ? 2 : 0,
                                    ),
                                    child: Text(
                                      option,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                // Navigation Buttons
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _currentQuestionIndex > 0
                              ? _previousQuestion
                              : null,
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Previous'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed:
                              isLastQuestion ? _submitQuiz : _nextQuestion,
                          icon: Icon(
                            isLastQuestion ? Icons.check : Icons.arrow_forward,
                          ),
                          label: Text(
                            isLastQuestion ? 'Submit' : 'Next',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
