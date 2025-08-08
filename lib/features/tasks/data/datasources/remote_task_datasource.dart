import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tasks/core/utils/constants.dart';
import '../models/task_model.dart';

class RemoteTaskDatasource {
  final _baseUrl = AppConstants.baseUrl;

  Future<List<TaskModel>> getTasks() async {
    final response = await Dio().get('$_baseUrl/todos');
    try {
      final List data = response.data;
      return data.map((e) => TaskModel.fromJson(e)).skip(180).toList();
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Error loading tasks');
    }
  }
}
