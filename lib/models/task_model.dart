class TaskModel {
  String id;
  final String title;
  final String description;

  TaskModel({
    this.id = '',
    required this.title,
    required this.description,
  });

  static TaskModel fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json["id"],
      title: json["title"],
      description: json["description"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
    };
  }
}
