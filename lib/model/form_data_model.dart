import 'dart:convert';

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

    factory ResponseForm.fromRawJson(String str) => ResponseForm.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ResponseForm.fromJson(Map<String, dynamic> json) => ResponseForm(
        id: json["_id"],
        page: json["Page"],
        pageFields: List<PageField>.from(json["PageFields"].map((x) => PageField.fromJson(x))),
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
    String title;
    String headers;
    String type;
    String id;
    String? endpoint;
    String? key;
    List<String>? options;

    PageField({
        required this.title,
        required this.headers,
        required this.type,
        required this.id,
        this.endpoint,
        this.key,
        this.options,
    });

    factory PageField.fromRawJson(String str) => PageField.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory PageField.fromJson(Map<String, dynamic> json) => PageField(
        title: json["Title"],
        headers: json["Headers"],
        type: json["Type"],
        id: json["_id"],
        endpoint: json["endpoint"],
        key: json["key"],
        options: json["Options"] == null ? [] : List<String>.from(json["Options"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "Title": title,
        "Headers": headers,
        "Type": type,
        "_id": id,
        "endpoint": endpoint,
        "key": key,
        "Options": options == null ? [] : List<dynamic>.from(options!.map((x) => x)),
    };
}
