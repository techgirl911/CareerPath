class User {
  final String id;
  final String email;
  final String fullName;
  final String role;
  final String? profilePicture;
  final String? phone;
  final DateTime createdAt;
  final bool isActive;

  User({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
    this.profilePicture,
    this.phone,
    required this.createdAt,
    required this.isActive,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      fullName: json['fullName'] ?? '',
      role: json['role'] ?? 'student',
      profilePicture: json['profilePicture'],
      phone: json['phone'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'role': role,
      'profilePicture': profilePicture,
      'phone': phone,
      'createdAt': createdAt.toIso8601String(),
      'isActive': isActive,
    };
  }
}

class Student extends User {
  final String studentId;
  final String? schoolName;
  final String? grade;
  final List<String>? subjects;
  final double? gpa;

  Student({
    required super.id,
    required super.email,
    required super.fullName,
    required this.studentId,
    this.schoolName,
    this.grade,
    this.subjects,
    this.gpa,
    super.profilePicture,
    super.phone,
    required super.createdAt,
    required super.isActive,
  }) : super(role: 'student');

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      fullName: json['fullName'] ?? '',
      studentId: json['studentId'] ?? '',
      schoolName: json['schoolName'],
      grade: json['grade'],
      subjects:
          json['subjects'] != null ? List<String>.from(json['subjects']) : null,
      gpa: json['gpa']?.toDouble(),
      profilePicture: json['profilePicture'],
      phone: json['phone'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      isActive: json['isActive'] ?? true,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'studentId': studentId,
      'schoolName': schoolName,
      'grade': grade,
      'subjects': subjects,
      'gpa': gpa,
    };
  }
}

class Parent extends User {
  final String parentId;
  final String childId;
  final String relationship;

  Parent({
    required super.id,
    required super.email,
    required super.fullName,
    required this.parentId,
    required this.childId,
    required this.relationship,
    super.profilePicture,
    super.phone,
    required super.createdAt,
    required super.isActive,
  }) : super(role: 'parent');

  factory Parent.fromJson(Map<String, dynamic> json) {
    return Parent(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      fullName: json['fullName'] ?? '',
      parentId: json['parentId'] ?? '',
      childId: json['childId'] ?? '',
      relationship: json['relationship'] ?? '',
      profilePicture: json['profilePicture'],
      phone: json['phone'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      isActive: json['isActive'] ?? true,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'parentId': parentId,
      'childId': childId,
      'relationship': relationship,
    };
  }
}

class Admin extends User {
  final String adminId;
  final String? department;
  final List<String>? permissions;

  Admin({
    required super.id,
    required super.email,
    required super.fullName,
    required this.adminId,
    this.department,
    this.permissions,
    super.profilePicture,
    super.phone,
    required super.createdAt,
    required super.isActive,
  }) : super(role: 'admin');

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      fullName: json['fullName'] ?? '',
      adminId: json['adminId'] ?? '',
      department: json['department'],
      permissions: json['permissions'] != null
          ? List<String>.from(json['permissions'])
          : null,
      profilePicture: json['profilePicture'],
      phone: json['phone'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      isActive: json['isActive'] ?? true,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'adminId': adminId,
      'department': department,
      'permissions': permissions,
    };
  }
}
