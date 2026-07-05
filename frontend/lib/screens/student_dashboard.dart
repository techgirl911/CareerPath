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
    print('StudentDashboard Init');
    print('StudentID: ${widget.studentId}');
    print('UserName: ${widget.userName}');
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: Colors.grey[600],
                                          ),
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
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primary,
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: Colors.grey[600],
                                          ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '3.8',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.success,
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

                      // Recommendations
                      Text(
                        'Career Recommendations',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      if (_recommendations.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              'No recommendations yet',
                              style: Theme.of(context).textTheme.bodyMedium,
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
                                              .withOpacity(0.1),
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
                                                  .bodySmall
                                                  ?.copyWith(
                                                    color: Colors.grey[600],
                                                  ),
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

                      // Chart
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
          print('Bottom nav tapped: $index');

          final encodedName = Uri.encodeComponent(widget.userName ?? 'User');
          final encodedEmail = Uri.encodeComponent(widget.userEmail ?? '');

          if (index == 0) {
            // Home - stay here
            print('Home selected - staying on dashboard');
          } else if (index == 1) {
            // Academic
            print(
                'Academic selected - navigating with studentId: ${widget.studentId}');
            final route = '/academic?studentId=${widget.studentId}';
            print('Route: $route');
            context.go(route);
          } else if (index == 2) {
            // Profile
            print(
                'Profile selected - navigating with studentId: ${widget.studentId}');
            final route =
                '/profile?studentId=${widget.studentId}&userName=$encodedName&userEmail=$encodedEmail';
            print('Route: $route');
            context.go(route);
          }
        },
      ),
    );
  }
}
