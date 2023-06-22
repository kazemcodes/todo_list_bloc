import 'package:flutter/material.dart';
import 'package:todo_list_bloc/todo_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  MainScreen({super.key});
  final TextEditingController controller = TextEditingController();
  final TodoController todoController = TodoController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text("Todo List"),
      ),
      body: StreamBuilder<List<TodoItem>>(
          stream: todoController.todos,
          builder: (context, snapshot) {
            var items = snapshot.data ?? [];
            return Center(
              child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) => ListTile(
                        leading: items[index].done
                            ? Icon(Icons.check, color: Colors.green)
                            : null,
                        title: Text(items[index].name),
                        trailing: IconButton(
                          icon: Icon(Icons.delete_forever),
                          onPressed: () {
                            todoController.removeTodoItem(items[index]);
                          },
                        ),
                        onTap: () {
                          todoController.revertIsDone(items[index]);
                        },
                      )),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text("Adding a new todoItem"),
                  content: TextField(
                    controller: controller,
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Dissmiss")),
                    TextButton(
                        onPressed: () {
                          todoController
                              .addTodoItem(TodoItem(name: controller.text));
                          controller.clear();
                          Navigator.pop(context);
                        },
                        child: const Text("Add")),
                  ],
                )),
        tooltip: 'adding a new todo list',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
