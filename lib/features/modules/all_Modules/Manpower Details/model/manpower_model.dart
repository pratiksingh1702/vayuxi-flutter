class ManpowerModel {
  final String id;
  final String fullName;
  final String designation;
  final String employeeCode;
  final String? phoneNumber;
  final String? panNumber;
  final String? dateOfBirth; // Nullable
  final String? dateOfJoining; // Nullable
  final String? bankAccountNumber;
  final String? ifscCode;
  final String? epfNumber;
  final String? uanNumber;
  final String? esicNumber;
  final String payBasics;
  final double salary;
  final String? remarks;
  final bool isDeleted;
  final String company;
  final bool isLeft;
  final String? reason;
  final String type;
  final String createdAt;
  final String updatedAt;

  ManpowerModel({
    required this.id,
    required this.fullName,
    required this.designation,
    required this.employeeCode,
    this.phoneNumber,
    this.panNumber,
    this.dateOfBirth,
    this.dateOfJoining,
    this.bankAccountNumber,
    this.ifscCode,
    this.epfNumber,
    this.uanNumber,
    this.esicNumber,
    required this.payBasics,
    required this.salary,
    this.remarks,
    required this.isDeleted,
    required this.company,
    required this.isLeft,
    this.reason,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });

  /// From JSON
  factory ManpowerModel.fromJson(Map<String, dynamic> json) {
    return ManpowerModel(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      designation: json['designation'] ?? '',
      employeeCode: json['employeeCode'] ?? '',
      phoneNumber: json['phoneNumber'],
      panNumber: json['panNumber'],
      dateOfBirth: json['dateOfBirth'],
      dateOfJoining: json['dateOfJoining'],
      bankAccountNumber: json['bankAccountNumber'],
      ifscCode: json['ifscCode'],
      epfNumber: json['epfNumber'],
      uanNumber: json['uanNumber'],
      esicNumber: json['esicNumber'],
      payBasics: json['payBasics'] ?? '',
      salary: (json['salary'] is int)
          ? (json['salary'] as int).toDouble()
          : (json['salary'] ?? 0.0).toDouble(),
      remarks: json['remarks'],
      isDeleted: json['isDeleted'] ?? false,
      company: json['company'] ?? '',
      isLeft: json['isLeft'] ?? false,
      reason: json['reason'],
      type: json['type'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  /// To JSON
  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "fullName": fullName,
      "designation": designation,
      "employeeCode": employeeCode,
      "phoneNumber": phoneNumber,
      "panNumber": panNumber,
      "dateOfBirth": dateOfBirth,
      "dateOfJoining": dateOfJoining,
      "bankAccountNumber": bankAccountNumber,
      "ifscCode": ifscCode,
      "epfNumber": epfNumber,
      "uanNumber": uanNumber,
      "esicNumber": esicNumber,
      "payBasics": payBasics,
      "salary": salary,
      "remarks": remarks,
      "isDeleted": isDeleted,
      "company": company,
      "isLeft": isLeft,
      "reason": reason,
      "type": type,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
    };
  }
}
