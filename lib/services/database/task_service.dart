import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../util/const.dart';

class TaskService {

  // Fetch tasks from the database for a specific user
  Future<List<Map<String, dynamic>>> fetchTasks(String userId) async {
    try {
      final response = await http.get(Uri.parse('${Const.BASE_URL}/tasks/$userId.json'));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        List<Map<String, dynamic>> tasks = [];
        if (data != null) {
          data.forEach((key, value) {
            tasks.add({
              'id': key,
              'task': value['task'],
              'completed': value['completed'],
            });
          });
        }
        return tasks;
      } else {
        throw Exception('Failed to load tasks');
      }
    } catch (e) {
      throw Exception('Error fetching tasks: $e');
    }
  }

  // Add a new task
  Future<void> addTask({
    required String task,
    required String userId,
}) async {
    try {
      final response = await http.post(
        Uri.parse('${Const.BASE_URL}/tasks/$userId.json'),
        body: json.encode({
          'task': task,
          'completed': false,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to add task');
      }
    } catch (e) {
      throw Exception('Error adding task: $e');
    }
  }

  // Update task status (mark as completed)
  Future<void> updateTask(String id, bool completed, String userId) async {
    try {
      final response = await http.patch(
        Uri.parse('${Const.BASE_URL}/tasks/$userId/$id.json'),
        body: json.encode({
          'completed': completed,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update task');
      }
    } catch (e) {
      throw Exception('Error updating task: $e');
    }
  }

  // Delete a task
  Future<void> deleteTask(String id, String userId) async {
    try {
      final response = await http.delete(Uri.parse('${Const.BASE_URL}/tasks/$userId/$id.json'));

      if (response.statusCode != 200) {
        throw Exception('Failed to delete task');
      }
    } catch (e) {
      throw Exception('Error deleting task: $e');
    }
  }
}
