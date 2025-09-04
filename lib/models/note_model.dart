class NoteModel {
  String id;
  String note;
  String date;

  NoteModel({required this.id, required this.note, required this.date});

  NoteModel.fromMap(Map<String, dynamic> map)
    : id = map["id"],
      note = map["note"],
      date = map["date"];

  Map<String, dynamic> toMap() {
    return {"id": id, "note": note, "date": date};
  }
}
