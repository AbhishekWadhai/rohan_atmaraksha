class Project {
  String id;
  String projectId;
  String projectName;
  String siteLocation;
  DateTime startDate;
  DateTime endDate;
  String status;
  String description;
  String company;

  Project({
    required this.id,
    required this.projectId,
    required this.projectName,
    required this.siteLocation,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.description,
    required this.company,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['_id'],
      projectId: json['projectId'],
      projectName: json['projectName'],
      siteLocation: json['siteLocation'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      status: json['status'],
      description: json['description'],
      company: json['company'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'projectId': projectId,
      'projectName': projectName,
      'siteLocation': siteLocation,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'status': status,
      'description': description,
      'company': company,
    };
  }
}
