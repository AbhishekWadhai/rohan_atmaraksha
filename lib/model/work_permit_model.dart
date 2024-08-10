import 'dart:convert';

class WorkPermit {
    String id;
    dynamic projectName;
    dynamic area;
    dynamic permitTypes;
    DateTime date;
    String time;
    List<dynamic> toolsAndEquipment;
    String workDescription;
    List<dynamic> typeOfHazard;
    List<dynamic> applicablePpEs;
    String safetyMeasuresTaken;
    String undersignDraft;
    dynamic createdBy;
    List<dynamic> verifiedBy;
    List<dynamic> approvalBy;
    bool verifiedDone;
    bool approvalDone;
    int v;

    WorkPermit({
        required this.id,
        required this.projectName,
        required this.area,
        required this.permitTypes,
        required this.date,
        required this.time,
        required this.toolsAndEquipment,
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
        required this.v,
    });

    factory WorkPermit.fromRawJson(String str) => WorkPermit.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory WorkPermit.fromJson(Map<String, dynamic> json) => WorkPermit(
        id: json["_id"],
        projectName: json["projectName"],
        area: json["area"],
        permitTypes: json["permitTypes"],
        date: DateTime.parse(json["date"]),
        time: json["time"],
        toolsAndEquipment: List<dynamic>.from(json["toolsAndEquipment"].map((x) => x)),
        workDescription: json["workDescription"],
        typeOfHazard: List<dynamic>.from(json["typeOfHazard"].map((x) => x)),
        applicablePpEs: List<dynamic>.from(json["applicablePPEs"].map((x) => x)),
        safetyMeasuresTaken: json["safetyMeasuresTaken"],
        undersignDraft: json["undersignDraft"],
        createdBy: json["createdBy"],
        verifiedBy: List<dynamic>.from(json["verifiedBy"].map((x) => x)),
        approvalBy: List<dynamic>.from(json["approvalBy"].map((x) => x)),
        verifiedDone: json["verifiedDone"],
        approvalDone: json["approvalDone"],
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "projectName": projectName,
        "area": area,
        "permitTypes": permitTypes,
        "date": date.toIso8601String(),
        "time": time,
        "toolsAndEquipment": List<dynamic>.from(toolsAndEquipment.map((x) => x)),
        "workDescription": workDescription,
        "typeOfHazard": List<dynamic>.from(typeOfHazard.map((x) => x)),
        "applicablePPEs": List<dynamic>.from(applicablePpEs.map((x) => x)),
        "safetyMeasuresTaken": safetyMeasuresTaken,
        "undersignDraft": undersignDraft,
        "createdBy": createdBy,
        "verifiedBy": List<dynamic>.from(verifiedBy.map((x) => x)),
        "approvalBy": List<dynamic>.from(approvalBy.map((x) => x)),
        "verifiedDone": verifiedDone,
        "approvalDone": approvalDone,
        "__v": v,
    };
}
