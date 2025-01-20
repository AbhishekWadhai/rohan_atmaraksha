import 'dart:convert';

import 'projects_model.dart';

class SafetyReportModel {
    String id;
    int totalAvgManpower;
    int totalManHoursWorked;
    int fatality;
    int ltiCases;
    int mtiCases;
    int fac;
    int majorEnvironmentalCases;
    int animalAndInsectBiteCases;
    int dangerousOccurrences;
    int nearMissIncidents;
    int fireCases;
    int manDaysLost;
    double fr;
    double sr;
    int safeLtiFreeDays;
    int safeLtiFreeManHours;
    int ncrPenaltyWarnings;
    int suggestionsReceived;
    int uaUcReportedClosed;
    int tbtMeetingHours;
    int personsSafetyInducted;
    int specificSafetyTrainingHours;
    int totalTrainingHours;
    int safetyItemsInspections;
    int safetyCommitteeMeetings;
    int internalAudits;
    int externalAudits;
    int awardsAndAppreciations;
    int safetyAwardRatingHighest;
    int safetyAwardRatingLowest;
    String createdAt;
    String updatedAt;
    int v;
    Project project;

    SafetyReportModel({
        required this.id,
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
        required this.project,
    });

    factory SafetyReportModel.fromRawJson(String str) => SafetyReportModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory SafetyReportModel.fromJson(Map<String, dynamic> json) => SafetyReportModel(
        id: json["_id"],
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
        fr: json["fr"]?.toDouble(),
        sr: json["sr"]?.toDouble(),
        safeLtiFreeDays: json["safeLtiFreeDays"],
        safeLtiFreeManHours: json["safeLtiFreeManHours"],
        ncrPenaltyWarnings: json["ncrPenaltyWarnings"],
        suggestionsReceived: json["suggestionsReceived"],
        uaUcReportedClosed: json["uaUcReportedClosed"],
        tbtMeetingHours: json["tbtMeetingHours"],
        personsSafetyInducted: json["personsSafetyInducted"],
        specificSafetyTrainingHours: json["specificSafetyTrainingHours"],
        totalTrainingHours: json["totalTrainingHours"],
        safetyItemsInspections: json["safetyItemsInspections"],
        safetyCommitteeMeetings: json["safetyCommitteeMeetings"],
        internalAudits: json["internalAudits"],
        externalAudits: json["externalAudits"],
        awardsAndAppreciations: json["awardsAndAppreciations"],
        safetyAwardRatingHighest: json["safetyAwardRatingHighest"],
        safetyAwardRatingLowest: json["safetyAwardRatingLowest"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        v: json["__v"],
        project: Project.fromJson(json["project"]),
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "totalAvgManpower": totalAvgManpower.toString(),
        "totalManHoursWorked": totalManHoursWorked.toString(),
        "fatality": fatality.toString(),
        "ltiCases": ltiCases.toString(),
        "mtiCases": mtiCases.toString(),
        "fac": fac.toString(),
        "majorEnvironmentalCases": majorEnvironmentalCases.toString(),
        "animalAndInsectBiteCases": animalAndInsectBiteCases.toString(),
        "dangerousOccurrences": dangerousOccurrences.toString(),
        "nearMissIncidents": nearMissIncidents.toString(),
        "fireCases": fireCases.toString(),
        "manDaysLost": manDaysLost.toString(),
        "fr": fr.toString(),
        "sr": sr.toString(),
        "safeLtiFreeDays": safeLtiFreeDays.toString(),
        "safeLtiFreeManHours": safeLtiFreeManHours.toString(),
        "ncrPenaltyWarnings": ncrPenaltyWarnings.toString(),
        "suggestionsReceived": suggestionsReceived.toString(),
        "uaUcReportedClosed": uaUcReportedClosed.toString(),
        "tbtMeetingHours": tbtMeetingHours.toString(),
        "personsSafetyInducted": personsSafetyInducted.toString(),
        "specificSafetyTrainingHours": specificSafetyTrainingHours.toString(),
        "totalTrainingHours": totalTrainingHours.toString(),
        "safetyItemsInspections": safetyItemsInspections.toString(),
        "safetyCommitteeMeetings": safetyCommitteeMeetings.toString(),
        "internalAudits": internalAudits.toString(),
        "externalAudits": externalAudits.toString(),
        "awardsAndAppreciations": awardsAndAppreciations.toString(),
        "safetyAwardRatingHighest": safetyAwardRatingHighest.toString(),
        "safetyAwardRatingLowest": safetyAwardRatingLowest.toString(),
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "__v": v,
        "project": project.toJson(),
    };
}

// class Project {
//     String id;
//     String projectId;
//     String projectName;
//     String siteLocation;
//     String startDate;
//     String endDate;
//     String status;
//     String description;
//     String company;
//     int v;

//     Project({
//         required this.id,
//         required this.projectId,
//         required this.projectName,
//         required this.siteLocation,
//         required this.startDate,
//         required this.endDate,
//         required this.status,
//         required this.description,
//         required this.company,
//         required this.v,
//     });

//     factory Project.fromRawJson(String str) => Project.fromJson(json.decode(str));

//     String toRawJson() => json.encode(toJson());

//     factory Project.fromJson(Map<String, dynamic> json) => Project(
//         id: json["_id"],
//         projectId: json["projectId"],
//         projectName: json["projectName"],
//         siteLocation: json["siteLocation"],
//         startDate: json["startDate"],
//         endDate: json["endDate"],
//         status: json["status"],
//         description: json["description"],
//         company: json["company"],
//         v: json["__v"],
//     );

//     Map<String, dynamic> toJson() => {
//         "_id": id,
//         "projectId": projectId,
//         "projectName": projectName,
//         "siteLocation": siteLocation,
//         "startDate": startDate,
//         "endDate": endDate,
//         "status": status,
//         "description": description,
//         "company": company,
//         "__v": v,
//     };
// }
