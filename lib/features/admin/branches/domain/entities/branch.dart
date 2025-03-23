class Branch {
  final int id;
  final String name;
  final int programId;

  Branch({required this.id, required this.name, required this.programId});

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      id: json['branch_id'],
      name: json['branch_name'],
      programId: json['program_id'],
    );
  }
}
