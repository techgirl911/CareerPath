class AcademicResult {
  final String id;
  final String studentId;
  final String subjectName;
  final double grade;
  final String letterGrade;
  final int semester;
  final int academicYear;
  final double creditHours;
  final DateTime submittedAt;

  AcademicResult({
    required this.id,
    required this.studentId,
    required this.subjectName,
    required this.grade,
    required this.letterGrade,
    required this.semester,
    required this.academicYear,
    required this.creditHours,
    required this.submittedAt,
  });

  factory AcademicResult.fromJson(Map<String, dynamic> json) {
    return AcademicResult(
      id: json['id'] ?? '',
      studentId: json['studentId'] ?? '',
      subjectName: json['subjectName'] ?? '',
      grade: json['grade']?.toDouble() ?? 0.0,
      letterGrade: json['letterGrade'] ?? 'F',
      semester: json['semester']?.toInt() ?? 1,
      academicYear: json['academicYear']?.toInt() ?? DateTime.now().year,
      creditHours: json['creditHours']?.toDouble() ?? 0.0,
      submittedAt: json['submittedAt'] != null
          ? DateTime.parse(json['submittedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'subjectName': subjectName,
      'grade': grade,
      'letterGrade': letterGrade,
      'semester': semester,
      'academicYear': academicYear,
      'creditHours': creditHours,
      'submittedAt': submittedAt.toIso8601String(),
    };
  }
}

class StudentAcademicProfile {
  final String id;
  final String studentId;
  final double overallGPA;
  final double currentSemesterGPA;
  final List<AcademicResult> results;
  final List<String> strongSubjects;
  final List<String> needsImprovement;
  final DateTime lastUpdated;

  StudentAcademicProfile({
    required this.id,
    required this.studentId,
    required this.overallGPA,
    required this.currentSemesterGPA,
    required this.results,
    required this.strongSubjects,
    required this.needsImprovement,
    required this.lastUpdated,
  });

  factory StudentAcademicProfile.fromJson(Map<String, dynamic> json) {
    return StudentAcademicProfile(
      id: json['id'] ?? '',
      studentId: json['studentId'] ?? '',
      overallGPA: json['overallGPA']?.toDouble() ?? 0.0,
      currentSemesterGPA: json['currentSemesterGPA']?.toDouble() ?? 0.0,
      results: json['results'] != null
          ? (json['results'] as List)
              .map((r) => AcademicResult.fromJson(r))
              .toList()
          : [],
      strongSubjects: json['strongSubjects'] != null
          ? List<String>.from(json['strongSubjects'])
          : [],
      needsImprovement: json['needsImprovement'] != null
          ? List<String>.from(json['needsImprovement'])
          : [],
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'overallGPA': overallGPA,
      'currentSemesterGPA': currentSemesterGPA,
      'results': results.map((r) => r.toJson()).toList(),
      'strongSubjects': strongSubjects,
      'needsImprovement': needsImprovement,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }
}

class DocumentUpload {
  final String id;
  final String studentId;
  final String documentType;
  final String fileName;
  final String filePath;
  final String fileUrl;
  final double fileSizeKB;
  final DateTime uploadedAt;
  final bool isVerified;
  final String? notes;

  DocumentUpload({
    required this.id,
    required this.studentId,
    required this.documentType,
    required this.fileName,
    required this.filePath,
    required this.fileUrl,
    required this.fileSizeKB,
    required this.uploadedAt,
    required this.isVerified,
    this.notes,
  });

  factory DocumentUpload.fromJson(Map<String, dynamic> json) {
    return DocumentUpload(
      id: json['id'] ?? '',
      studentId: json['studentId'] ?? '',
      documentType: json['documentType'] ?? '',
      fileName: json['fileName'] ?? '',
      filePath: json['filePath'] ?? '',
      fileUrl: json['fileUrl'] ?? '',
      fileSizeKB: json['fileSizeKB']?.toDouble() ?? 0.0,
      uploadedAt: json['uploadedAt'] != null
          ? DateTime.parse(json['uploadedAt'])
          : DateTime.now(),
      isVerified: json['isVerified'] ?? false,
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'documentType': documentType,
      'fileName': fileName,
      'filePath': filePath,
      'fileUrl': fileUrl,
      'fileSizeKB': fileSizeKB,
      'uploadedAt': uploadedAt.toIso8601String(),
      'isVerified': isVerified,
      'notes': notes,
    };
  }
}
