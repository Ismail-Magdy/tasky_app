class TaskModel {
  static const String collection = "Tasks";
  String? id;
  String? title;
  String? description;
  int? priority;
  DateTime? date;
  bool? isDone;

  TaskModel({
    this.id,
    this.title,
    this.description,
    this.priority,
    this.date,
    this.isDone,
  });

  Map<String, dynamic> toJson() {
    final normalizedDate = DateTime(date!.year, date!.month, date!.day);
    return {
      "id": id,
      "title": title,
      "description": description,
      "priority": priority,
      "date": normalizedDate.millisecondsSinceEpoch,
      "isDone": false,
    };
  }

  TaskModel.fromJson(Map<String, dynamic> json)
    : this(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        priority: json["priority"],
        date: json["date"] != null
            ? DateTime.fromMillisecondsSinceEpoch(json["date"])
            : null,
        isDone: json["isDone"],
      );
}
