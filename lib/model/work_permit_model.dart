import 'dart:convert';

class WorkPermit {
  Map<String, dynamic> customFields;
  String id;
  List<Tool> tools;
  List<MachineTool> machineTools;
  List<Equipment> equipments;
  List<TypeOfHazard> typeOfHazard;
  List<ApplicablePpe> applicablePpEs;
  List<ApprovalBy> verifiedBy;
  List<ApprovalBy> approvalBy;
  bool verifiedDone;
  bool approvalDone;
  List<Safety> safetyMeasuresTaken;
  int v;
  Area? project;
  ApprovalBy? createdby;
  Area? area;
  PermitTypes? permitTypes;
  String? date;
  String? startTime;
  String? endTime;
  String? toolsTested;
  String? workDescription;
  String? geotagging;

  WorkPermit({
    required this.customFields,
    required this.id,
    required this.tools,
    required this.machineTools,
    required this.equipments,
    required this.typeOfHazard,
    required this.applicablePpEs,
    required this.verifiedBy,
    required this.approvalBy,
    required this.verifiedDone,
    required this.approvalDone,
    required this.safetyMeasuresTaken,
    required this.v,
    this.project,
    this.createdby,
    this.area,
    this.permitTypes,
    this.date,
    this.startTime,
    this.endTime,
    this.toolsTested,
    this.workDescription,
    this.geotagging,
  });

  factory WorkPermit.fromRawJson(String str) =>
      WorkPermit.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WorkPermit.fromJson(Map<String, dynamic> json) => WorkPermit(
        customFields: json["customFields"],
        id: json["_id"],
        tools: List<Tool>.from(json["tools"].map((x) => Tool.fromJson(x))),
        machineTools: List<MachineTool>.from(
            json["machineTools"].map((x) => MachineTool.fromJson(x))),
        equipments: List<Equipment>.from(
            json["equipments"].map((x) => Equipment.fromJson(x))),
        typeOfHazard: List<TypeOfHazard>.from(
            json["typeOfHazard"].map((x) => TypeOfHazard.fromJson(x))),
        applicablePpEs: List<ApplicablePpe>.from(
            json["applicablePPEs"].map((x) => ApplicablePpe.fromJson(x))),
        verifiedBy: List<ApprovalBy>.from(
            json["verifiedBy"].map((x) => ApprovalBy.fromJson(x))),
        approvalBy: List<ApprovalBy>.from(
            json["approvalBy"].map((x) => ApprovalBy.fromJson(x))),
        verifiedDone: json["verifiedDone"],
        approvalDone: json["approvalDone"],
        safetyMeasuresTaken: List<Safety>.from(
            json["safetyMeasuresTaken"].map((x) => Safety.fromJson(x))),
        v: json["__v"],
        project:
            json["project"] == null ? null : Area.fromJson(json["project"]),
        createdby: json["createdby"] == null
            ? null
            : ApprovalBy.fromJson(json["createdby"]),
        area: json["area"] == null ? null : Area.fromJson(json["area"]),
        permitTypes: json["permitTypes"] == null
            ? null
            : PermitTypes.fromJson(json["permitTypes"]),
        date: json["date"],
        startTime: json["StartTime"],
        endTime: json["endTime"],
        toolsTested: json["toolsTested"],
        workDescription: json["workDescription"],
        geotagging: json["geotagging"],
      );

