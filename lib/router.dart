import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'features/tasks/presentation/screens/tasks_screen.dart';
import 'features/countries/presentation/screens/countries_screen.dart';
import 'features/tasks/presentation/screens/new_task_screen.dart';
import 'features/tasks/presentation/screens/edit_task_screen.dart';
import 'features/tasks/domain/entities/task.dart';

/// Configuración de navegación usando go_router
/// Define todas las rutas de la aplicación
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/tasks',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text('Página principal'))),
      ),
      GoRoute(path: '/tasks', builder: (context, state) => const TasksScreen()),
      GoRoute(
          path: '/countries',
          builder: (context, state) => const CountriesScreen()),
      GoRoute(
          path: '/new-task',
          builder: (context, state) => const NewTaskScreen()),
      GoRoute(
        path: '/edit-task',
        builder: (context, state) {
          final task = state.extra as Task;
          return EditTaskScreen(task: task);
        },
      ),
      // TODO: Agregar más rutas aquí
    ],
  );
}
