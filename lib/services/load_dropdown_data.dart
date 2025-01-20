import 'package:rohan_suraksha_sathi/app_constants/app_strings.dart';

import 'package:rohan_suraksha_sathi/services/api_services.dart';

Future<void> loadDropdownData() async {
  List<String> endpoints = [
    "projects",
    "permitstype",
    "user",
    "topic",
    "RiskRating",
    "tools",
    "equipments",
    "machinetools",
    "hazards",
    "ppe",
    "trade"
  ];

  final Map<String, Function> endpointToModelParser = {
    "projects": (List data) => data,
    "permitstype": (List data) => data,
    "user": (List data) => data,
    "topic": (List data) => data,
    "RiskRating": (List data) => data,
    "tools": (List data) => data,
    "equipments": (List data) => data,
    "machinetools": (List data) => data,
    "hazards": (List data) => data,
    "ppe": (List data) => data,
    "trade": (List data) => data,
  };

  // Map each endpoint to a Future that calls the API and parses the response
  List<Future<void>> requests = endpoints.map((endpoint) async {
    try {
      final List<dynamic> response = await ApiService().getRequest(endpoint);
      final modelParser = endpointToModelParser[endpoint];
      if (modelParser != null) {
        List parsedData = modelParser(response);

        // Store the parsed data in Constants based on endpoint
        switch (endpoint) {
          case "projects":
            Strings.endpointToList["projects"] = parsedData;
            break;
          case "permitstype":
            Strings.endpointToList["permitstype"] = parsedData;
            break;
          case "user":
            if (Strings.roleName == "Admin") {
              Strings.endpointToList["user"] = parsedData;
            } else {
              // Filter users mapped to the project "Axiomos 1"
              Strings.endpointToList["user"] = parsedData.where((user) {
                // Assuming user is a Map and has a 'project' field
                return user['project']['_id'] ==
                    Strings.endpointToList['project']['_id'];
              }).toList();
            }

            Strings.endpointToList['safetyuser'] =
                parsedData.where((safetyuser) {
              return safetyuser['role']['roleName'] == "Safety";
            }).toList();
            Strings.endpointToList['managementuser'] =
                parsedData.where((safetyuser) {
              return safetyuser['role']['roleName'] == "Management";
            }).toList();
            Strings.endpointToList['exeuser'] = parsedData.where((safetyuser) {
              return safetyuser['role']['roleName'] == "Execution" && safetyuser['project']['_id'] ==
                    Strings.endpointToList['project']['_id'];
            }).toList();
            break;

          case "topic":
            Strings.endpointToList["topic"] = parsedData;
            break;
          case "equipments":
            Strings.endpointToList["equipments"] = parsedData;
            break;
          case "RiskRating":
            Strings.endpointToList["RiskRating"] = parsedData;
            break;
          case "tools":
            Strings.endpointToList["tools"] = parsedData;
          case "machinetools":
            Strings.endpointToList["machinetools"] = parsedData;
            break;
          case "hazards":
            Strings.endpointToList["hazards"] = parsedData;
            break;
          case "ppe":
            Strings.endpointToList["ppe"] = parsedData;
            break;
          case "trade":
            Strings.endpointToList["trade"] = parsedData;
            break;
        }
      }
    } catch (error) {
      print("Error loading $endpoint: $error");
    }
  }).toList();

  // Wait for all requests to complete
  await Future.wait(requests);

  print(
      "==============================================================User dropdown data loaded into Constants. ${Strings.endpointToList['user']}=============================================================================");
}
