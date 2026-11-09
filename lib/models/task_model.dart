import 'package:uuid/uuid.dart';

class Task {
  final String id;
  String name;
  String? description;
  bool highPriority;
  bool isDone;
  DateTime createdAt;

  Task({
    String? id,
    required this.name,
    required this.description,
    required this.highPriority,
    this.isDone = false,
    DateTime? createdAt,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now();

  // تحويل الكائن إلى Map للحفظ
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'highPriority': highPriority,
    'isDone': isDone,
    'createdAt': createdAt.toIso8601String(),
  };

  // إنشاء كائن من Map بعد القراءة
  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json['id'] as String?,
    name: json['name'],
    description: json['description'],
    highPriority: json['highPriority'],
    isDone: json['isDone'],
    createdAt: json['createdAt'] != null
        ? DateTime.parse(json['createdAt'])
        : DateTime.now(), // دعم للمهام القديمة المحفوظة بدون تاريخ
  );
}
