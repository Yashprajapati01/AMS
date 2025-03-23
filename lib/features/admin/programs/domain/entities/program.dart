class Program {
  final int id;
  final String name;
  final int batchId;

  Program({required this.id, required this.name, required this.batchId});

  factory Program.fromJson(Map<String, dynamic> json) {
    return Program(
      id: json['program_id'],
      name: json['program_name'],
      batchId: json['batch_id'],
    );
  }
}
