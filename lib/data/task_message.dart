class TaskMessage {
  TaskMessage({
    required this.id,
    required this.timestamp,
    required this.task,
    required this.completed,
  });

  final String id;
  final int timestamp;
  final String task;
  final bool completed;
}
