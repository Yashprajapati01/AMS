class Professor {
  final int id;
  final String professorUniqueId;
  final String name;
  final int departmentId;

  Professor({
    required this.id,
    required this.professorUniqueId,
    required this.name,
    required this.departmentId,
  });

  factory Professor.fromJson(Map<String, dynamic> json) {
    return Professor(
      id: json['professor_id'], // Ensure this matches the API response
      professorUniqueId: json['professor_unique_id'],
      name: json['name'],
      departmentId: json['department_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'professor_id': id,
      'professor_unique_id': professorUniqueId,
      'name': name,
      'department_id': departmentId,
    };
  }
}
