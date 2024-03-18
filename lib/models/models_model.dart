class ModelsModel {
  final String id;
  final int created;
  final String root;

  ModelsModel({
    required this.id,
    required this.root,
    required this.created,
  });

  factory ModelsModel.fromJson(Map<String, dynamic> json) {
    return ModelsModel(
      id: json["id"] as String, // Assurez-vous que "id" est de type String
      root:
          json["root"] as String, // Assurez-vous que "root" est de type String
      created:
          json["created"] as int, // Assurez-vous que "created" est de type int
    );
  }

  static List<ModelsModel> modelsFromSnapshot(List modelSnapshot) {
    return modelSnapshot.map((data) => ModelsModel.fromJson(data)).toList();
  }
}
