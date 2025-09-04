class ExerciseModel {
  String id;
  String name;
  String exercise;
  String execution;

  String? urlImage;

  ExerciseModel({
    required this.id,
    required this.name,
    required this.exercise,
    required this.execution,
  });

  ExerciseModel.fromMap(Map<String, dynamic> map)
    : id = map["id"],
      name = map["name"],
      exercise = map["exercise"],
      execution = map["note"],
      urlImage = map["urlImage"];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "exercise": exercise,
      "note": execution,
      "urlImage": urlImage,
    };
  }
}
