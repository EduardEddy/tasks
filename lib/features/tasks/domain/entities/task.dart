import 'package:freezed_annotation/freezed_annotation.dart';

part 'task.freezed.dart';

@freezed
class Task with _$Task {
  const factory Task({
    required int id,
    required String title,
    String? description,
    bool? isCompleted,
  }) = _Task;
}
