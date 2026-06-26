class TaskModel {
  int? id;
  String name;
  String date;
  String time;
  String description;

  TaskModel({
    this.id,
    required this.name,
    required this.date,
    required this.time,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'date': date,
      'time': time,
      'description': description,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      name: map['name'],
      date: map['date'],
      time: map['time'],
      description: map['description'],
    );
  }
}