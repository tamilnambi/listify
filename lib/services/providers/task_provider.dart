import 'package:flutter/material.dart';
import 'package:listify/util/app_logger.dart';
import 'package:listify/util/shared_preferences_service.dart';
import '../../util/enums.dart';
import '../database/task_service.dart';

class TaskProvider with ChangeNotifier {

  final TaskService taskService;

  TaskProvider({required this.taskService});

  AuthState _state = AuthState.loading;
  String _message = '';
  List<Map<String, dynamic>> _tasks = [];

  List<Map<String, dynamic>> get tasks => _tasks;
  AuthState get state => _state;
  String get message => _message;

  // Fetch tasks for the current authenticated user
  Future<void> fetchTasks() async {
    try {
      _state = AuthState.loading;
      notifyListeners();

      final String? userId = SharedPreferencesService.prefs!.getString(SharedPreferencesService.userId);
      if (userId == null) {
        _state = AuthState.failed;
        _message = 'User ID not found';
        notifyListeners();
        return;  // Exit early if no userId found
      }

      _tasks = await taskService.fetchTasks(userId);
      _state = AuthState.success;
      notifyListeners();
    } catch (e) {
      _state = AuthState.failed;
      _message = e.toString();
      AppLogger().logError('Error fetching tasks: $e');
      notifyListeners();
    }
  }

  // Add a new task for the current authenticated user
  Future<void> addTask(String task) async {
    try {
      _state = AuthState.loading;
      notifyListeners();

      final String? userId = SharedPreferencesService.prefs!.getString(SharedPreferencesService.userId);
      if (userId == null) {
        _state = AuthState.failed;
        _message = 'User ID not found';
        notifyListeners();
        return;  // Exit early if no userId found
      }

      await taskService.addTask(task: task, userId: userId);
      await fetchTasks();  // Reload the tasks after adding
      _state = AuthState.success;
      notifyListeners();
    } catch (e) {
      _state = AuthState.failed;
      _message = e.toString();
      AppLogger().logError('Error adding task: $e');
      notifyListeners();
    }
  }

  // Update the task status (completed)
  Future<void> toggleTaskCompletion(String taskId, bool completed) async {
    try {
      _state = AuthState.loading;
      notifyListeners();

      final String? userId = SharedPreferencesService.prefs!.getString(SharedPreferencesService.userId);
      if (userId == null) {
        _state = AuthState.failed;
        _message = 'User ID not found';
        notifyListeners();
        return;  // Exit early if no userId found
      }

      await taskService.updateTask(taskId, completed, userId );
      await fetchTasks();  // Reload the tasks after updating
      _state = AuthState.success;
      notifyListeners();
    } catch (e) {
      _state = AuthState.failed;
      _message = e.toString();
      AppLogger().logError('Error updating task: $e');
      notifyListeners();
    }
  }

  // Delete a task
  Future<void> deleteTask(String taskId) async {
    try {
      _state = AuthState.loading;
      notifyListeners();

      final String? userId = SharedPreferencesService.prefs!.getString(SharedPreferencesService.userId);
      if (userId == null) {
        _state = AuthState.failed;
        _message = 'User ID not found';
        notifyListeners();
        return;  // Exit early if no userId found
      }

      await taskService.deleteTask(userId, taskId);
      await fetchTasks();  // Reload the tasks after deletion
      _state = AuthState.success;
      notifyListeners();
    } catch (e) {
      _state = AuthState.failed;
      _message = e.toString();
      AppLogger().logError('Error deleting task: $e');
      notifyListeners();
    }
  }
}
