import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/todo_provider.dart';
import '../widgets/primary_button.dart';

// PUBLIC_INTERFACE
/// Todo creation/editing form screen. Accepts an optional Todo to edit.
class TodoFormScreen extends StatefulWidget {
  final Todo? todo;
  const TodoFormScreen({super.key, this.todo});

  @override
  State<TodoFormScreen> createState() => _TodoFormScreenState();
}

class _TodoFormScreenState extends State<TodoFormScreen> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _description;
  bool _completed = false;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.todo?.title ?? '');
    _description = TextEditingController(text: widget.todo?.description ?? '');
    _completed = widget.todo?.completed ?? false;
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _submitting = true);
    final provider = context.read<TodoProvider>();
    try {
      if (widget.todo == null) {
        await provider.add(_title.text.trim(), _description.text.trim().isEmpty ? null : _description.text.trim());
      } else {
        await provider.edit(
          widget.todo!,
          title: _title.text.trim(),
          description: _description.text.trim().isEmpty ? null : _description.text.trim(),
          completed: _completed,
        );
      }
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save todo'), behavior: SnackBarBehavior.floating),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.todo != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Todo' : 'New Todo'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Form(
                  key: _form,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _title,
                        decoration: const InputDecoration(
                          labelText: 'Title',
                          prefixIcon: Icon(Icons.title_rounded),
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Title is required' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _description,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          prefixIcon: Icon(Icons.notes_rounded),
                        ),
                        minLines: 2,
                        maxLines: 4,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Checkbox(
                            value: _completed,
                            onChanged: (v) => setState(() => _completed = v ?? false),
                          ),
                          const Text('Completed'),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _submitting ? null : () => Navigator.of(context).maybePop(),
                              icon: const Icon(Icons.close_rounded),
                              label: const Text('Cancel'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: PrimaryButton(
                              label: isEdit ? 'Save' : 'Add',
                              loading: _submitting,
                              icon: isEdit ? Icons.save_rounded : Icons.add_rounded,
                              onPressed: _submitting ? null : _submit,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
