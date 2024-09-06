import 'dart:convert';

class UaUc {
    String id;
    ProjectName projectName;
    String area;
    String date;
    String time;
    ActionTakenBy observer;
    String observation;
    String photo;
    List<Hazard> hazards;
    List<String> causes;
    RiskValue riskValue;
    ActionTakenBy assignedTo;
    String correctivePreventiveAction;
    ActionTakenBy actionTakenBy;
    String geotagging;
    String? comment;
    int v;
    String status;

    UaUc({
        required this.id,
        required this.projectName,
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
        required this.correctivePreventiveAction,
        required this.actionTakenBy,
        required this.geotagging,
        this.comment,
        required this.v,
        required this.status,
    });

    factory UaUc.fromRawJson(String str) => UaUc.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory UaUc.fromJson(Map<String, dynamic> json) => UaUc(
        id: json["_id"],
        projectName: ProjectName.fromJson(json["projectName"]),
        area: json["area"],
        date: json["date"],
        time: json["time"],
        observer: ActionTakenBy.fromJson(json["observer"]),
        observation: json["observation"],
        photo: json["photo"],
        hazards: List<Hazard>.from(json["hazards"].map((x) => Hazard.fromJson(x))),
        causes: List<String>.from(json["causes"].map((x) => x)),
        riskValue: RiskValue.fromJson(json["riskValue"]),
        assignedTo: ActionTakenBy.fromJson(json["assignedTo"]),
        correctivePreventiveAction: json["correctivePreventiveAction"],
        actionTakenBy: ActionTakenBy.fromJson(json["actionTakenBy"]),
        geotagging: json["geotagging"],
        comment: json["comment"],
        v: json["__v"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "projectName": projectName.toJson(),
        "area": area,
        "date": date,
        "time": time,
        "observer": observer.toJson(),
        "observation": observation,
        "photo": photo,
        "hazards": List<dynamic>.from(hazards.map((x) => x.toJson())),
        "causes": List<dynamic>.from(causes.map((x) => x)),
        "riskValue": riskValue.toJson(),
        "assignedTo": assignedTo.toJson(),
        "correctivePreventiveAction": correctivePreventiveAction,
        "actionTakenBy": actionTakenBy.toJson(),
        "geotagging": geotagging,
        "comment": comment,
        "__v": v,
        "status": status,
    };
}

class ActionTakenBy {
    Address address;
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

    ActionTakenBy({
        required this.address,
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

    factory ActionTakenBy.fromRawJson(String str) => ActionTakenBy.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ActionTakenBy.fromJson(Map<String, dynamic> json) => ActionTakenBy(
        address: Address.fromJson(json["address"]),
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
        "address": address.toJson(),
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

class Address {
    String street;
    String city;
    String state;
    String zip;
    String country;

    Address({
        required this.street,
        required this.city,
        required this.state,
        required this.zip,
        required this.country,
    });

    factory Address.fromRawJson(String str) => Address.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Address.fromJson(Map<String, dynamic> json) => Address(
        street: json["street"],
        city: json["city"],
        state: json["state"],
        zip: json["zip"],
        country: json["country"],
    );

    Map<String, dynamic> toJson() => {
        "street": street,
        "city": city,
        "state": state,
        "zip": zip,
        "country": country,
    };
}

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

class RiskValue {
    String id;
    int value;
    String severity;
    String alertTimeline;
    String repeatWarning;
    int v;

    RiskValue({
        required this.id,
        required this.value,
        required this.severity,
        required this.alertTimeline,
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
        repeatWarning: json["repeatWarning"],
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "value": value,
        "severity": severity,
        "alertTimeline": alertTimeline,
        "repeatWarning": repeatWarning,
        "__v": v,
    };
}
