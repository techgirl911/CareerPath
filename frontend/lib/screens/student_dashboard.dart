import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../app_colors.dart';
import '../widgets/career_demand_chart.dart';
import '../services/student_service.dart';
import '../models/career_model.dart';

class StudentDashboard extends StatefulWidget {
  final String? userName;
  final String? userEmail;
  final String? studentId;

  const StudentDashboard({
    this.userName,
    this.userEmail,
    this.studentId,
    Key? key,
  }) : super(key: key);

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
    _studentService = StudentService();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() => _isLoading = true);

      if (widget.studentId != null) {
        final recommendations =
            await _studentService.getCareerRecommendations(widget.studentId!);

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
                      Text('Error: $_error'),
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
                      // Welcome Section
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome, ${widget.userName ?? "Student"}!',
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Continue your career exploration journey',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Colors.grey[600],
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Key Metrics
                      Text(
                        'Your Progress',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _MetricCard(
                              label: 'Top Match',
                              value: _recommendations.isNotEmpty
                                  ? _recommendations.first.career.title
                                  : 'Pending',
                              percentage: _recommendations.isNotEmpty
                                  ? _recommendations.first.matchScore
                                  : 0,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _MetricCard(
                              label: 'Your GPA',
                              value: '3.8',
                              percentage: 95,
                              color: AppColors.success,
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
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  size: 40,
                                  color: AppColors.primary.withOpacity(0.5),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'No recommendations yet',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        ..._recommendations.map((rec) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _CareerCard(
                                title: rec.career.title,
                                matchScore: rec.matchScore.toInt(),
                                demand: rec.confidence,
                              ),
                            )),
                      const SizedBox(height: 24),

                      // Demand Chart
                      if (_recommendations.isNotEmpty)
                        CareerDemandChart(
                          careerData: _recommendations
                              .map((rec) => CareerDemandData(
                                    careerName: rec.career.title,
                                    demandLevel:
                                        rec.matchScore.toInt().clamp(0, 100),
                                  ))
                              .toList(),
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
          final encodedName = Uri.encodeComponent(widget.userName ?? 'User');
          final encodedEmail = Uri.encodeComponent(widget.userEmail ?? '');

          print('Bottom Nav tapped: $index');
          print('StudentID: ${widget.studentId}');

          if (index == 0) {
            print('Home selected');
          } else if (index == 1) {
            print('going to academic');
            final route = '/academic?studentId=${widget.studentId}';
            print('navigation to: $route');
            context.go(route);
          } else if (index == 2) {
            print('Going to Profile');
            final route =
                '/profile?studentId=${widget.studentId}&userName=$encodedName&userEmail=$encodedEmail';
            print('Navigating to: $route');
            context.go(route);
          }
        },
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final double percentage;
  final Color color;

  const _MetricCard({
    required this.label,
    required this.value,
    required this.percentage,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (percentage / 100).clamp(0, 1),
                minHeight: 6,
                backgroundColor: color.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CareerCard extends StatelessWidget {
  final String title;
  final int matchScore;
  final String demand;

  const _CareerCard({
    required this.title,
    required this.matchScore,
    required this.demand,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.trending_up, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Match: $matchScore% • $demand',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
