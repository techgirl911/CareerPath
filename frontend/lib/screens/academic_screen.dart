import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../services/student_service.dart';
import '../models/academic_model.dart';

class AcademicScreen extends StatefulWidget {
  final String? studentId;

  const AcademicScreen({
    this.studentId,
    Key? key,
  }) : super(key: key);

  @override
  State<AcademicScreen> createState() => _AcademicScreenState();
}

class _AcademicScreenState extends State<AcademicScreen> {
  late StudentService _studentService;
  List<AcademicResult> _academicResults = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    print('=== AcademicScreen Init ===');
    print('studentId: ${widget.studentId}');
    _studentService = StudentService();
    _loadAcademicData();
  }

  Future<void> _loadAcademicData() async {
    try {
      print('Loading academic data...');
      setState(() => _isLoading = true);

      if (widget.studentId == null || widget.studentId!.isEmpty) {
        print('ERROR: Student ID is null/empty');
        setState(() {
          _isLoading = false;
          _error = 'No student ID provided';
        });
        return;
      }

      print('Calling getAcademicResults...');
      final results =
          await _studentService.getAcademicResults(widget.studentId!);

      print('Got ${results.length} academic results');

      setState(() {
        _academicResults = results;
        _isLoading = false;
        _error = null;
      });
    } catch (e) {
      print('ERROR: $e');
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  double _calculateGPA() {
    if (_academicResults.isEmpty) return 0.0;
    final sum =
        _academicResults.fold<double>(0, (prev, result) => prev + result.grade);
    return sum / _academicResults.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Academic Results'),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading academic data...'),
                ],
              ),
            )
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline,
                          size: 60, color: AppColors.error),
                      const SizedBox(height: 16),
                      const Text('Error Loading Data'),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          _error!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadAcademicData,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _academicResults.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.school_outlined,
                            size: 60,
                            color: AppColors.primary.withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          const Text('No Academic Results'),
                          const SizedBox(height: 8),
                          const Text('Upload your results to get started'),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // GPA Card
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Overall GPA',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: Colors.grey[600],
                                            ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        _calculateGPA().toStringAsFixed(2),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.primary,
                                            ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.primary.withOpacity(0.1),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${(_calculateGPA() / 4 * 100).toStringAsFixed(0)}%',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.copyWith(
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Subjects
                          Text(
                            'Subject Results (${_academicResults.length})',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          ..._academicResults
                              .map((result) =>
                                  _SubjectResultCard(result: result))
                              .toList(),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
    );
  }
}

class _SubjectResultCard extends StatelessWidget {
  final AcademicResult result;

  const _SubjectResultCard({required this.result});

  Color _getGradeColor(double grade) {
    if (grade >= 3.7) return AppColors.success;
    if (grade >= 3.0) return AppColors.primary;
    if (grade >= 2.0) return AppColors.warning;
    return AppColors.error;
  }

  String _getGradeLabel(double grade) {
    if (grade >= 3.7) return 'A';
    if (grade >= 3.3) return 'A-';
    if (grade >= 3.0) return 'B+';
    if (grade >= 2.7) return 'B';
    if (grade >= 2.3) return 'B-';
    if (grade >= 2.0) return 'C+';
    if (grade >= 1.7) return 'C';
    if (grade >= 1.3) return 'C-';
    if (grade >= 1.0) return 'D';
    return 'F';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _getGradeColor(result.grade).withOpacity(0.2),
                ),
                child: Center(
                  child: Text(
                    _getGradeLabel(result.grade),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _getGradeColor(result.grade),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.subjectName,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Grade: ${result.grade.toStringAsFixed(2)} • ${result.semester}',
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
      ),
    );
  }
}
