import 'dart:convert';
import '../models/models.dart';
import 'api_service.dart';

// PUBLIC_INTERFACE
/// Service for Todo CRUD operations via backend API.
class TodoService {
  final ApiService _api;
  TodoService({String? token}) : _api = ApiService(token: token);

  void updateToken(String? token) => _api.updateToken(token);

  Future<List<Todo>> list({bool? completed}) async {
    final res = await _api.get('/todos', query: completed == null ? null : {'completed': completed});
    final data = jsonDecode(res.body) as List<dynamic>;
    return data.map((e) => Todo.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Todo> create({required String title, String? description, bool completed = false}) async {
    final res = await _api.post('/todos', body: {
      'title': title,
      'description': description,
      'completed': completed,
    });
    return Todo.fromJson(jsonDecode(res.body));
  }

  Future<Todo> update(String id, {String? title, String? description, bool? completed}) async {
    final body = <String, dynamic>{};
    if (title != null) body['title'] = title;
    if (description != null) body['description'] = description;
    if (completed != null) body['completed'] = completed;
    final res = await _api.put('/todos/$id', body: body);
    return Todo.fromJson(jsonDecode(res.body));
  }

  Future<void> delete(String id) async {
    await _api.delete('/todos/$id');
  }
}
