import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple To-Do App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.red,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
      ),
      home: const TodoScreen(),
    );
  }
}

class Task {
  String id;
  String title;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });
}

class TodoScreen extends StatefulWidget {
  const TodoScreen({Key? key}) : super(key: key);

  @override
  TodoScreenState createState() => TodoScreenState();
}

class TodoScreenState extends State<TodoScreen> {
  final List<Task> _tasks = [];
  final _todoController = TextEditingController();

  @override
  void dispose() {
    _todoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do App'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _todoController,
                    decoration: const InputDecoration(
                      hintText: 'Add a new task',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _addTask,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Icon(Icons.add),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _tasks.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.task_alt,
                          size: 64,
                          color: Colors.blue.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No tasks yet. Add a new task!',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _tasks.length,
                    itemBuilder: (context, index) {
                      return _buildTaskItem(_tasks[index]);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showDeleteCompletedDialog();
        },
        child: const Icon(Icons.cleaning_services),
      ),
    );
  }

  Widget _buildTaskItem(Task task) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Checkbox(
          value: task.isCompleted,
          activeColor: Colors.blue,
          onChanged: (value) {
            setState(() {
              task.isCompleted = value ?? false;
            });
          },
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            color: task.isCompleted ? Colors.grey : Colors.black,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => _deleteTask(task),
        ),
      ),
    );
  }

  void _addTask() {
    final title = _todoController.text.trim();
    if (title.isNotEmpty) {
      setState(() {
        _tasks.add(
          Task(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            title: title,
          ),
        );
        _todoController.clear();
      });
    }
  }

  void _deleteTask(Task task) {
    setState(() {
      _tasks.removeWhere((t) => t.id == task.id);
    });
  }

  void _showDeleteCompletedDialog() {
    if (_tasks.any((task) => task.isCompleted)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Delete Completed Tasks'),
          content: const Text('Do you want to delete all completed tasks?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _tasks.removeWhere((task) => task.isCompleted);
                });
                Navigator.pop(context);
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No completed tasks to delete'),
          backgroundColor: Colors.blue,
        ),
      );
    }
  }
}