  Map<String, dynamic> toJson() => {
        "customFields": customFields,
        "_id": id,
        "tools": List<dynamic>.from(tools.map((x) => x.toJson())),
        "machineTools": List<dynamic>.from(machineTools.map((x) => x.toJson())),
        "equipments": List<dynamic>.from(equipments.map((x) => x.toJson())),
        "typeOfHazard": List<dynamic>.from(typeOfHazard.map((x) => x.toJson())),
        "applicablePPEs":
            List<dynamic>.from(applicablePpEs.map((x) => x.toJson())),
        "verifiedBy": List<dynamic>.from(verifiedBy.map((x) => x.toJson())),
        "approvalBy": List<dynamic>.from(approvalBy.map((x) => x.toJson())),
        "verifiedDone": verifiedDone,
        "approvalDone": approvalDone,
        "safetyMeasuresTaken":
            List<dynamic>.from(safetyMeasuresTaken.map((x) => x.toJson())),
        "__v": v,
        "project": project?.toJson(),
        "createdby": createdby?.toJson(),
        "area": area?.toJson(),
        "permitTypes": permitTypes?.toJson(),
        "date": date,
        "StartTime": startTime,
        "endTime": endTime,
        "toolsTested": toolsTested,
        "workDescription": workDescription,
        "geotagging": geotagging,
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

  factory ApplicablePpe.fromRawJson(String str) =>
      ApplicablePpe.fromJson(json.decode(str));

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

class ApprovalBy {
  String id;
  String userId;
  String name;
  String role;
  String emailId;
  String password;
  String phone;
  String address;
  bool isActive;
  List<dynamic> project;
  String createdAt;
  String updatedAt;
  int v;

  ApprovalBy({
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

  factory ApprovalBy.fromRawJson(String str) =>
      ApprovalBy.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ApprovalBy.fromJson(Map<String, dynamic> json) => ApprovalBy(
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

class Area {
  String id;
  String projectId;
  String projectName;
  String siteLocation;
  String startDate;
  String endDate;
  String status;
  String description;
  String company;
  int v;
  String workpermitAllow;

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
    required this.workpermitAllow,
  });

  factory Area.fromRawJson(String str) => Area.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Area.fromJson(Map<String, dynamic> json) => Area(
        id: json["_id"],
        projectId: json["projectId"],
        projectName: json["projectName"],
        siteLocation: json["siteLocation"],
        startDate: json["startDate"],
        endDate: json["endDate"],
        status: json["status"],
        description: json["description"],
        company: json["company"],
        v: json["__v"],
        workpermitAllow: json["workpermitAllow"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "projectId": projectId,
        "projectName": projectName,
        "siteLocation": siteLocation,
        "startDate": startDate,
        "endDate": endDate,
        "status": status,
        "description": description,
        "company": company,
        "__v": v,
        "workpermitAllow": workpermitAllow,
      };
}

class Equipment {
  String id;
  String equipments;
  int v;

  Equipment({
    required this.id,
    required this.equipments,
    required this.v,
  });

  factory Equipment.fromRawJson(String str) =>
      Equipment.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Equipment.fromJson(Map<String, dynamic> json) => Equipment(
        id: json["_id"],
        equipments: json["equipments"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "equipments": equipments,
        "__v": v,
      };
}

class MachineTool {
  String id;
  String machineTools;
  int v;

  MachineTool({
    required this.id,
    required this.machineTools,
    required this.v,
  });

  factory MachineTool.fromRawJson(String str) =>
      MachineTool.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MachineTool.fromJson(Map<String, dynamic> json) => MachineTool(
        id: json["_id"],
        machineTools: json["machineTools"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "machineTools": machineTools,
        "__v": v,
      };
}

class PermitTypes {
  String id;
  String permitsType;
  List<Safety> safetyChecks;
  List<String> typeOfHazard;
  int v;

  PermitTypes({
    required this.id,
    required this.permitsType,
    required this.safetyChecks,
    required this.typeOfHazard,
    required this.v,
  });

  factory PermitTypes.fromRawJson(String str) =>
      PermitTypes.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PermitTypes.fromJson(Map<String, dynamic> json) => PermitTypes(
        id: json["_id"],
        permitsType: json["permitsType"],
        safetyChecks: List<Safety>.from(
            json["SafetyChecks"].map((x) => Safety.fromJson(x))),
        typeOfHazard: List<String>.from(json["typeOfHazard"].map((x) => x)),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "permitsType": permitsType,
        "SafetyChecks": List<dynamic>.from(safetyChecks.map((x) => x.toJson())),
        "typeOfHazard": List<dynamic>.from(typeOfHazard.map((x) => x)),
        "__v": v,
      };
}

class Safety {
  String checkPoints;
  String response;
  String id;

  Safety({
    required this.checkPoints,
    required this.response,
    required this.id,
  });

  factory Safety.fromRawJson(String str) => Safety.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Safety.fromJson(Map<String, dynamic> json) => Safety(
        checkPoints: json["CheckPoints"],
        response: json["response"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "CheckPoints": checkPoints,
        "response": response,
        "_id": id,
      };
}

class Tool {
  String id;
  String tools;
  int v;

  Tool({
    required this.id,
    required this.tools,
    required this.v,
  });

  factory Tool.fromRawJson(String str) => Tool.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Tool.fromJson(Map<String, dynamic> json) => Tool(
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

  factory TypeOfHazard.fromRawJson(String str) =>
      TypeOfHazard.fromJson(json.decode(str));

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
