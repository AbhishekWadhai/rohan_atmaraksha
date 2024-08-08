class ResponseForm {
  String id;
  String page;
  List<PageField> pageFields;
  int v;

  ResponseForm({
    required this.id,
    required this.page,
    required this.pageFields,
    required this.v,
  });

  factory ResponseForm.fromJson(Map<String, dynamic> json) => ResponseForm(
        id: json["_id"],
        page: json["Page"],
        pageFields: List<PageField>.from(
            json["PageFields"].map((x) => PageField.fromJson(x))),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "Page": page,
        "PageFields": List<dynamic>.from(pageFields.map((x) => x.toJson())),
        "__v": v,
      };
}

class PageField {
  String headers;
  String type;
  String id;

  PageField({
    required this.headers,
    required this.type,
    required this.id,
  });

  factory PageField.fromJson(Map<String, dynamic> json) => PageField(
        headers: json["Headers"],
        type: json["Type"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "Headers": headers,
        "Type": type,
        "_id": id,
      };
}
