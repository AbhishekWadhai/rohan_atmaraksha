import 'dart:convert';

class WorkPermit {
  String id;
  ProjectDetails projectName;
  ProjectDetails area;
  PermitTypes? permitTypes;
  String date;
  String time;
  List<ToolsAndEquipment> toolsAndEquipment;
  String workDescription;
  List<TypeOfHazard> typeOfHazard;
  List<ApplicablePPE> applicablePPEs;
  String safetyMeasuresTaken;
  String undersignDraft;
  CreatedBy? createdBy;
  List<VerifiedBy> verifiedBy;
  List<ApprovalBy> approvalBy;
  bool verifiedDone;
  bool approvalDone;

  WorkPermit({
    required this.id,
    required this.projectName,
    required this.area,
    this.permitTypes,
    required this.date,
    required this.time,
    required this.toolsAndEquipment,
    required this.workDescription,
    required this.typeOfHazard,
    required this.applicablePPEs,
    required this.safetyMeasuresTaken,
    required this.undersignDraft,
    this.createdBy,
    required this.verifiedBy,
    required this.approvalBy,
    required this.verifiedDone,
    required this.approvalDone,
  });

  factory WorkPermit.fromJson(Map<String, dynamic> json) {
    return WorkPermit(
      id: json["_id"],
      projectName: ProjectDetails.fromJson(json["projectName"]),
      area: ProjectDetails.fromJson(json["area"]),
      permitTypes: json["permitTypes"] != null
          ? PermitTypes.fromJson(json["permitTypes"])
          : null,
      date: json["date"],
      time: json["time"],
      toolsAndEquipment: List<ToolsAndEquipment>.from(
          json["toolsAndEquipment"].map((x) => ToolsAndEquipment.fromJson(x))),
      workDescription: json["workDescription"],
      typeOfHazard: List<TypeOfHazard>.from(
          json["typeOfHazard"].map((x) => TypeOfHazard.fromJson(x))),
      applicablePPEs: List<ApplicablePPE>.from(
          json["applicablePPEs"].map((x) => ApplicablePPE.fromJson(x))),
      safetyMeasuresTaken: json["safetyMeasuresTaken"],
      undersignDraft: json["undersignDraft"],
      createdBy: json["createdBy"] != null
          ? CreatedBy.fromJson(json["createdBy"])
          : null,
      verifiedBy: List<VerifiedBy>.from(
          json["verifiedBy"].map((x) => VerifiedBy.fromJson(x))),
      approvalBy: List<ApprovalBy>.from(
          json["approvalBy"].map((x) => ApprovalBy.fromJson(x))),
      verifiedDone: json["verifiedDone"],
      approvalDone: json["approvalDone"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "projectName": projectName.toJson(),
      "area": area.toJson(),
      "permitTypes": permitTypes?.toJson(),
      "date": date,
      "time": time,
      "toolsAndEquipment":
          List<dynamic>.from(toolsAndEquipment.map((x) => x.toJson())),
      "workDescription": workDescription,
      "typeOfHazard": List<dynamic>.from(typeOfHazard.map((x) => x.toJson())),
      "applicablePPEs":
          List<dynamic>.from(applicablePPEs.map((x) => x.toJson())),
      "safetyMeasuresTaken": safetyMeasuresTaken,
      "undersignDraft": undersignDraft,
      "createdBy": createdBy?.toJson(),
      "verifiedBy": List<dynamic>.from(verifiedBy.map((x) => x.toJson())),
      "approvalBy": List<dynamic>.from(approvalBy.map((x) => x.toJson())),
      "verifiedDone": verifiedDone,
      "approvalDone": approvalDone,
    };
  }
}

class ProjectDetails {
  String id;
  String projectId;
  String projectName;
  String siteLocation;
  String startDate;
  String endDate;
  String status;
  String description;
  String company;

  ProjectDetails({
    required this.id,
    required this.projectId,
    required this.projectName,
    required this.siteLocation,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.description,
    required this.company,
  });

  factory ProjectDetails.fromJson(Map<String, dynamic> json) {
    return ProjectDetails(
      id: json["_id"],
      projectId: json["projectId"],
      projectName: json["projectName"],
      siteLocation: json["siteLocation"],
      startDate: json["startDate"],
      endDate: json["endDate"],
      status: json["status"],
      description: json["description"],
      company: json["company"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "projectId": projectId,
      "projectName": projectName,
      "siteLocation": siteLocation,
      "startDate": startDate,
      "endDate": endDate,
      "status": status,
      "description": description,
      "company": company,
    };
  }
}

class PermitTypes {
  String id;
  String permitsType;

