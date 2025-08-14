class DprModel {
  final String id;
  final String name;
  final String? date;

  DprModel({
    required this.id,
    required this.name,
    this.date,
  });

  factory DprModel.fromJson(Map<String, dynamic> json) {
    return DprModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "name": name,
      "date": date,
    };
  }
}
