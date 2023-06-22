import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_bloc/database_helper.dart';

class TodoItem {
  int? id;
  String name;
  bool done;

  TodoItem({this.id, required this.name, this.done = false});

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'done': this.done ? 1 : 0,
    };
  }

  factory TodoItem.fromMap(Map<String, dynamic> map) {
    return TodoItem(
      id: map['id'] as int,
      name: map['name'] as String,
      done: map['done'] as int == 1,
    );
  }

  TodoItem copyWith({
    int? id,
    String? name,
    bool? done,
  }) {
    return TodoItem(
      id: id ?? this.id,
      name: name ?? this.name,
      done: done ?? this.done,
    );
  }
}

class TodoController extends Cubit<List<TodoItem>> {
  TodoController() : super([]) {
    _fetchTodos();
  }

  final _todoController = StreamController<List<TodoItem>>.broadcast();
  Stream<List<TodoItem>> get todos => _todoController.stream;

  void addTodoItem(TodoItem todoItem) {
    DatabaseHelper.instance.insert(todoItem);
    _fetchTodos();
  }

  void removeTodoItem(TodoItem todoItem) {
    DatabaseHelper.instance.delete(todoItem);
    _fetchTodos();
  }

  void revertIsDone(TodoItem todoItem) {
    DatabaseHelper.instance.update(todoItem.copyWith(done: !todoItem.done));
    _fetchTodos();
  }

  void _fetchTodos() async {
    await DatabaseHelper.instance
        .getTodos()
        .then((value) => _todoController.sink.add(value));
  }
}
