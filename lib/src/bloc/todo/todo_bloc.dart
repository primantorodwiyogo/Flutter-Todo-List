import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/todo.dart';
import '../../services/db_service.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(TodoInitial()) {
    List<Todo> todos = [];
    on<AddTodo>((event, emit) async {
      await DatabaseService.instance.create(
        Todo(
          createdTime: event.createdTime,
          description: event.description,
          isImportant: event.isImportant,
          number: event.number,
          title: event.title,
        ),
      );
    });

    on<UpdateTodo>((event, emit) async {
      await DatabaseService.instance.update(
        todo: event.todo,
      );
    });

    on<FetchTodos>((event, emit) async {
      todos = await DatabaseService.instance.readAllTodos();
      emit(DisplayTodos(todo: todos));
    });

    on<FetchSpecificTodo>((event, emit) async {
      Todo todo = await DatabaseService.instance.readTodo(id: event.id);
      emit(DisplaySpecificTodo(todo: todo));
    });

    on<DeleteTodo>((event, emit) async {
      await DatabaseService.instance.delete(id: event.id);
      add(const FetchTodos());
    });
  }
}
