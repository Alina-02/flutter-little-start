class HabitMessage {
  HabitMessage({
    required this.id,
    required this.timestamp,
    required this.task,
    required this.completed,
    required this.completedDays,
  });

  final String id;
  final int timestamp;
  final String task;
  final bool completed;
  final List<dynamic> completedDays;
}
