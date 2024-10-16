import 'dart:convert';

class TbtMeeting {
    String id;
    ProjectName? projectName;
    String date;
    String time;
    TypeOfTopic? typeOfTopic;
    List<FormFilled> formFilled;
    String? documentaryEvidencePhoto;
    String geotagging;
    String commentsBox;
    int v;
    int attendeesNos;
    double attendeesHours;
    String tbtMeetingId;

    TbtMeeting({
        required this.id,
        required this.projectName,
        required this.date,
        required this.time,
        required this.typeOfTopic,
        required this.formFilled,
        this.documentaryEvidencePhoto,
        required this.geotagging,
        required this.commentsBox,
        required this.v,
        required this.attendeesNos,
        required this.attendeesHours,
        required this.tbtMeetingId,
    });

    factory TbtMeeting.fromRawJson(String str) => TbtMeeting.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory TbtMeeting.fromJson(Map<String, dynamic> json) => TbtMeeting(
        id: json["_id"],
        projectName: json["projectName"] == null ? null : ProjectName.fromJson(json["projectName"]),
        date: json["date"],
        time: json["time"],
        typeOfTopic: json["typeOfTopic"] == null ? null : TypeOfTopic.fromJson(json["typeOfTopic"]),
        formFilled: List<FormFilled>.from(json["formFilled"].map((x) => FormFilled.fromJson(x))),
        documentaryEvidencePhoto: json["documentaryEvidencePhoto"],
        geotagging: json["geotagging"],
        commentsBox: json["commentsBox"],
        v: json["__v"],
        attendeesNos: json["attendeesNos"],
        attendeesHours: json["attendeesHours"]?.toDouble(),
        tbtMeetingId: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "projectName": projectName?.toJson(),
        "date": date,
        "time": time,
        "typeOfTopic": typeOfTopic?.toJson(),
        "formFilled": List<dynamic>.from(formFilled.map((x) => x.toJson())),
        "documentaryEvidencePhoto": documentaryEvidencePhoto,
        "geotagging": geotagging,
        "commentsBox": commentsBox,
        "__v": v,
        "attendeesNos": attendeesNos,
        "attendeesHours": attendeesHours,
        "id": tbtMeetingId,
    };
}

class FormFilled {
    String name;
    String signature;
    String id;
    String formFilledId;

    FormFilled({
        required this.name,
        required this.signature,
        required this.id,
        required this.formFilledId,
    });

    factory FormFilled.fromRawJson(String str) => FormFilled.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory FormFilled.fromJson(Map<String, dynamic> json) => FormFilled(
        name: json["name"],
        signature: json["signature"],
        id: json["_id"],
        formFilledId: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "signature": signature,
        "_id": id,
        "id": formFilledId,
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
