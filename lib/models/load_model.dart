class LoadModel {
  String id;
  String load;
  String date;

  LoadModel({required this.id, required this.load, required this.date});

  LoadModel.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        load = map["load"],
        date = map["date"];

  Map<String, dynamic> toMap() {
    return {"id": id, "load": load, "date": date};
  }
}