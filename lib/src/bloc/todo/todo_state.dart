part of 'todo_bloc.dart';

abstract class TodoState extends Equatable {
  const TodoState();
}

class TodoInitial extends TodoState {
  @override
  List<Object> get props => [];
}

class DisplayTodos extends TodoState {
  final List<Todo> todo;

  const DisplayTodos({required this.todo});
  @override
  List<Object> get props => [todo];
}

class DisplaySpecificTodo extends TodoState {
  final Todo todo;

  const DisplaySpecificTodo({required this.todo});
  @override
  List<Object> get props => [todo];
}
