import 'package:flutter_bloc/flutter_bloc.dart';

class TodoItem {
  int id;
  String name;
  int timeAdded;

  TodoItem(this.id, this.name, this.timeAdded);
}

class TodoController extends Cubit<List<TodoItem>> {
  TodoController()
      : super([
          TodoItem(0, "Coding", 0),
          TodoItem(1, "Shopping", 0),
          TodoItem(2, "Learning", 0),
          TodoItem(3, "Watching Movies", 0),
        ]);

  void addTodoItem(TodoItem todoItem) {
    state.add(todoItem);
    emit(state);
  }

  void removeTodoItem(TodoItem todoItem) {
    state.remove(todoItem);
    emit(state);
  }
}
