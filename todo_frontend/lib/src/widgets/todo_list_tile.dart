import 'package:flutter/material.dart';
import '../models/models.dart';

typedef TodoToggle = void Function(Todo todo, bool completed);
typedef TodoEdit = void Function(Todo todo);
typedef TodoDelete = void Function(Todo todo);

// PUBLIC_INTERFACE
/// A stylized list tile representing a Todo item with complete toggle,
/// edit and delete actions.
class TodoListTile extends StatelessWidget {
  final Todo todo;
  final TodoToggle onToggle;
  final TodoEdit onEdit;
  final TodoDelete onDelete;

  const TodoListTile({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final secondary = Theme.of(context).colorScheme.secondary;
    return Card(
      child: ListTile(
        leading: Checkbox(
          value: todo.completed,
          onChanged: (v) => onToggle(todo, v ?? false),
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.completed ? TextDecoration.lineThrough : null,
            color: todo.completed ? Colors.grey : null,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: (todo.description?.isNotEmpty ?? false)
            ? Text(
                todo.description!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        trailing: Wrap(
          spacing: 8,
          children: [
            IconButton(
              tooltip: 'Edit',
              onPressed: () => onEdit(todo),
              icon: Icon(Icons.edit_rounded, color: secondary),
            ),
            IconButton(
              tooltip: 'Delete',
              onPressed: () => onDelete(todo),
              icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
            ),
          ],
        ),
      ),
    );
  }
}
