class AcademicResult {
  final String id;
  final String studentId;
  final String subjectName;
  final double grade;
  final String semester;
  final DateTime createdAt;

  AcademicResult({
    required this.id,
    required this.studentId,
    required this.subjectName,
    required this.grade,
    required this.semester,
    required this.createdAt,
  });

  factory AcademicResult.fromJson(Map<String, dynamic> json) {
    return AcademicResult(
      id: json['id'] ?? '',
      studentId: json['studentId'] ?? '',
      subjectName: json['subjectName'] ?? 'Unknown Subject',
      grade: (json['grade'] as num?)?.toDouble() ?? 0.0,
      semester: json['semester'] ?? 'Fall 2024',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'studentId': studentId,
        'subjectName': subjectName,
        'grade': grade,
        'semester': semester,
        'createdAt': createdAt.toIso8601String(),
      };
}

class StudentAcademicProfile {
  final String id;
  final String studentId;
  final double overallGPA;
  final double currentSemesterGPA;
  final List<AcademicResult> results;
  final List<String> strongSubjects;
  final List<String> needsImprovement;

  StudentAcademicProfile({
    required this.id,
    required this.studentId,
    required this.overallGPA,
    required this.currentSemesterGPA,
    required this.results,
    required this.strongSubjects,
    required this.needsImprovement,
  });

  factory StudentAcademicProfile.fromJson(Map<String, dynamic> json) {
    return StudentAcademicProfile(
      id: json['id'] ?? '',
      studentId: json['studentId'] ?? '',
      overallGPA: (json['overallGPA'] as num?)?.toDouble() ?? 0.0,
      currentSemesterGPA:
          (json['currentSemesterGPA'] as num?)?.toDouble() ?? 0.0,
      results: (json['results'] as List?)
              ?.map((item) => AcademicResult.fromJson(item))
              .toList() ??
          [],
      strongSubjects: List<String>.from(json['strongSubjects'] ?? []),
      needsImprovement: List<String>.from(json['needsImprovement'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'studentId': studentId,
        'overallGPA': overallGPA,
        'currentSemesterGPA': currentSemesterGPA,
        'results': results.map((r) => r.toJson()).toList(),
        'strongSubjects': strongSubjects,
        'needsImprovement': needsImprovement,
      };
}

class DocumentUpload {
  final String id;
  final String studentId;
  final String documentType;
  final String filePath;
  final DateTime uploadedAt;
  final String status;

  DocumentUpload({
    required this.id,
    required this.studentId,
    required this.documentType,
    required this.filePath,
    required this.uploadedAt,
    required this.status,
  });

  factory DocumentUpload.fromJson(Map<String, dynamic> json) {
    return DocumentUpload(
      id: json['id'] ?? '',
      studentId: json['studentId'] ?? '',
      documentType: json['documentType'] ?? '',
      filePath: json['filePath'] ?? '',
      uploadedAt: json['uploadedAt'] != null
          ? DateTime.parse(json['uploadedAt'])
          : DateTime.now(),
      status: json['status'] ?? 'pending',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'studentId': studentId,
        'documentType': documentType,
        'filePath': filePath,
        'uploadedAt': uploadedAt.toIso8601String(),
        'status': status,
      };
}
