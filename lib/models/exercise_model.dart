class ExerciseModel {
  String id;
  String name;
  String muscleGroup;
  String execution;
  String load;
  String? urlImage;

  ExerciseModel({
    required this.id,
    required this.name,
    required this.muscleGroup,
    required this.execution,
    required this.load,
  });

  ExerciseModel.fromMap(Map<String, dynamic> map)
    : id = map["id"] ?? '',
      name = map["name"] ?? '',
      muscleGroup = map["exercise"] ?? '',
      execution = map["execution"] ?? '',
      load = map["load"] ?? '',
      urlImage = map["urlImage"] ?? '';

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "exercise": muscleGroup,
      "execution": execution,
      "load": load,
      "urlImage": urlImage,
    };
  }
}
