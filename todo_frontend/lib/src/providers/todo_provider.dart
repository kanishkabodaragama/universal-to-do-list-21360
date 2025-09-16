import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../services/todo_service.dart';

// PUBLIC_INTERFACE
/// Filter options for the bottom navigation.
enum TodoFilter { all, active, completed }

// PUBLIC_INTERFACE
/// Provider managing todo list state, current filter, and CRUD operations.
class TodoProvider extends ChangeNotifier {
  final TodoService _service;
  TodoFilter _filter = TodoFilter.all;
  bool _loading = false;
  List<Todo> _todos = [];

  TodoProvider(String? token) : _service = TodoService(token: token);

  void updateToken(String? token) => _service.updateToken(token);

  TodoFilter get filter => _filter;
  bool get loading => _loading;
  List<Todo> get todos => _todos;

  // PUBLIC_INTERFACE
  /// Refresh the list applying the current filter.
  Future<void> refresh() async {
    _loading = true;
    notifyListeners();
    try {
      List<Todo> fetched;
      switch (_filter) {
        case TodoFilter.active:
          fetched = await _service.list(completed: false);
          break;
        case TodoFilter.completed:
          fetched = await _service.list(completed: true);
          break;
        case TodoFilter.all:
        default:
          fetched = await _service.list();
      }
      _todos = fetched;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void setFilter(TodoFilter filter) {
    _filter = filter;
    refresh();
  }

  Future<void> add(String title, String? description) async {
    final todo = await _service.create(title: title, description: description);
    _todos = [todo, ..._todos];
    notifyListeners();
  }

  Future<void> toggleComplete(Todo todo, bool completed) async {
    final updated = await _service.update(todo.id, completed: completed);
    _todos = _todos.map((t) => t.id == todo.id ? updated : t).toList();
    notifyListeners();
  }

  Future<void> edit(Todo todo, {required String title, String? description, bool? completed}) async {
    final updated = await _service.update(todo.id, title: title, description: description, completed: completed);
    _todos = _todos.map((t) => t.id == todo.id ? updated : t).toList();
    notifyListeners();
  }

  Future<void> remove(String id) async {
    await _service.delete(id);
    _todos = _todos.where((t) => t.id != id).toList();
    notifyListeners();
  }
}
