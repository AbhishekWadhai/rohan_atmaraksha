import 'dart:convert';

class TbtMeeting {
    String id;
    ProjectName projectName;
    String date;
    String time;
    String topicName;
    TypeOfTopic typeOfTopic;
    List<String> attendees;
    String documentaryEvidencePhoto;
    List<String> formFilledSignBy;
    String geotagging;
    String commentsBox;
    int v;

    TbtMeeting({
        required this.id,
        required this.projectName,
        required this.date,
        required this.time,
        required this.topicName,
        required this.typeOfTopic,
        required this.attendees,
        required this.documentaryEvidencePhoto,
        required this.formFilledSignBy,
        required this.geotagging,
        required this.commentsBox,
        required this.v,
    });

    factory TbtMeeting.fromRawJson(String str) => TbtMeeting.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory TbtMeeting.fromJson(Map<String, dynamic> json) => TbtMeeting(
        id: json["_id"],
        projectName: ProjectName.fromJson(json["projectName"]),
        date: json["date"],
        time: json["time"],
        topicName: json["topicName"],
        typeOfTopic: TypeOfTopic.fromJson(json["typeOfTopic"]),
        attendees: List<String>.from(json["attendees"].map((x) => x)),
        documentaryEvidencePhoto: json["documentaryEvidencePhoto"],
        formFilledSignBy: List<String>.from(json["formFilledSignBy"].map((x) => x)),
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
        "typeOfTopic": typeOfTopic.toJson(),
        "attendees": List<dynamic>.from(attendees.map((x) => x)),
        "documentaryEvidencePhoto": documentaryEvidencePhoto,
        "formFilledSignBy": List<dynamic>.from(formFilledSignBy.map((x) => x)),
        "geotagging": geotagging,
        "commentsBox": commentsBox,
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
