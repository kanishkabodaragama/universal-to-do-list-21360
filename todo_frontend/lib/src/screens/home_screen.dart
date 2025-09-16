import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/auth_provider.dart';
import '../providers/todo_provider.dart';
import '../routes.dart';
import '../widgets/todo_list_tile.dart';

// PUBLIC_INTERFACE
/// Main screen showing list of Todos, FAB to add, bottom navigation to filter.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Initial load of todos after build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      if (auth.isAuthenticated) {
        context.read<TodoProvider>().refresh();
      } else {
        Navigator.of(context).pushReplacementNamed(Routes.login);
      }
    });
  }

  Future<void> _openForm({Todo? todo}) async {
    await Navigator.of(context).pushNamed(Routes.todoForm, arguments: {'todo': todo});
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TodoProvider>();
    final auth = context.watch<AuthProvider>();
    final loading = provider.loading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Todos'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: loading ? null : provider.refresh,
            icon: const Icon(Icons.refresh_rounded),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.person_outline_rounded),
            onSelected: (value) async {
              if (value == 'logout') {
                await context.read<AuthProvider>().logout();
                if (mounted) Navigator.of(context).pushReplacementNamed(Routes.login);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'user',
                enabled: false,
                child: Text(auth.user?.email ?? 'Unknown user'),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout_rounded, size: 18),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: RefreshIndicator(
            onRefresh: provider.refresh,
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : provider.todos.isEmpty
                    ? const _EmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: provider.todos.length,
                        itemBuilder: (context, index) {
                          final todo = provider.todos[index];
                          return TodoListTile(
                            todo: todo,
                            onToggle: (t, completed) => provider.toggleComplete(t, completed),
                            onEdit: (t) => _openForm(todo: t),
                            onDelete: (t) async {
                              final ok = await _confirmDelete(context);
                              if (ok && context.mounted) {
                                await context.read<TodoProvider>().remove(t.id);
                              }
                            },
                          );
                        },
                      ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        child: const Icon(Icons.add_rounded),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: provider.filter.index,
        onDestinationSelected: (idx) => provider.setFilter(TodoFilter.values[idx]),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.list_alt_rounded), label: 'All'),
          NavigationDestination(icon: Icon(Icons.radio_button_unchecked), label: 'Active'),
          NavigationDestination(icon: Icon(Icons.check_circle_outline_rounded), label: 'Completed'),
        ],
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Todo'),
        content: const Text('Are you sure you want to delete this todo?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final secondary = Theme.of(context).colorScheme.secondary;
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Icon(Icons.inbox_outlined, size: 64, color: secondary),
            const SizedBox(height: 16),
            const Text(
              'No todos yet',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tap the + button to add your first todo.',
              style: TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
