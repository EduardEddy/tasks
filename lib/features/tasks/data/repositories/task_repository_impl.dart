import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/local_task_datasource.dart';
import '../datasources/remote_task_datasource.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final RemoteTaskDatasource remoteDatasource;
  final LocalTaskDatasource localDatasource;

  TaskRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
  });

  @override
  Future<List<Task>> getTasks() async {
    final models = await remoteDatasource.getTasks();
    return models.map((e) => e.toEntity()).toList();
  }

  @override
  Future<List<Task>> getLocalTasks() async {
    final models = await localDatasource.getTasks();
    return models.map((e) => e.toEntity()).toList();
  }

  @override
  Future<void> addTask(Task task) async {
    await localDatasource.saveTask(TaskModel.fromEntity(task));
  }

  @override
  Future<void> updateTask(Task task) async {
    await localDatasource.updateTask(TaskModel.fromEntity(task));
  }

  @override
  Future<void> deleteTask(String id) async {
    await localDatasource.deleteTask(int.parse(id));
  }
}
