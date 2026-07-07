import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../services/quiz_service.dart';
import '../models/quiz_model.dart';

class QuizListScreen extends StatefulWidget {
  final String? studentId;

  const QuizListScreen({
    this.studentId,
    Key? key,
  }) : super(key: key);

  @override
  State<QuizListScreen> createState() => _QuizListScreenState();
}

class _QuizListScreenState extends State<QuizListScreen> {
  late QuizService _quizService;
  List<Quiz> _quizzes = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _quizService = QuizService();
    _loadQuizzes();
  }

  Future<void> _loadQuizzes() async {
    try {
      setState(() => _isLoading = true);
      final quizzes = await _quizService.getAllQuizzes();
      setState(() {
        _quizzes = quizzes;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading quizzes: $e');
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Quizzes'),
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
                      const Text('Error Loading Quizzes'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadQuizzes,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _quizzes.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.quiz_outlined,
                              size: 60,
                              color: AppColors.primary.withOpacity(0.5)),
                          const SizedBox(height: 16),
                          const Text('No Quizzes Available'),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _quizzes.length,
                      itemBuilder: (context, index) {
                        final quiz = _quizzes[index];
                        return Card(
                          child: ListTile(
                            leading: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(Icons.quiz, color: AppColors.primary),
                            ),
                            title: Text(quiz.title),
                            subtitle:
                                Text('${quiz.questions.length} questions'),
                            trailing:
                                const Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: () {
                              Navigator.pop(context, quiz);
                            },
                          ),
                        );
                      },
                    ),
    );
  }
}
