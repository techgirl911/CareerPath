import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../services/admin_service.dart';

class AdminDashboard extends StatefulWidget {
  final String? adminId;
  final String? adminName;

  const AdminDashboard({
    this.adminId,
    this.adminName,
    Key? key,
  }) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late AdminService _adminService;

  Map<String, dynamic> _dashboardStats = {};
  List<Map<String, dynamic>> _users = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _adminService = AdminService();
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      setState(() => _isLoading = true);

      final stats = await _adminService.getAdminDashboard();
      final users = await _adminService.getAllUsers();

      setState(() {
        _dashboardStats = stats['statistics'] ?? {};
        _users = users;
        _isLoading = false;
      });
    } catch (e) {
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
        title: const Text('Admin Dashboard'),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Users'),
            Tab(text: 'Careers'),
            Tab(text: 'Quizzes'),
          ],
        ),
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
              : TabBarView(
                  controller: _tabController,
                  children: [
                    // Overview Tab
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'System Statistics',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          GridView.count(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              _StatCard(
                                label: 'Total Students',
                                value: '0',
                                icon: Icons.person,
                                color: AppColors.studentColor,
                              ),
                              _StatCard(
                                label: 'Total Parents',
                                value: '0',
                                icon: Icons.family_restroom,
                                color: AppColors.parentColor,
                              ),
                              _StatCard(
                                label: 'Total Careers',
                                value: _dashboardStats['totalCareers']
                                        ?.toString() ??
                                    '0',
                                icon: Icons.work,
                                color: AppColors.primary,
                              ),
                              _StatCard(
                                label: 'Total Quizzes',
                                value: _dashboardStats['totalQuizzes']
                                        ?.toString() ??
                                    '0',
                                icon: Icons.quiz,
                                color: AppColors.success,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Users Tab
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Manage Users (${_users.length})',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          if (_users.isEmpty)
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Text(
                                  'No users found',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            )
                          else
                            ..._users.map((user) => Card(
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      child: Text(user['fullName']
                                          .toString()
                                          .substring(0, 1)),
                                    ),
                                    title: Text(user['fullName'] ?? 'Unknown'),
                                    subtitle: Text(user['email'] ?? 'N/A'),
                                    trailing: Text(user['role'] ?? 'Unknown'),
                                  ),
                                )),
                        ],
                      ),
                    ),
                    // Careers Tab
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.work,
                              size: 50,
                              color: AppColors.primary.withOpacity(0.5),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Career management coming soon',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Quizzes Tab
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.quiz,
                              size: 50,
                              color: AppColors.success.withOpacity(0.5),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Quiz management coming soon',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
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
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