  PermitTypes({
    required this.id,
    required this.permitsType,
  });

  factory PermitTypes.fromJson(Map<String, dynamic> json) {
    return PermitTypes(
      id: json["_id"],
      permitsType: json["permitsType"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "permitsType": permitsType,
    };
  }
}

class ToolsAndEquipment {
  String id;
  String tools;

  ToolsAndEquipment({
    required this.id,
    required this.tools,
  });

  factory ToolsAndEquipment.fromJson(Map<String, dynamic> json) {
    return ToolsAndEquipment(
      id: json["_id"],
      tools: json["tools"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "tools": tools,
    };
  }
}

class TypeOfHazard {
  String id;
  String hazards;

  TypeOfHazard({
    required this.id,
    required this.hazards,
  });

  factory TypeOfHazard.fromJson(Map<String, dynamic> json) {
    return TypeOfHazard(
      id: json["_id"],
      hazards: json["hazards"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "hazards": hazards,
    };
  }
}

class ApplicablePPE {
  String id;
  String ppes;

  ApplicablePPE({
    required this.id,
    required this.ppes,
  });

  factory ApplicablePPE.fromJson(Map<String, dynamic> json) {
    return ApplicablePPE(
      id: json["_id"],
      ppes: json["ppes"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "ppes": ppes,
    };
  }
}

class CreatedBy {
  String id;
  String userId;
  String name;
  String photo;
  String role;
  String emailId;
  String password;
  String phone;
  Address address;
  bool isActive;

  CreatedBy({
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
  });

  factory CreatedBy.fromJson(Map<String, dynamic> json) {
    return CreatedBy(
      id: json["_id"],
      userId: json["userId"],
      name: json["name"],
      photo: json["photo"],
      role: json["role"],
      emailId: json["emailId"],
      password: json["password"],
      phone: json["phone"],
      address: Address.fromJson(json["address"]),
      isActive: json["isActive"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "userId": userId,
      "name": name,
      "photo": photo,
      "role": role,
      "emailId": emailId,
      "password": password,
      "phone": phone,
      "address": address.toJson(),
      "isActive": isActive,
    };
  }
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

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json["street"],
      city: json["city"],
      state: json["state"],
      zip: json["zip"],
      country: json["country"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "street": street,
      "city": city,
      "state": state,
      "zip": zip,
      "country": country,
    };
  }
}

class VerifiedBy {
  String id;
  String userId;
  String name;
  String photo;
  String role;
  String emailId;
  String password;
  String phone;
  Address address;
  bool isActive;

  VerifiedBy({
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
  });

  factory VerifiedBy.fromJson(Map<String, dynamic> json) {
    return VerifiedBy(
      id: json["_id"],
      userId: json["userId"],
      name: json["name"],
      photo: json["photo"],
      role: json["role"],
      emailId: json["emailId"],
      password: json["password"],
      phone: json["phone"],
      address: Address.fromJson(json["address"]),
      isActive: json["isActive"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "userId": userId,
      "name": name,
      "photo": photo,
      "role": role,
      "emailId": emailId,
      "password": password,
      "phone": phone,
      "address": address.toJson(),
      "isActive": isActive,
    };
  }
}

class ApprovalBy {
  String id;
  String userId;
  String name;
  String photo;
  String role;
  String emailId;
  String password;
  String phone;
  Address address;
  bool isActive;

  ApprovalBy({
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
  });

  factory ApprovalBy.fromJson(Map<String, dynamic> json) {
    return ApprovalBy(
      id: json["_id"],
      userId: json["userId"],
      name: json["name"],
      photo: json["photo"],
      role: json["role"],
      emailId: json["emailId"],
      password: json["password"],
      phone: json["phone"],
      address: Address.fromJson(json["address"]),
      isActive: json["isActive"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "userId": userId,
      "name": name,
      "photo": photo,
      "role": role,
      "emailId": emailId,
      "password": password,
      "phone": phone,
      "address": address.toJson(),
      "isActive": isActive,
    };
  }
}
