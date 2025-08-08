import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tasks/widgets/custom_sliver_appbar.dart';
import '../providers/tasks_provider.dart';
import '../../domain/entities/task.dart';

class TasksScreen extends ConsumerWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(taskNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          _buildAppBar(ref),
          SliverToBoxAdapter(
            child: tasksAsync.when(
              data: (tasks) => tasks.isEmpty
                  ? _buildEmptyState(context)
                  : _buildTasksList(tasks, ref, context),
              loading: () => _buildLoadingState(),
              error: (err, stack) => _buildErrorState(err, context),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  Widget _buildAppBar(WidgetRef ref) {
    return CustomSliverAppBar(
      title: 'Mis Tareas',
      backgroundIcon: Icons.task_alt,
      startColor: const Color(0xFF6C63FF),
      endColor: const Color(0xFF9F7AEA),
      expandedHeight: 140,
      titleRedirect: 'Countries',
      urlRedirect: '/countries',
    );
  }

  Widget _buildTasksList(
      List<Task> tasks, WidgetRef ref, BuildContext context) {
    final pendingTasks =
        tasks.where((task) => task.isCompleted != true).toList();
    final completedTasks =
        tasks.where((task) => task.isCompleted == true).toList();

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatsHeader(tasks, pendingTasks, completedTasks),
          const SizedBox(height: 24),
          if (pendingTasks.isNotEmpty) ...[
            _buildSectionHeader(
              'Pendientes',
              pendingTasks.length,
              Colors.orange,
              Icons.schedule_rounded,
            ),
            const SizedBox(height: 12),
            ...pendingTasks
                .map((task) => _buildTaskCard(task, ref, context, false)),
            const SizedBox(height: 24),
          ],
          if (completedTasks.isNotEmpty) ...[
            _buildSectionHeader(
              'Completadas',
              completedTasks.length,
              Colors.green,
              Icons.check_circle_outline_rounded,
            ),
            const SizedBox(height: 12),
            ...completedTasks
                .map((task) => _buildTaskCard(task, ref, context, true)),
          ],
        ],
      ),
    );
  }

  Widget _buildStatsHeader(
      List<Task> allTasks, List<Task> pendingTasks, List<Task> completedTasks) {
    final progress =
        allTasks.isEmpty ? 0.0 : completedTasks.length / allTasks.length;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF667eea),
            Color(0xFF764ba2),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667eea).withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.today_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Progreso de Hoy',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${completedTasks.length} de ${allTasks.length} tareas completadas',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Progreso',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
      String title, int count, Color color, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            count.toString(),
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTaskCard(
      Task task, WidgetRef ref, BuildContext context, bool isCompletedTask) {
    final isCompleted = isCompletedTask;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        elevation: isCompleted ? 1 : 3,
        borderRadius: BorderRadius.circular(16),
        shadowColor: Colors.black.withValues(alpha: 0.05),
        child: Container(
          decoration: BoxDecoration(
            color: isCompleted ? Colors.grey[50] : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isCompleted
                  ? Colors.grey.withValues(alpha: 0.2)
                  : Colors.grey.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            leading: GestureDetector(
              onTap: () async {
                try {
                  final updatedTask = Task(
                    id: task.id,
                    title: task.title,
                    description: task.description,
                    isCompleted: !isCompleted,
                  );

                  await ref
                      .read(taskNotifierProvider.notifier)
                      .updateTask(updatedTask);

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(isCompleted
                            ? 'Tarea marcada como pendiente'
                            : 'Tarea completada'),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error al actualizar la tarea: $e'),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                }
              },
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isCompleted ? Colors.green : Colors.grey[400]!,
                    width: 2,
                  ),
                  color: isCompleted ? Colors.green : Colors.transparent,
                ),
                child: isCompleted
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16,
                      )
                    : null,
              ),
            ),
            title: Text(
              task.title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isCompleted ? Colors.grey[600] : Colors.black87,
                decoration: isCompleted ? TextDecoration.lineThrough : null,
              ),
            ),
            subtitle: task.description != null && task.description!.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      task.description!,
                      style: TextStyle(
                        fontSize: 14,
                        color:
                            isCompleted ? Colors.grey[500] : Colors.grey[600],
                        decoration:
                            isCompleted ? TextDecoration.lineThrough : null,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                : null,
            trailing: PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert,
                color: isCompleted ? Colors.grey[400] : Colors.grey[600],
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onSelected: (value) async {
                switch (value) {
                  case 'edit':
                    context.push('/edit-task', extra: task);
                    break;
                  case 'delete':
                    try {
                      await ref
                          .read(taskNotifierProvider.notifier)
                          .deleteTask(task.id.toString());
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Tarea eliminada'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error al eliminar la tarea: $e'),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    }
                    break;
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'edit',
                  child: GestureDetector(
                    onTap: () {
                      context.push('/edit-task', extra: task);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined, size: 18),
                        SizedBox(width: 8),
                        Text('Editar'),
                      ],
                    ),
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline, size: 18, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Eliminar', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      height: 500,
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.purple[100]!,
                    Colors.blue[100]!,
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(
                Icons.task_alt,
                size: 80,
                color: Colors.purple[300],
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              '¡Empieza tu día productivo!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'No tienes tareas pendientes.\nAgrega una nueva tarea para comenzar.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6C63FF), Color(0xFF9F7AEA)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6C63FF).withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: () {
                  context.go('/new-task');
                },
                icon: const Icon(Icons.add_rounded),
                label: const Text('Crear mi primera tarea'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return SizedBox(
      height: 500,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF6C63FF).withValues(alpha: 0.1),
                    const Color(0xFF9F7AEA).withValues(alpha: 0.1),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6C63FF)),
                strokeWidth: 4,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Cargando tus tareas...',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6C63FF),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(Object err, BuildContext context) {
    return Container(
      height: 500,
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.red[50],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 80,
                color: Colors.red[400],
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Error al cargar tareas',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              err.toString(),
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFF9F7AEA)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C63FF).withValues(alpha: 0.4),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: FloatingActionButton.extended(
        onPressed: () {
          context.go('/new-task');
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text(
          'Nueva tarea',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
