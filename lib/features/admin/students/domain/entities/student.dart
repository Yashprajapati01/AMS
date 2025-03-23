class Student {
  final int id;
  final String username; // Student's display name
  final String rollNo;   // Unique roll number
  final int branchId;

  Student({
    required this.id,
    required this.username,
    required this.rollNo,
    required this.branchId,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['student_id'],
      username: json['username'] ?? '',
      rollNo: json['roll_no'] ?? '',
      branchId: json['branch_id'] ?? 0,
    );
  }
}
