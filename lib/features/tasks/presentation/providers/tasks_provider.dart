import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../../data/repositories/task_repository_impl.dart';
import '../../data/datasources/remote_task_datasource.dart';
import '../../data/datasources/local_task_datasource.dart';

// Provider para el datasource remoto
final remoteTaskDatasourceProvider = Provider((ref) => RemoteTaskDatasource());

// Provider para el datasource local con manejo de errores
final localTaskDatasourceProvider = Provider<LocalTaskDatasource>((ref) {
  try {
    final datasource = LocalTaskDatasource();
    return datasource;
  } catch (e) {
    debugPrint('TasksProvider: Error al crear LocalTaskDatasource: $e');
    rethrow;
  }
});

// Provider para el repositorio con manejo de errores
final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  try {
    final remoteDataSource = ref.read(remoteTaskDatasourceProvider);
    final localDataSource = ref.read(localTaskDatasourceProvider);

    final repository = TaskRepositoryImpl(
      remoteDatasource: remoteDataSource,
      localDatasource: localDataSource,
    );

    return repository;
  } catch (e, stackTrace) {
    debugPrint('TasksProvider: Error al crear TaskRepositoryImpl: $e');
    debugPrint('TasksProvider: Stack trace: $stackTrace');
    rethrow;
  }
});

// AsyncNotifierProvider para manejar el estado
final taskNotifierProvider =
    AsyncNotifierProvider<TaskNotifier, List<Task>>(() {
  return TaskNotifier();
});

class TaskNotifier extends AsyncNotifier<List<Task>> {
  late final TaskRepository repository;

  @override
  Future<List<Task>> build() async {
    try {
      repository = ref.read(taskRepositoryProvider);
      final localTasks = await repository.getLocalTasks();
      final remoteTasks = await repository.getTasks();
      final allTasks = [...remoteTasks, ...localTasks];
      return allTasks;
    } catch (e, stackTrace) {
      debugPrint('TaskNotifier: Error al construir el estado: $e');
      debugPrint('TaskNotifier: Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<void> addTask(Task task) async {
    try {
      state = const AsyncLoading();
      await repository.addTask(task);
      final tasks = await repository.getLocalTasks();
      state = AsyncData(tasks);
    } catch (e, stackTrace) {
      debugPrint('TaskNotifier: Error al agregar tarea: $e');
      debugPrint('TaskNotifier: Stack trace: $stackTrace');
      state = AsyncError(e, stackTrace);
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      await repository.updateTask(task);

      state = const AsyncLoading();
      final tasks = await repository.getLocalTasks();
      state = AsyncData(tasks);
    } catch (e, stackTrace) {
      debugPrint('TaskNotifier: Error al actualizar tarea: $e');
      state = AsyncError(e, stackTrace);
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      await repository.deleteTask(id);

      state = const AsyncLoading();
      final tasks = await repository.getLocalTasks();
      state = AsyncData(tasks);
    } catch (e, stackTrace) {
      debugPrint('TaskNotifier: Error al eliminar tarea: $e');
      state = AsyncError(e, stackTrace);
    }
  }
}
