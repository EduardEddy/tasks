import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/task.dart';

part 'task_model.freezed.dart';
part 'task_model.g.dart';

@freezed
class TaskModel with _$TaskModel {
  const factory TaskModel({
    required int id,
    required String title,
    String? description,
    @JsonKey(fromJson: _boolFromJson, toJson: _boolToJson)
    @Default(false)
    bool isCompleted,
  }) = _TaskModel;

  factory TaskModel.fromJson(Map<String, dynamic> json) =>
      _$TaskModelFromJson(json);

  factory TaskModel.fromEntity(Task task) {
    return TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      isCompleted: task.isCompleted ?? false,
    );
  }
}

bool _boolFromJson(dynamic value) =>
    value == true || value == 1 || value == '1';

int _boolToJson(bool value) => value ? 1 : 0;

extension TaskModelX on TaskModel {
  Task toEntity() {
    return Task(
      id: id,
      title: title,
      description: description,
      isCompleted: isCompleted,
    );
  }

  Map<String, dynamic> toSqliteJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }
}
