class Batch {
  final int id;
  final String name;
  final int year;

  Batch({required this.id, required this.name, required this.year});

  factory Batch.fromJson(Map<String, dynamic> json) {
    return Batch(
      id: json['batch_id'],
      name: json['batch_name'],
      year: json['year'],
    );
  }
}
