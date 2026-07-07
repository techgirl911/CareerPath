import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../app_colors.dart';
import '../services/quiz_service.dart';
import '../models/quiz_model.dart';

class QuizScreen extends StatefulWidget {
  final String? quizId;
  final String? studentId;

  const QuizScreen({
    this.quizId,
    this.studentId,
    Key? key,
  }) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late QuizService _quizService;
  Quiz? _quiz;
  bool _isLoading = true;
  String? _error;
  int _currentQuestionIndex = 0;
  final Map<int, String> _answers = {};

  @override
  void initState() {
    super.initState();
    _quizService = QuizService();
    _loadQuiz();
  }

  Future<void> _loadQuiz() async {
    try {
      if (widget.quizId == null || widget.quizId!.isEmpty) {
        setState(() {
          _error = 'Quiz ID not found';
          _isLoading = false;
        });
        return;
      }

      final quiz = await _quizService.getQuizById(widget.quizId!);
      setState(() {
        _quiz = quiz;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading quiz: $e');
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _submitQuiz() async {
    if (_quiz == null || widget.studentId == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Submit Quiz'),
        content: const Text('Are you sure you want to submit this quiz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                // Submit quiz responses
                await _quizService.submitQuizResponse(
                  studentId: widget.studentId!,
                  quizId: widget.quizId!,
                  answers: _answers
                      .map((key, value) => MapEntry(key.toString(), value)),
                );

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Quiz submitted successfully!'),
                      backgroundColor: Color(0xFF10B981),
                    ),
                  );

                  Future.delayed(const Duration(milliseconds: 500), () {
                    if (mounted) {
                      context.go(
                          '/student-dashboard?studentId=${widget.studentId}');
                    }
                  });
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _quiz != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_quiz!.title),
                  Text(
                    'Year: ${DateTime.now().year}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              )
            : const Text('Quiz'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline,
                          size: 60, color: AppColors.error),
                      const SizedBox(height: 16),
                      Text('Error: $_error'),
                    ],
                  ),
                )
              : _quiz == null
                  ? const Center(child: Text('Quiz not found'))
                  : Column(
                      children: [
                        // Progress Bar
                        LinearProgressIndicator(
                          value: (_currentQuestionIndex + 1) /
                              _quiz!.questions.length,
                          minHeight: 4,
                        ),
                        Expanded(
                          child: PageView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            onPageChanged: (index) {
                              setState(() => _currentQuestionIndex = index);
                            },
                            controller: PageController(
                              initialPage: _currentQuestionIndex,
                            ),
                            itemCount: _quiz!.questions.length,
                            itemBuilder: (context, index) {
                              final question = _quiz!.questions[index];
                              return _buildQuestionCard(question, index);
                            },
                          ),
                        ),
                        // Navigation Buttons
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              if (_currentQuestionIndex > 0)
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () {
                                      setState(() => _currentQuestionIndex--);
                                    },
                                    child: const Text('Previous'),
                                  ),
                                ),
                              if (_currentQuestionIndex > 0)
                                const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _currentQuestionIndex ==
                                          _quiz!.questions.length - 1
                                      ? _submitQuiz
                                      : () {
                                          setState(
                                              () => _currentQuestionIndex++);
                                        },
                                  child: Text(_currentQuestionIndex ==
                                          _quiz!.questions.length - 1
                                      ? 'Submit'
                                      : 'Next'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
    );
  }

  Widget _buildQuestionCard(QuizQuestion question, int index) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question Number
          Text(
            'Question ${index + 1} of ${_quiz!.questions.length}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 12),

          // Question Title
          Text(
            question.question,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),

          // Answer Options
          Expanded(
            child: ListView.builder(
              itemCount: question.options.length,
              itemBuilder: (context, optionIndex) {
                final option = question.options[optionIndex];
                final isSelected = _answers[index] == option;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Material(
                    child: InkWell(
                      onTap: () {
                        setState(
                          () => _answers[index] = option,
                        );
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : Colors.grey[300]!,
                            width: isSelected ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          color: isSelected
                              ? AppColors.primary.withOpacity(0.05)
                              : Colors.transparent,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : Colors.grey[400]!,
                                  width: 2,
                                ),
                                color: isSelected
                                    ? AppColors.primary
                                    : Colors.transparent,
                              ),
                              child: isSelected
                                  ? const Icon(
                                      Icons.check,
                                      size: 16,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                option,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
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
        ],
      ),
    );
  }
}
