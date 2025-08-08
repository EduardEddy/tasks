import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:tasks/core/utils/constants.dart';
import '../models/task_model.dart';

class LocalTaskDatasource {
  static Database? _database;
  static bool _isInitializing = false;
  static bool _isInitialized = false;

  Future<Database> get database async {
    if (_database != null && _isInitialized) {
      return _database!;
    }

    if (_isInitializing) {
      while (_isInitializing) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
      if (_database != null && _isInitialized) {
        return _database!;
      }
    }

    _isInitializing = true;
    _isInitialized = false;

    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, AppConstants.databaseName);

      _database = await openDatabase(
        path,
        version: 1,
        onCreate: _onCreate,
        onOpen: (db) {
          debugPrint('LocalTaskDatasource: Base de datos abierta exitosamente');
        },
        onConfigure: (db) async {
          await db.execute('PRAGMA foreign_keys = ON');
        },
      );

      _isInitialized = true;
      return _database!;
    } catch (e, stackTrace) {
      debugPrint(
          'LocalTaskDatasource: Error al inicializar la base de datos: $e');
      debugPrint('LocalTaskDatasource: Stack trace: $stackTrace');
      _isInitialized = false;
      rethrow;
    } finally {
      _isInitializing = false;
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    try {
      await db.execute('''
        CREATE TABLE tasks (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          description TEXT,
          isCompleted INTEGER DEFAULT 0
        )
      ''');
    } catch (e) {
      debugPrint('LocalTaskDatasource: Error al crear la tabla: $e');
      rethrow;
    }
  }

  Future<List<TaskModel>> getTasks() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query('tasks');

      final tasks = maps.map((map) {
        try {
          return TaskModel.fromJson(map);
        } catch (e) {
          debugPrint(
              'LocalTaskDatasource: Error al convertir mapa a TaskModel: $e');
          debugPrint('LocalTaskDatasource: Mapa problemático: $map');
          rethrow;
        }
      }).toList();

      return tasks;
    } catch (e, stackTrace) {
      debugPrint('LocalTaskDatasource: Error al obtener tareas: $e');
      debugPrint('LocalTaskDatasource: Stack trace: $stackTrace');
      return [];
    }
  }

  Future<void> saveTask(TaskModel task) async {
    try {
      final db = await database;

      final taskMap = task.toSqliteJson();

      await db.insert(
        'tasks',
        taskMap,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e, stackTrace) {
      debugPrint('LocalTaskDatasource: Error al guardar tarea: $e');
      debugPrint('LocalTaskDatasource: Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<void> updateTask(TaskModel task) async {
    try {
      final db = await database;
      await db.update(
        'tasks',
        task.toSqliteJson(),
        where: 'id = ?',
        whereArgs: [task.id],
      );
    } catch (e, stackTrace) {
      debugPrint('LocalTaskDatasource: Error al actualizar tarea: $e');
      debugPrint('LocalTaskDatasource: Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      final db = await database;
      await db.delete(
        'tasks',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e, stackTrace) {
      debugPrint('LocalTaskDatasource: Error al eliminar tarea: $e');
      debugPrint('LocalTaskDatasource: Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
      _isInitialized = false;
      debugPrint('LocalTaskDatasource: Base de datos cerrada');
    }
  }

  // Verificar si la base de datos está inicializada
  bool get isInitialized => _isInitialized && _database != null;
}
