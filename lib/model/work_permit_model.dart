class WorkPermit {
    String id;
    String permitsType;
    int v;

    WorkPermit({
        required this.id,
        required this.permitsType,
        required this.v,
    });

    factory WorkPermit.fromJson(Map<String, dynamic> json) => WorkPermit(
        id: json["_id"],
        permitsType: json["permitsType"],
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "permitsType": permitsType,
        "__v": v,
    };
}