import 'dart:convert';

class WorkPermit {
    String id;
    Area projectName;
    Area area;
    PermitTypes permitTypes;
    String date;
    String time;
    List<ToolsAndEquipment> toolsAndEquipment;
    String toolsTested;
    String workDescription;
    List<TypeOfHazard> typeOfHazard;
    List<ApplicablePpe> applicablePpEs;
    String safetyMeasuresTaken;
    String undersignDraft;
    By? createdBy;
    List<By> verifiedBy;
    List<By> approvalBy;
    bool verifiedDone;
    bool approvalDone;
    String geotagging;
    int v;

    WorkPermit({
        required this.id,
        required this.projectName,
        required this.area,
        required this.permitTypes,
        required this.date,
        required this.time,
        required this.toolsAndEquipment,
        required this.toolsTested,
        required this.workDescription,
        required this.typeOfHazard,
        required this.applicablePpEs,
        required this.safetyMeasuresTaken,
        required this.undersignDraft,
        required this.createdBy,
        required this.verifiedBy,
        required this.approvalBy,
        required this.verifiedDone,
        required this.approvalDone,
        required this.geotagging,
        required this.v,
    });

    factory WorkPermit.fromRawJson(String str) => WorkPermit.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory WorkPermit.fromJson(Map<String, dynamic> json) => WorkPermit(
        id: json["_id"],
        projectName: Area.fromJson(json["projectName"]),
        area: Area.fromJson(json["area"]),
        permitTypes: PermitTypes.fromJson(json["permitTypes"]),
        date: json["date"],
        time: json["time"],
        toolsAndEquipment: List<ToolsAndEquipment>.from(json["toolsAndEquipment"].map((x) => ToolsAndEquipment.fromJson(x))),
        toolsTested: json["toolsTested"],
        workDescription: json["workDescription"],
        typeOfHazard: List<TypeOfHazard>.from(json["typeOfHazard"].map((x) => TypeOfHazard.fromJson(x))),
        applicablePpEs: List<ApplicablePpe>.from(json["applicablePPEs"].map((x) => ApplicablePpe.fromJson(x))),
        safetyMeasuresTaken: json["safetyMeasuresTaken"],
        undersignDraft: json["undersignDraft"],
        createdBy: json["createdBy"] == null ? null : By.fromJson(json["createdBy"]),
        verifiedBy: List<By>.from(json["verifiedBy"].map((x) => By.fromJson(x))),
        approvalBy: List<By>.from(json["approvalBy"].map((x) => By.fromJson(x))),
        verifiedDone: json["verifiedDone"],
        approvalDone: json["approvalDone"],
        geotagging: json["geotagging"],
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "projectName": projectName.toJson(),
        "area": area.toJson(),
        "permitTypes": permitTypes.toJson(),
        "date": date,
        "time": time,
        "toolsAndEquipment": List<dynamic>.from(toolsAndEquipment.map((x) => x.toJson())),
        "toolsTested": toolsTested,
        "workDescription": workDescription,
        "typeOfHazard": List<dynamic>.from(typeOfHazard.map((x) => x.toJson())),
        "applicablePPEs": List<dynamic>.from(applicablePpEs.map((x) => x.toJson())),
        "safetyMeasuresTaken": safetyMeasuresTaken,
        "undersignDraft": undersignDraft,
        "createdBy": createdBy?.toJson(),
        "verifiedBy": List<dynamic>.from(verifiedBy.map((x) => x.toJson())),
        "approvalBy": List<dynamic>.from(approvalBy.map((x) => x.toJson())),
        "verifiedDone": verifiedDone,
        "approvalDone": approvalDone,
        "geotagging": geotagging,
        "__v": v,
    };
}

class ApplicablePpe {
    String id;
    String ppes;
    int v;

    ApplicablePpe({
        required this.id,
        required this.ppes,
        required this.v,
    });

    factory ApplicablePpe.fromRawJson(String str) => ApplicablePpe.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ApplicablePpe.fromJson(Map<String, dynamic> json) => ApplicablePpe(
        id: json["_id"],
        ppes: json["ppes"],
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "ppes": ppes,
        "__v": v,
    };
}

class By {
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

    By({
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

    factory By.fromRawJson(String str) => By.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory By.fromJson(Map<String, dynamic> json) => By(
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

class Area {
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

    Area({
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

    factory Area.fromRawJson(String str) => Area.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Area.fromJson(Map<String, dynamic> json) => Area(
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

class PermitTypes {
    List<dynamic> safetyChecks;
    String id;
    String permitsType;
    int v;

    PermitTypes({
        required this.safetyChecks,
        required this.id,
        required this.permitsType,
        required this.v,
    });

    factory PermitTypes.fromRawJson(String str) => PermitTypes.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory PermitTypes.fromJson(Map<String, dynamic> json) => PermitTypes(
        safetyChecks: List<dynamic>.from(json["SafetyChecks"].map((x) => x)),
        id: json["_id"],
        permitsType: json["permitsType"],
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "SafetyChecks": List<dynamic>.from(safetyChecks.map((x) => x)),
        "_id": id,
        "permitsType": permitsType,
        "__v": v,
    };
}

class ToolsAndEquipment {
    String id;
    String tools;
    int v;

    ToolsAndEquipment({
        required this.id,
        required this.tools,
        required this.v,
    });

    factory ToolsAndEquipment.fromRawJson(String str) => ToolsAndEquipment.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ToolsAndEquipment.fromJson(Map<String, dynamic> json) => ToolsAndEquipment(
        id: json["_id"],
        tools: json["tools"],
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "tools": tools,
        "__v": v,
    };
}

class TypeOfHazard {
    String id;
    String hazards;
    int v;

    TypeOfHazard({
        required this.id,
        required this.hazards,
        required this.v,
    });

    factory TypeOfHazard.fromRawJson(String str) => TypeOfHazard.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory TypeOfHazard.fromJson(Map<String, dynamic> json) => TypeOfHazard(
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
