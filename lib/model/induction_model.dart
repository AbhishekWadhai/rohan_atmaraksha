import 'dart:convert';

class Induction {
    String id;
    ProjectName? projectName;
    String date;
    String time;
    String inductees;
    String inducteesName;
    List<TradeType> tradeTypes;
    String subContractorName;
    TypeOfTopic? typeOfTopic;
    String documentaryEvidencePhoto;
    String? anyOthers;
    InstructionBy? instructionBy;
    String geotagging;
    DateTime createdAt;
    int v;
    String? inductionAnyOthers;

    Induction({
        required this.id,
        required this.projectName,
        required this.date,
        required this.time,
        required this.inductees,
        required this.inducteesName,
        required this.tradeTypes,
        required this.subContractorName,
        required this.typeOfTopic,
        required this.documentaryEvidencePhoto,
        this.anyOthers,
        required this.instructionBy,
        required this.geotagging,
        required this.createdAt,
        required this.v,
        this.inductionAnyOthers,
    });

    factory Induction.fromRawJson(String str) => Induction.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Induction.fromJson(Map<String, dynamic> json) => Induction(
        id: json["_id"],
        projectName: json["projectName"] == null ? null : ProjectName.fromJson(json["projectName"]),
        date: json["date"],
        time: json["time"],
        inductees: json["inductees"],
        inducteesName: json["inducteesName"],
        tradeTypes: List<TradeType>.from(json["tradeTypes"].map((x) => TradeType.fromJson(x))),
        subContractorName: json["subContractorName"],
        typeOfTopic: json["typeOfTopic"] == null ? null : TypeOfTopic.fromJson(json["typeOfTopic"]),
        documentaryEvidencePhoto: json["documentaryEvidencePhoto"],
        anyOthers: json["AnyOthers"],
        instructionBy: json["instructionBy"] == null ? null : InstructionBy.fromJson(json["instructionBy"]),
        geotagging: json["geotagging"],
        createdAt: DateTime.parse(json["createdAt"]),
        v: json["__v"],
        inductionAnyOthers: json["anyOthers"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "projectName": projectName?.toJson(),
        "date": date,
        "time": time,
        "inductees": inductees,
        "inducteesName": inducteesName,
        "tradeTypes": List<dynamic>.from(tradeTypes.map((x) => x.toJson())),
        "subContractorName": subContractorName,
        "typeOfTopic": typeOfTopic?.toJson(),
        "documentaryEvidencePhoto": documentaryEvidencePhoto,
        "AnyOthers": anyOthers,
        "instructionBy": instructionBy?.toJson(),
        "geotagging": geotagging,
        "createdAt": createdAt.toIso8601String(),
        "__v": v,
        "anyOthers": inductionAnyOthers,
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

class TradeType {
    String id;
    String tradeTypes;
    int v;

    TradeType({
        required this.id,
        required this.tradeTypes,
        required this.v,
    });

    factory TradeType.fromRawJson(String str) => TradeType.fromJson(json.decode(str));

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
