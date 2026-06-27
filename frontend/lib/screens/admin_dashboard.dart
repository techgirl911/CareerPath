import 'package:flutter/material.dart';
import '../app_colors.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Tab Navigation
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _TabButton(
                  label: 'Overview',
                  isActive: _selectedTabIndex == 0,
                  onTap: () => setState(() => _selectedTabIndex = 0),
                ),
                const SizedBox(width: 12),
                _TabButton(
                  label: 'Students',
                  isActive: _selectedTabIndex == 1,
                  onTap: () => setState(() => _selectedTabIndex = 1),
                ),
                const SizedBox(width: 12),
                _TabButton(
                  label: 'Careers',
                  isActive: _selectedTabIndex == 2,
                  onTap: () => setState(() => _selectedTabIndex = 2),
                ),
                const SizedBox(width: 12),
                _TabButton(
                  label: 'Quizzes',
                  isActive: _selectedTabIndex == 3,
                  onTap: () => setState(() => _selectedTabIndex = 3),
                ),
              ],
            ),
          ),
          // Tab Content
          Expanded(
            child: IndexedStack(
              index: _selectedTabIndex,
              children: [
                _OverviewTab(),
                _StudentsTab(),
                _CareersTab(),
                _QuizzesTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: isActive ? AppColors.primary : Colors.transparent,
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.grey[600],
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Platform Statistics',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  label: 'Total Students',
                  value: '1,245',
                  icon: Icons.people,
                  color: AppColors.studentColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  label: 'Total Parents',
                  value: '892',
                  icon: Icons.family_restroom,
                  color: AppColors.parentColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  label: 'Active Careers',
                  value: '156',
                  icon: Icons.work,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  label: 'Quizzes',
                  value: '24',
                  icon: Icons.quiz,
                  color: AppColors.info,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StudentsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Students',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Add'),
                onPressed: () {
                  // TODO: Add student
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          _StudentListItem(
            name: 'Amara Osei',
            email: 'amara.osei@school.com',
            gpa: '3.8',
          ),
          _StudentListItem(
            name: 'Kwame Boateng',
            email: 'kwame.boateng@school.com',
            gpa: '3.5',
          ),
          _StudentListItem(
            name: 'Ama Mensah',
            email: 'ama.mensah@school.com',
            gpa: '3.9',
          ),
        ],
      ),
    );
  }
}

class _CareersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Careers',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Add'),
                onPressed: () {
                  // TODO: Add career
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          _CareerListItem(
            title: 'Data Science',
            demand: 'Very High',
            count: 45,
          ),
          _CareerListItem(
            title: 'Software Engineering',
            demand: 'High',
            count: 38,
          ),
          _CareerListItem(
            title: 'Biomedical Research',
            demand: 'Medium',
            count: 22,
          ),
        ],
      ),
    );
  }
}

class _QuizzesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Quizzes',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Add'),
                onPressed: () {
                  // TODO: Add quiz
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          _QuizListItem(
            title: '2024 Career Assessment',
            questions: 20,
            responses: 145,
          ),
          _QuizListItem(
            title: '2023 Aptitude Test',
            questions: 25,
            responses: 892,
          ),
          _QuizListItem(
            title: 'Interest Inventory',
            questions: 30,
            responses: 756,
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
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 12),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StudentListItem extends StatelessWidget {
  final String name;
  final String email;
  final String gpa;

  const _StudentListItem({
    required this.name,
    required this.email,
    required this.gpa,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          child: Text(name[0]),
        ),
        title: Text(name),
        subtitle: Text(email),
        trailing: Text('GPA: $gpa'),
      ),
    );
  }
}

class _CareerListItem extends StatelessWidget {
  final String title;
  final String demand;
  final int count;

  const _CareerListItem({
    required this.title,
    required this.demand,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.work),
        title: Text(title),
        subtitle: Text('Demand: $demand'),
        trailing: Text('$count matches'),
      ),
    );
  }
}

class _QuizListItem extends StatelessWidget {
  final String title;
  final int questions;
  final int responses;

  const _QuizListItem({
    required this.title,
    required this.questions,
    required this.responses,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.quiz),
        title: Text(title),
        subtitle: Text('$questions questions'),
        trailing: Text('$responses responses'),
      ),
    );
  }
}
