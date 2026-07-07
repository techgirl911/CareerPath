// ignore_for_file: unused_import
// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../app_colors.dart';
import '../services/student_service.dart';
import '../models/quiz_model.dart';
import '../models/career_model.dart';
import '../widgets/career_demand_chart.dart';
import '../screens/quiz_list_screen.dart';

class StudentDashboard extends StatefulWidget {
  final String? userName;
  final String? userEmail;
  final String? studentId;

  const StudentDashboard({
    super.key,
    this.userName,
    this.userEmail,
    this.studentId,
  });

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  late StudentService _studentService;
  List<CareerRecommendation> _recommendations = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    print('StudentDashboard loaded');
    print('StudentID: ${widget.studentId}');
    _studentService = StudentService();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() => _isLoading = true);

      if (widget.studentId != null && widget.studentId!.isNotEmpty) {
        final recommendations =
            await _studentService.getCareerRecommendations(widget.studentId!);

        print('Got ${recommendations.length} recommendations');

        setState(() {
          _recommendations = recommendations;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _error = 'Student ID not found';
        });
      }
    } catch (e) {
      print('Error loading data: $e');
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _handleLogout() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('/');
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleLogout,
          ),
        ],
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
                      const Text('Error Loading Data'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadData,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Welcome Card
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome, ${widget.userName ?? "Student"}!',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Continue your career exploration journey',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Metrics
                      Text(
                        'Your Progress',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Top Match',
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      _recommendations.isNotEmpty
                                          ? _recommendations.first.career.title
                                          : 'Pending',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Your GPA',
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '3.8',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            color: AppColors.success,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Career Recommendations
                      Text(
                        'Career Recommendations',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      if (_recommendations.isEmpty)
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Center(
                              child: Text(
                                'No recommendations yet',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ),
                        )
                      else
                        ..._recommendations.map((rec) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: AppColors.primary
                                              .withValues(alpha: 0.1),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Icon(Icons.trending_up,
                                            color: AppColors.primary),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              rec.career.title,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Match: ${rec.matchScore.toInt()}%',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )),
                      const SizedBox(height: 24),

                      // Demand Chart
                      if (_recommendations.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Market Demand',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 12),
                            CareerDemandChart(
                              careerData: _recommendations
                                  .map((rec) => CareerDemandData(
                                        careerName: rec.career.title,
                                        demandLevel: rec.matchScore
                                            .toInt()
                                            .clamp(0, 100),
                                      ))
                                  .toList(),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),

                      // Quick Actions
                      Text(
                        'Quick Actions',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.quiz),
                          label: const Text('Take a Quiz'),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                child: QuizListScreen(
                                  studentId: widget.studentId,
                                ),
                              ),
                            ).then((quiz) {
                              if (quiz != null && mounted && context.mounted) {
                                context.go(
                                  '/quiz?quizId=${quiz.id}&studentId=${widget.studentId}',
                                );
                              }
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.upload_file),
                          label: const Text('Upload Results'),
                          onPressed: () {
                            context.go(
                              '/upload?studentId=${widget.studentId}',
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Academic'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (index) {
          if (index == 0) {
            // Home
          } else if (index == 1) {
            // Academic
            context.push('/academic?studentId=${widget.studentId}');
          } else if (index == 2) {
            // Profile
            final encodedName = Uri.encodeComponent(widget.userName ?? 'User');
            final encodedEmail = Uri.encodeComponent(widget.userEmail ?? '');
            context.go(
              '/profile?studentId=${widget.studentId}&userName=$encodedName&userEmail=$encodedEmail',
            );
          }
        },
      ),
    );
  }
}
