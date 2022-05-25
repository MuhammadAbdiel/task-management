import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  String id;
  String image;
  final String title;
  final String description;
  final DateTime date;

  TaskModel({
    this.id = '',
    this.image = '',
    required this.title,
    required this.description,
    required this.date,
  });

  static TaskModel fromJson(Map<String, dynamic> json) {
    return TaskModel(
        id: json["id"],
        image: json['image'],
        title: json["title"],
        description: json["description"],
        date: (json['date'] as Timestamp).toDate());
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      'image': image,
      "title": title,
      "description": description,
      'date': date,
    };
  }
}
