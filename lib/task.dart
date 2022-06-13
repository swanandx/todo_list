class Task {
  final String title;
  bool isDone;

  Task({required this.title, this.isDone = false});

  Task.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        isDone = json['isDone'];

  Map<String, dynamic> toJson() => {
        'title': title,
        'isDone': isDone,
      };
}
