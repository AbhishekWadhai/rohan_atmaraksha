final Map<String, String> translationMap = {
  "workpermit": "Work Permit",
  "meetings": "Meetings",
  "specific": "Specific Training",
  "induction": "Safety Induction",
  "uauc": "UA & UC",
  "safetyreport": "Safety Report",
  "userId": "User Id",
  "name": "Name",
  "role": "Role",
  "topicTypes": "Topic Type",
  "phone": "Phone Number",
  "address": "Address",
  "isActive": "Is Active",
  "projectName": "Project Name",
  "createdAt": "Created At",
  "updatedAt": "Updated At",
  "status": "Status",
  "password": "Password",
  "confirmPassword": "Confirm Password",
  "resetPasswordToken": "Reset Password Token",
  "emailId": "Email Address",
  "user": "User Data",
  "permitsType": "Permt Type",
  "SafetyChecks": "Safety Checks",
  "typeOfHazard": "Type Of Hazards",
  "tools": "Tools",
  "equipments": "Equipments",
  "machineTools": "Machine Tools",
  "projectId": "Project Id",
  "siteLocation": "Site Location",
  "startDate": "Start Date",
  "endDate": "End Date",
  "company": "Company",
  "hazards": "Hazards",
  "ppes": "PPes",
  "value": "Value",
  "severity": "Severity",
  "alertTimeline": "Escalation Alert",
  "repeatWarning": "Repeat Warning",
  "roleName": "Role Name",
  "permission": "Permission",
  "description": "Description",
  "tradeTypes": "Trade Type",
  "meeting": "TBT Meeting",
  

  // Add more key-value pairs as needed
};
String translate(String key) {
  return translationMap[key] ?? key;
}
