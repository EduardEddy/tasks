import '../entities/task.dart';
import '../repositories/task_repository.dart';

class GetTasks {
  final TaskRepository repository;

  GetTasks(this.repository);

  Future<List<Task>> call() => repository.getTasks();
}
