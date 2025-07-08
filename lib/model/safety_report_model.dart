import 'dart:convert';

class SafetyReportModel {
  String id;
  Project project;
  num totalAvgManpower;
  num totalManHoursWorked;
  num fatality;
  num ltiCases;
  num mtiCases;
  num fac;
  num majorEnvironmentalCases;
  num animalAndInsectBiteCases;
  num dangerousOccurrences;
  num nearMissIncidents;
  num fireCases;
  num manDaysLost;
  num fr;
  num sr;
  num safeLtiFreeDays;
  num safeLtiFreeManHours;
  num ncrPenaltyWarnings;
  num suggestionsReceived;
  num uaUcReportedClosed;
  num tbtMeetingHours;
  num personsSafetyInducted;
  num specificSafetyTrainingHours;
  num totalTrainingHours;
  num safetyItemsInspections;
  num safetyCommitteeMeetings;
  num internalAudits;
  num externalAudits;
  num awardsAndAppreciations;
  num safetyAwardRatingHighest;
  num safetyAwardRatingLowest;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  SafetyReportModel({
    required this.id,
    required this.project,
    required this.totalAvgManpower,
    required this.totalManHoursWorked,
    required this.fatality,
    required this.ltiCases,
    required this.mtiCases,
    required this.fac,
    required this.majorEnvironmentalCases,
    required this.animalAndInsectBiteCases,
    required this.dangerousOccurrences,
    required this.nearMissIncidents,
    required this.fireCases,
    required this.manDaysLost,
    required this.fr,
    required this.sr,
    required this.safeLtiFreeDays,
    required this.safeLtiFreeManHours,
    required this.ncrPenaltyWarnings,
    required this.suggestionsReceived,
    required this.uaUcReportedClosed,
    required this.tbtMeetingHours,
    required this.personsSafetyInducted,
    required this.specificSafetyTrainingHours,
    required this.totalTrainingHours,
    required this.safetyItemsInspections,
    required this.safetyCommitteeMeetings,
    required this.internalAudits,
    required this.externalAudits,
    required this.awardsAndAppreciations,
    required this.safetyAwardRatingHighest,
    required this.safetyAwardRatingLowest,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory SafetyReportModel.fromRawJson(String str) =>
      SafetyReportModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SafetyReportModel.fromJson(Map<String, dynamic> json) =>
      SafetyReportModel(
        id: json["_id"],
        project: Project.fromJson(json["project"]),
        totalAvgManpower: json["totalAvgManpower"],
        totalManHoursWorked: json["totalManHoursWorked"],
        fatality: json["fatality"],
        ltiCases: json["ltiCases"],
        mtiCases: json["mtiCases"],
        fac: json["fac"],
        majorEnvironmentalCases: json["majorEnvironmentalCases"],
        animalAndInsectBiteCases: json["animalAndInsectBiteCases"],
        dangerousOccurrences: json["dangerousOccurrences"],
        nearMissIncidents: json["nearMissIncidents"],
        fireCases: json["fireCases"],
        manDaysLost: json["manDaysLost"],
        fr: json["fr"],
        sr: json["sr"],
        safeLtiFreeDays: json["safeLtiFreeDays"],
        safeLtiFreeManHours: json["safeLtiFreeManHours"],
        ncrPenaltyWarnings: json["ncrPenaltyWarnings"],
        suggestionsReceived: json["suggestionsReceived"],
        uaUcReportedClosed: json["uaUcReportedClosed"],
        tbtMeetingHours: json["tbtMeetingHours"]?.toDouble(),
        personsSafetyInducted: json["personsSafetyInducted"],
        specificSafetyTrainingHours: json["specificSafetyTrainingHours"],
        totalTrainingHours: json["totalTrainingHours"]?.toDouble(),
        safetyItemsInspections: json["safetyItemsInspections"],
        safetyCommitteeMeetings: json["safetyCommitteeMeetings"],
        internalAudits: json["internalAudits"],
        externalAudits: json["externalAudits"],
        awardsAndAppreciations: json["awardsAndAppreciations"],
        safetyAwardRatingHighest: json["safetyAwardRatingHighest"],
        safetyAwardRatingLowest: json["safetyAwardRatingLowest"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "project": project.toJson(),
        "totalAvgManpower": totalAvgManpower,
        "totalManHoursWorked": totalManHoursWorked,
        "fatality": fatality,
        "ltiCases": ltiCases,
        "mtiCases": mtiCases,
        "fac": fac,
        "majorEnvironmentalCases": majorEnvironmentalCases,
        "animalAndInsectBiteCases": animalAndInsectBiteCases,
        "dangerousOccurrences": dangerousOccurrences,
        "nearMissIncidents": nearMissIncidents,
        "fireCases": fireCases,
        "manDaysLost": manDaysLost,
        "fr": fr,
        "sr": sr,
        "safeLtiFreeDays": safeLtiFreeDays,
        "safeLtiFreeManHours": safeLtiFreeManHours,
        "ncrPenaltyWarnings": ncrPenaltyWarnings,
        "suggestionsReceived": suggestionsReceived,
        "uaUcReportedClosed": uaUcReportedClosed,
        "tbtMeetingHours": tbtMeetingHours,
        "personsSafetyInducted": personsSafetyInducted,
        "specificSafetyTrainingHours": specificSafetyTrainingHours,
        "totalTrainingHours": totalTrainingHours,
        "safetyItemsInspections": safetyItemsInspections,
        "safetyCommitteeMeetings": safetyCommitteeMeetings,
        "internalAudits": internalAudits,
        "externalAudits": externalAudits,
        "awardsAndAppreciations": awardsAndAppreciations,
        "safetyAwardRatingHighest": safetyAwardRatingHighest,
        "safetyAwardRatingLowest": safetyAwardRatingLowest,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "__v": v,
      };
}

class Project {
  String workpermitAllow;
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

  Project({
    required this.workpermitAllow,
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

  factory Project.fromRawJson(String str) => Project.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Project.fromJson(Map<String, dynamic> json) => Project(
        workpermitAllow: json["workpermitAllow"],
        id: json["_id"],
        projectId: json["projectId"],
        projectName: json["projectName"],
        siteLocation: json["siteLocation"],
        startDate: json["startDate"],
        endDate: json["endDate"],
        status: json["status"],
        description: json["description"] ?? "",
        company: json["company"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "workpermitAllow": workpermitAllow,
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
      };
}
