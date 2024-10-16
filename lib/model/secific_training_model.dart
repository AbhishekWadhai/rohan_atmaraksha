import 'dart:convert';

class SpecificTraining {
    String id;
    ProjectName projectName;
    String date;
    String time;
    TypeOfTopic typeOfTopic;
    List<String> attendees;
    List<AttendeesName?> attendeesName;
    InstructionBy? instructionBy;
    String? documentaryEvidencePhoto;
    String geotagging;
    String commentsBox;
    int v;
    int attendance;
    double attendanceHours;
    String specificTrainingId;

    SpecificTraining({
        required this.id,
        required this.projectName,
        required this.date,
        required this.time,
        required this.typeOfTopic,
        required this.attendees,
        required this.attendeesName,
        required this.instructionBy,
        this.documentaryEvidencePhoto,
        required this.geotagging,
        required this.commentsBox,
        required this.v,
        required this.attendance,
        required this.attendanceHours,
        required this.specificTrainingId,
    });

    factory SpecificTraining.fromRawJson(String str) => SpecificTraining.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory SpecificTraining.fromJson(Map<String, dynamic> json) => SpecificTraining(
        id: json["_id"],
        projectName: ProjectName.fromJson(json["projectName"]),
        date: json["date"],
        time: json["time"],
        typeOfTopic: TypeOfTopic.fromJson(json["typeOfTopic"]),
        attendees: List<String>.from(json["attendees"].map((x) => x)),
        attendeesName: List<AttendeesName?>.from(json["attendeesName"].map((x) => x == null ? null : AttendeesName.fromJson(x))),
        instructionBy: json["instructionBy"] == null ? null : InstructionBy.fromJson(json["instructionBy"]),
        documentaryEvidencePhoto: json["documentaryEvidencePhoto"],
        geotagging: json["geotagging"],
        commentsBox: json["commentsBox"],
        v: json["__v"],
        attendance: json["attendance"],
        attendanceHours: json["attendanceHours"]?.toDouble(),
        specificTrainingId: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "projectName": projectName.toJson(),
        "date": date,
        "time": time,
        "typeOfTopic": typeOfTopic.toJson(),
        "attendees": List<dynamic>.from(attendees.map((x) => x)),
        "attendeesName": List<dynamic>.from(attendeesName.map((x) => x?.toJson())),
        "instructionBy": instructionBy?.toJson(),
        "documentaryEvidencePhoto": documentaryEvidencePhoto,
        "geotagging": geotagging,
        "commentsBox": commentsBox,
        "__v": v,
        "attendance": attendance,
        "attendanceHours": attendanceHours,
        "id": specificTrainingId,
    };
}

class AttendeesName {
    String name;
    String subcontractorName;
    String signature;
    String designation;
    String id;
    String attendeesNameId;

    AttendeesName({
        required this.name,
        required this.subcontractorName,
        required this.signature,
        required this.designation,
        required this.id,
        required this.attendeesNameId,
    });

    factory AttendeesName.fromRawJson(String str) => AttendeesName.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory AttendeesName.fromJson(Map<String, dynamic> json) => AttendeesName(
        name: json["name"],
        subcontractorName: json["subcontractorName"],
        signature: json["signature"],
        designation: json["designation"],
        id: json["_id"],
        attendeesNameId: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "subcontractorName": subcontractorName,
        "signature": signature,
        "designation": designation,
        "_id": id,
        "id": attendeesNameId,
    };
}

class InstructionBy {
    String id;
    String userId;
    String name;
    String photo;
    String role;
    String emailId;
    String password;
    String phone;
    String address;
    bool isActive;
    List<String> projectName;
    DateTime createdAt;
    DateTime updatedAt;
    int v;

    InstructionBy({
        required this.id,
        required this.userId,
        required this.name,
        required this.photo,
        required this.role,
        required this.emailId,
        required this.password,
        required this.phone,
        required this.address,
        required this.isActive,
        required this.projectName,
        required this.createdAt,
        required this.updatedAt,
        required this.v,
    });

    factory InstructionBy.fromRawJson(String str) => InstructionBy.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory InstructionBy.fromJson(Map<String, dynamic> json) => InstructionBy(
        id: json["_id"],
        userId: json["userId"],
        name: json["name"],
        photo: json["photo"],
        role: json["role"],
        emailId: json["emailId"],
        password: json["password"],
        phone: json["phone"],
        address: json["address"],
        isActive: json["isActive"],
        projectName: List<String>.from(json["projectName"].map((x) => x)),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId,
        "name": name,
        "photo": photo,
        "role": role,
        "emailId": emailId,
        "password": password,
        "phone": phone,
        "address": address,
        "isActive": isActive,
        "projectName": List<dynamic>.from(projectName.map((x) => x)),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
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

    factory ProjectName.fromRawJson(String str) => ProjectName.fromJson(json.decode(str));

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

class TypeOfTopic {
    String id;
    String topicTypes;
    int v;

    TypeOfTopic({
        required this.id,
        required this.topicTypes,
        required this.v,
    });

    factory TypeOfTopic.fromRawJson(String str) => TypeOfTopic.fromJson(json.decode(str));

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
