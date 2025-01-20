import 'dart:convert';

import 'package:rohan_suraksha_sathi/model/user_model.dart';

import 'projects_model.dart';

class UaUc {
    String id;
    Project project;
    User createdby;
    String area;
    String date;
    String time;
    User observer;
    String observation;
    String photo;
    List<Hazard> hazards;
    String causes;
    RiskValue riskValue;
    User assignedTo;
    String? correctivePreventiveAction;
    User? actionTakenBy;
    String? actionTakenPhoto;
    String status;
    String geotagging;
    String comment;
    int v;

    UaUc({
        required this.id,
        required this.project,
        required this.createdby,
        required this.area,
        required this.date,
        required this.time,
        required this.observer,
        required this.observation,
        required this.photo,
        required this.hazards,
        required this.causes,
        required this.riskValue,
        required this.assignedTo,
        this.correctivePreventiveAction,
        this.actionTakenBy,
        this.actionTakenPhoto,
        required this.status,
        required this.geotagging,
        required this.comment,
        required this.v,
    });

    factory UaUc.fromRawJson(String str) => UaUc.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory UaUc.fromJson(Map<String, dynamic> json) => UaUc(
        id: json["_id"],
        project: Project.fromJson(json["project"]),
        createdby: User.fromJson(json["createdby"]),
        area: json["area"],
        date: json["date"],
        time: json["time"],
        observer: User.fromJson(json["observer"]),
        observation: json["observation"],
        photo: json["photo"],
        hazards: List<Hazard>.from(json["hazards"].map((x) => Hazard.fromJson(x))),
        causes: json["causes"],
        riskValue: RiskValue.fromJson(json["riskValue"]),
        assignedTo: User.fromJson(json["assignedTo"]),
        correctivePreventiveAction: json["correctivePreventiveAction"],
        actionTakenBy: json["actionTakenBy"] == null ? null : User.fromJson(json["actionTakenBy"]),
        actionTakenPhoto: json["actionTakenPhoto"],
        status: json["status"],
        geotagging: json["geotagging"],
        comment: json["comment"],
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "project": project.toJson(),
        "createdby": createdby.toJson(),
        "area": area,
        "date": date,
        "time": time,
        "observer": observer.toJson(),
        "observation": observation,
        "photo": photo,
        "hazards": List<dynamic>.from(hazards.map((x) => x.toJson())),
        "causes": causes,
        "riskValue": riskValue.toJson(),
        "assignedTo": assignedTo.toJson(),
        "correctivePreventiveAction": correctivePreventiveAction,
        "actionTakenBy": actionTakenBy?.toJson(),
        "actionTakenPhoto": actionTakenPhoto,
        "status": status,
        "geotagging": geotagging,
        "comment": comment,
        "__v": v,
    };
}

// class AssignedTo {
//     String id;
//     String userId;
//     String name;
//     String role;
//     String emailId;
//     String password;
//     String phone;
//     String address;
//     bool isActive;
//     String project;
//     String createdAt;
//     String updatedAt;
//     int v;

//     AssignedTo({
//         required this.id,
//         required this.userId,
//         required this.name,
//         required this.role,
//         required this.emailId,
//         required this.password,
//         required this.phone,
//         required this.address,
//         required this.isActive,
//         required this.project,
//         required this.createdAt,
//         required this.updatedAt,
//         required this.v,
//     });

//     factory AssignedTo.fromRawJson(String str) => AssignedTo.fromJson(json.decode(str));

//     String toRawJson() => json.encode(toJson());

//     factory AssignedTo.fromJson(Map<String, dynamic> json) => AssignedTo(
//         id: json["_id"],
//         userId: json["userId"],
//         name: json["name"],
//         role: json["role"],
//         emailId: json["emailId"],
//         password: json["password"],
//         phone: json["phone"],
//         address: json["address"],
//         isActive: json["isActive"],
//         project: json["project"],
//         createdAt: json["createdAt"],
//         updatedAt: json["updatedAt"],
//         v: json["__v"],
//     );

//     Map<String, dynamic> toJson() => {
//         "_id": id,
//         "userId": userId,
//         "name": name,
//         "role": role,
//         "emailId": emailId,
//         "password": password,
//         "phone": phone,
//         "address": address,
//         "isActive": isActive,
//         "project": project,
//         "createdAt": createdAt,
//         "updatedAt": updatedAt,
//         "__v": v,
//     };
// }

class Hazard {
    String id;
    String hazards;
    int v;

    Hazard({
        required this.id,
        required this.hazards,
        required this.v,
    });

    factory Hazard.fromRawJson(String str) => Hazard.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Hazard.fromJson(Map<String, dynamic> json) => Hazard(
        id: json["_id"],
        hazards: json["hazards"],
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "hazards": hazards,
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
//     String? description;
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
//         this.description,
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

class RiskValue {
    String id;
    int value;
    String severity;
    String alertTimeline;
    List<String> escalationAlert;
    String repeatWarning;
    int v;

    RiskValue({
        required this.id,
        required this.value,
        required this.severity,
        required this.alertTimeline,
        required this.escalationAlert,
        required this.repeatWarning,
        required this.v,
    });

    factory RiskValue.fromRawJson(String str) => RiskValue.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory RiskValue.fromJson(Map<String, dynamic> json) => RiskValue(
        id: json["_id"],
        value: json["value"],
        severity: json["severity"],
        alertTimeline: json["alertTimeline"],
        escalationAlert: List<String>.from(json["escalationAlert"].map((x) => x)),
        repeatWarning: json["repeatWarning"],
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "value": value,
        "severity": severity,
        "alertTimeline": alertTimeline,
        "escalationAlert": List<dynamic>.from(escalationAlert.map((x) => x)),
        "repeatWarning": repeatWarning,
        "__v": v,
    };
}
