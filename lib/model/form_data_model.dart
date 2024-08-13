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
  final String id;
  final String headers;
  final String type;
  final String? endpoint;
  final String? key;

  PageField({
    required this.id,
    required this.headers,
    required this.type,
    this.endpoint,
    this.key,
  });

  factory PageField.fromJson(Map<String, dynamic> json) {
    return PageField(
      id: json['_id'],
      headers: json['Headers'],
      type: json['Type'],
      endpoint: json['endpoint'],
      key: json['key'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'Headers': headers,
      'Type': type,
      'endpoint': endpoint,
      'key': key,
    };
  }
}
