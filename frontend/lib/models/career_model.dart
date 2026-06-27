class Career {
  final String id;
  final String title;
  final String description;
  final String? salaryRange;
  final List<String>? requiredSkills;
  final List<String>? subjects;
  final int? demandIndex;
  final String? demandTrend;
  final List<String>? jobResponsibilities;
  final DateTime? createdAt;

  Career({
    required this.id,
    required this.title,
    required this.description,
    this.salaryRange,
    this.requiredSkills,
    this.subjects,
    this.demandIndex,
    this.demandTrend,
    this.jobResponsibilities,
    this.createdAt,
  });

  factory Career.fromJson(Map<String, dynamic> json) {
    return Career(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      salaryRange: json['salaryRange'],
      requiredSkills: json['requiredSkills'] != null
          ? List<String>.from(json['requiredSkills'])
          : null,
      subjects:
          json['subjects'] != null ? List<String>.from(json['subjects']) : null,
      demandIndex: json['demandIndex']?.toInt(),
      demandTrend: json['demandTrend'],
      jobResponsibilities: json['jobResponsibilities'] != null
          ? List<String>.from(json['jobResponsibilities'])
          : null,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'salaryRange': salaryRange,
      'requiredSkills': requiredSkills,
      'subjects': subjects,
      'demandIndex': demandIndex,
      'demandTrend': demandTrend,
      'jobResponsibilities': jobResponsibilities,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}

class CareerRecommendation {
  final String id;
  final String studentId;
  final String careerId;
  final Career career;
  final double matchScore;
  final String confidence;
  final List<String>? strengths;
  final List<String>? areasForImprovement;
  final DateTime createdAt;
  final DateTime? updatedAt;

  CareerRecommendation({
    required this.id,
    required this.studentId,
    required this.careerId,
    required this.career,
    required this.matchScore,
    required this.confidence,
    this.strengths,
    this.areasForImprovement,
    required this.createdAt,
    this.updatedAt,
  });

  factory CareerRecommendation.fromJson(Map<String, dynamic> json) {
    return CareerRecommendation(
      id: json['id'] ?? '',
      studentId: json['studentId'] ?? '',
      careerId: json['careerId'] ?? '',
      career: Career.fromJson(json['career'] ?? {}),
      matchScore: json['matchScore']?.toDouble() ?? 0.0,
      confidence: json['confidence'] ?? 'medium',
      strengths: json['strengths'] != null
          ? List<String>.from(json['strengths'])
          : null,
      areasForImprovement: json['areasForImprovement'] != null
          ? List<String>.from(json['areasForImprovement'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'careerId': careerId,
      'career': career.toJson(),
      'matchScore': matchScore,
      'confidence': confidence,
      'strengths': strengths,
      'areasForImprovement': areasForImprovement,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

class MarketDemand {
  final String id;
  final String careerId;
  final int demandScore;
  final String trend;
  final int jobOpenings;
  final double averageSalary;
  final String region;
  final DateTime lastUpdated;

  MarketDemand({
    required this.id,
    required this.careerId,
    required this.demandScore,
    required this.trend,
    required this.jobOpenings,
    required this.averageSalary,
    required this.region,
    required this.lastUpdated,
  });

  factory MarketDemand.fromJson(Map<String, dynamic> json) {
    return MarketDemand(
      id: json['id'] ?? '',
      careerId: json['careerId'] ?? '',
      demandScore: json['demandScore']?.toInt() ?? 0,
      trend: json['trend'] ?? 'stable',
      jobOpenings: json['jobOpenings']?.toInt() ?? 0,
      averageSalary: json['averageSalary']?.toDouble() ?? 0.0,
      region: json['region'] ?? 'Global',
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'careerId': careerId,
      'demandScore': demandScore,
      'trend': trend,
      'jobOpenings': jobOpenings,
      'averageSalary': averageSalary,
      'region': region,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }
}
