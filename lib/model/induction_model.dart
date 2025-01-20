import 'dart:convert';

import 'projects_model.dart';

class Induction {
  String id;
  Project project;
  String date;
  String time;
  String inductees;
  String inducteesName;
  List<TradeType> tradeTypes;
  String subContractorName;
  TypeOfTopic typeOfTopic;
  String documentaryEvidencePhoto;
  String anyOthers;
  Createdby instructionBy;
  String inducteeSignBy;
  String inductedSignBy;
  String geotagging;
  Createdby createdby;
  String createdAt;
  int v;

  Induction({
    required this.id,
    required this.project,
    required this.date,
    required this.time,
    required this.inductees,
    required this.inducteesName,
    required this.tradeTypes,
    required this.subContractorName,
    required this.typeOfTopic,
    required this.documentaryEvidencePhoto,
    required this.anyOthers,
    required this.instructionBy,
    required this.inducteeSignBy,
    required this.inductedSignBy,
    required this.geotagging,
    required this.createdby,
    required this.createdAt,
    required this.v,
  });

  factory Induction.fromRawJson(String str) =>
      Induction.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Induction.fromJson(Map<String, dynamic> json) => Induction(
        id: json["_id"],
        project: Project.fromJson(json["project"]),
        date: json["date"],
        time: json["time"],
        inductees: json["inductees"],
        inducteesName: json["inducteesName"],
        tradeTypes: List<TradeType>.from(
            json["tradeTypes"].map((x) => TradeType.fromJson(x))),
        subContractorName: json["subContractorName"],
        typeOfTopic: TypeOfTopic.fromJson(json["typeOfTopic"]),
        documentaryEvidencePhoto: json["documentaryEvidencePhoto"],
        anyOthers: json["anyOthers"],
        instructionBy: Createdby.fromJson(json["instructionBy"]),
        inducteeSignBy: json["inducteeSignBy"],
        inductedSignBy: json["inductedSignBy"],
        geotagging: json["geotagging"],
        createdby: Createdby.fromJson(json["createdby"]),
        createdAt: json["createdAt"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "project": project.toJson(),
        "date": date,
        "time": time,
        "inductees": inductees,
        "inducteesName": inducteesName,
        "tradeTypes": List<dynamic>.from(tradeTypes.map((x) => x.toJson())),
        "subContractorName": subContractorName,
        "typeOfTopic": typeOfTopic.toJson(),
        "documentaryEvidencePhoto": documentaryEvidencePhoto,
        "anyOthers": anyOthers,
        "instructionBy": instructionBy.toJson(),
        "inducteeSignBy": inducteeSignBy,
        "inductedSignBy": inductedSignBy,
        "geotagging": geotagging,
        "createdby": createdby.toJson(),
        "createdAt": createdAt,
        "__v": v,
      };
}

class Createdby {
  String id;
  String userId;
  String name;
  String role;
  String emailId;
  String password;
  String phone;
  String address;
  bool isActive;
  String project;
  String createdAt;
  String updatedAt;
  int v;

  Createdby({
    required this.id,
    required this.userId,
    required this.name,
    required this.role,
    required this.emailId,
    required this.password,
    required this.phone,
    required this.address,
    required this.isActive,
    required this.project,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory Createdby.fromRawJson(String str) =>
      Createdby.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Createdby.fromJson(Map<String, dynamic> json) => Createdby(
        id: json["_id"],
        userId: json["userId"],
        name: json["name"],
        role: json["role"],
        emailId: json["emailId"],
        password: json["password"],
        phone: json["phone"],
        address: json["address"],
        isActive: json["isActive"],
        project: json["project"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId,
        "name": name,
        "role": role,
        "emailId": emailId,
        "password": password,
        "phone": phone,
        "address": address,
        "isActive": isActive,
        "project": project,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "__v": v,
      };
}

// class Project {
//     String id;
//     String projectId;
//     String projectName;
//     String siteLocation;
//     String startDate;
//     String endDate;
//     String status;
//     String description;
//     String company;
//     int v;

//     Project({
//         required this.id,
//         required this.projectId,
//         required this.projectName,
//         required this.siteLocation,
//         required this.startDate,
//         required this.endDate,
//         required this.status,
//         required this.description,
//         required this.company,
//         required this.v,
//     });

//     factory Project.fromRawJson(String str) => Project.fromJson(json.decode(str));

//     String toRawJson() => json.encode(toJson());

//     factory Project.fromJson(Map<String, dynamic> json) => Project(
//         id: json["_id"],
//         projectId: json["projectId"],
//         projectName: json["projectName"],
//         siteLocation: json["siteLocation"],
//         startDate: json["startDate"],
//         endDate: json["endDate"],
//         status: json["status"],
//         description: json["description"],
//         company: json["company"],
//         v: json["__v"],
//     );

//     Map<String, dynamic> toJson() => {
//         "_id": id,
//         "projectId": projectId,
//         "projectName": projectName,
//         "siteLocation": siteLocation,
//         "startDate": startDate,
//         "endDate": endDate,
//         "status": status,
//         "description": description,
//         "company": company,
//         "__v": v,
//     };
// }

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

class TypeOfTopic {
  String id;
  String topicTypes;
  int v;

  TypeOfTopic({
    required this.id,
    required this.topicTypes,
    required this.v,
  });

  factory TypeOfTopic.fromRawJson(String str) =>
      TypeOfTopic.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TypeOfTopic.fromJson(Map<String, dynamic> json) => TypeOfTopic(
        id: json["_id"],
        topicTypes: json["topicTypes"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "topicTypes": topicTypes,
        "__v": v,
      };
}
