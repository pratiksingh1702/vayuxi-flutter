import '../../Manpower Details/model/manpower_model.dart';


class TeamModel {
  final String id;
  final String teamName;
  final ManpowerModel? teamLead;
  final List<ManpowerModel> teamMembers;
  final String company;
  final bool isDeleted;
  final String type;
  final String? createdAt;
  final String? updatedAt;

  TeamModel({
    required this.id,
    required this.teamName,
    this.teamLead,
    required this.teamMembers,
    required this.company,
    required this.isDeleted,
     required this.type,
    this.createdAt,
    this.updatedAt,
  });

  factory TeamModel.fromJson(Map<String, dynamic> json) {
    return TeamModel(
      id: json['_id'] ?? '',
      teamName: json['teamName'] ?? '',
      teamLead: json['teamLead'] != null ? ManpowerModel.fromJson(json['teamLead']) : null,
      teamMembers: (json['teamMembers'] as List<dynamic>? ?? [])
          .map((e) => ManpowerModel.fromJson(e))
          .toList(),
      company: json['company'] ?? '',
      isDeleted: json['isDeleted'] ?? false,
      type: json['type'] ?? '',
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'teamName': teamName,
      'teamLead': teamLead?.toJson(),
      'teamMembers': teamMembers.map((e) => e.toJson()).toList(),
      'company': company,
      'isDeleted': isDeleted,
      'type': type,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
