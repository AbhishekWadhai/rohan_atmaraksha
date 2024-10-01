import 'dart:convert';

class SpecificTraining {
  String id;
  ProjectName projectName;
  String date;
  String time;
  String topicName;
  dynamic typeOfTopic;
  List<String> attendees;
  String inducteesName;
  List<TradeType> tradeTypes;
  InstructionBy instructionBy;
  String documentaryEvidencePhoto;
  String traineeSignBy;
  List<String> trainingSignBy;
  String geotagging;
  String commentsBox;
  int v;

  SpecificTraining({
    required this.id,
    required this.projectName,
    required this.date,
    required this.time,
    required this.topicName,
    required this.typeOfTopic,
    required this.attendees,
    required this.inducteesName,
    required this.tradeTypes,
    required this.instructionBy,
    required this.documentaryEvidencePhoto,
    required this.traineeSignBy,
    required this.trainingSignBy,
    required this.geotagging,
    required this.commentsBox,
    required this.v,
  });

  factory SpecificTraining.fromRawJson(String str) =>
      SpecificTraining.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SpecificTraining.fromJson(Map<String, dynamic> json) =>
      SpecificTraining(
        id: json["_id"],
        projectName: ProjectName.fromJson(json["projectName"]),
        date: json["date"],
        time: json["time"],
        topicName: json["topicName"],
        typeOfTopic: json["typeOfTopic"],
        attendees: List<String>.from(json["attendees"].map((x) => x)),
        inducteesName: json["inducteesName"],
        tradeTypes: List<TradeType>.from(
            json["tradeTypes"].map((x) => TradeType.fromJson(x))),
        instructionBy: InstructionBy.fromJson(json["instructionBy"]),
        documentaryEvidencePhoto: json["documentaryEvidencePhoto"],
        traineeSignBy: json["traineeSignBy"],
        trainingSignBy: List<String>.from(json["trainingSignBy"].map((x) => x)),
        geotagging: json["geotagging"],
        commentsBox: json["commentsBox"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "projectName": projectName.toJson(),
        "date": date,
        "time": time,
        "topicName": topicName,
        "typeOfTopic": typeOfTopic,
        "attendees": List<dynamic>.from(attendees.map((x) => x)),
        "inducteesName": inducteesName,
        "tradeTypes": List<dynamic>.from(tradeTypes.map((x) => x.toJson())),
        "instructionBy": instructionBy.toJson(),
        "documentaryEvidencePhoto": documentaryEvidencePhoto,
        "traineeSignBy": traineeSignBy,
        "trainingSignBy": List<dynamic>.from(trainingSignBy.map((x) => x)),
        "geotagging": geotagging,
        "commentsBox": commentsBox,
        "__v": v,
      };
}

class InstructionBy {
  String id;
  String userId;
  String name;
  String photo;
  String emailId;
  String password;
  String phone;
  DateTime createdAt;
  DateTime updatedAt;
  bool isActive;
  int v;

  InstructionBy({
    required this.id,
    required this.userId,
    required this.name,
    required this.photo,
    required this.emailId,
    required this.password,
    required this.phone,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
    required this.v,
  });

  factory InstructionBy.fromRawJson(String str) =>
      InstructionBy.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory InstructionBy.fromJson(Map<String, dynamic> json) => InstructionBy(
        id: json["_id"],
        userId: json["userId"],
        name: json["name"],
        photo: json["photo"],
        emailId: json["emailId"],
        password: json["password"],
        phone: json["phone"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        isActive: json["isActive"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId,
        "name": name,
        "photo": photo,
        "emailId": emailId,
        "password": password,
        "phone": phone,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "isActive": isActive,
        "__v": v,
      };
}

class ProjectName {
  String id;
  String projectId;
  String projectName;
  String siteLocation;
  DateTime startDate;
  DateTime endDate;
  String status;
  String description;
  String company;
  int v;

  ProjectName({
    required this.id,
    required this.projectId,
    required this.projectName,
    required this.siteLocation,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.description,
    required this.company,
    required this.v,
  });

  factory ProjectName.fromRawJson(String str) =>
      ProjectName.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProjectName.fromJson(Map<String, dynamic> json) => ProjectName(
        id: json["_id"],
        projectId: json["projectId"],
        projectName: json["projectName"],
        siteLocation: json["siteLocation"],
        startDate: DateTime.parse(json["startDate"]),
        endDate: DateTime.parse(json["endDate"]),
        status: json["status"],
        description: json["description"],
        company: json["company"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "projectId": projectId,
        "projectName": projectName,
        "siteLocation": siteLocation,
        "startDate": startDate.toIso8601String(),
        "endDate": endDate.toIso8601String(),
        "status": status,
        "description": description,
        "company": company,
        "__v": v,
      };
}

class TradeType {
  String id;
  String tradeTypes;
  int v;

  TradeType({
    required this.id,
    required this.tradeTypes,
    required this.v,
  });

  factory TradeType.fromRawJson(String str) =>
      TradeType.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TradeType.fromJson(Map<String, dynamic> json) => TradeType(
        id: json["_id"],
        tradeTypes: json["tradeTypes"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "tradeTypes": tradeTypes,
        "__v": v,
      };
}
