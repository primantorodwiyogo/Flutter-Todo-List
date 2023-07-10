import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../bloc/todo/todo_bloc.dart';
import '../constants/constants.dart';
import '../models/todo.dart';
import '../widgets/custom_text.dart';

class DetailView extends StatefulWidget {
  const DetailView({super.key});

  @override
  State<DetailView> createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  final TextEditingController _newTitle = TextEditingController();
  final TextEditingController _newDescription = TextEditingController();
  bool toggleSwitch = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: BlocBuilder<TodoBloc, TodoState>(builder: (context, state) {
          if (state is DisplaySpecificTodo) {
            // Todo currentTodo = state.todo;
            return AppBar(
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  context.read<TodoBloc>().add(const FetchTodos());
                },
              ),
              centerTitle: true,
              title: CustomText(
                  text: (state.todo.isImportant == true
                          ? 'important'
                          : 'not important')
                      .toUpperCase()),
              // backgroundColor: state.color,
            );
          }
          return Center(
            child: Container(
              color: Colors.white,
              child: const Center(child: CircularProgressIndicator()),
            ),
          );
        }),
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        height: MediaQuery.of(context).size.height,
        child: BlocBuilder<TodoBloc, TodoState>(
          builder: (context, state) {
            if (state is DisplaySpecificTodo) {
              Todo currentTodo = state.todo;

              return Column(
                children: [
                  // CustomText(text: 'title'.toUpperCase()),
                  const SizedBox(height: 10),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                          title: Column(
                            children: [
                              TextFormField(
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                                initialValue: currentTodo.title.toUpperCase(),
                                enabled: false,
                                maxLines: 3,
                              ),
                              TextFormField(
                                textAlign: TextAlign.justify,
                                initialValue: currentTodo.description,
                                enabled: false,
                                maxLines: 5,
                              ),
                            ],
                          ),
                          subtitle: Align(
                            alignment: Alignment.topRight,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Create Date'),
                                CustomText(
                                    text: DateFormat.yMMMEd()
                                        .format(state.todo.createdTime)),
                              ],
                            ),
                          )),
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext cx) {
                                  return StatefulBuilder(
                                    builder: ((context, setState) {
                                      return AlertDialog(
                                        title: const Text(
                                          'Update Todo',
                                          style: TextStyle(
                                              fontSize: 25,
                                              letterSpacing: 2,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Align(
                                                alignment: Alignment.topLeft,
                                                child: Text('Title')),
                                            Flexible(
                                              child: TextFormField(
                                                decoration: InputDecoration(
                                                  hintText: currentTodo.title,
                                                  isDense: true,
                                                ),
                                                maxLines: 1,
                                                controller: _newTitle,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            const Align(
                                                alignment: Alignment.topLeft,
                                                child: Text('Description')),
                                            Flexible(
                                              child: TextFormField(
                                                controller: _newDescription,
                                                decoration: InputDecoration(
                                                  hintText: currentTodo.title,
                                                  isDense: true,
                                                ),
                                                maxLines: 2,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                const Text(
                                                    'Important / Not Important'),
                                                Switch(
                                                  value: toggleSwitch,
                                                  onChanged: (newVal) {
                                                    setState(() {
                                                      toggleSwitch = newVal;
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          ElevatedButton(
                                            style: Constants.customButtonStyle,
                                            onPressed: () {
                                              Navigator.pop(cx);
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          BlocBuilder<TodoBloc, TodoState>(
                                            builder: (context, state) {
                                              return ElevatedButton(
                                                style:
                                                    Constants.customButtonStyle,
                                                onPressed: () async {
                                                  if (_newTitle
                                                          .text.isNotEmpty &&
                                                      _newDescription
                                                          .text.isNotEmpty) {
                                                    context
                                                        .read<TodoBloc>()
                                                        .add(
                                                          UpdateTodo(
                                                            todo: Todo(
                                                              id: currentTodo
                                                                  .id,
                                                              createdTime:
                                                                  DateTime
                                                                      .now(),
                                                              description:
                                                                  _newDescription
                                                                      .text,
                                                              isImportant:
                                                                  toggleSwitch,
                                                              number:
                                                                  currentTodo
                                                                      .number,
                                                              title: _newTitle
                                                                  .text,
                                                            ),
                                                          ),
                                                        );
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                            const SnackBar(
                                                      backgroundColor: Constants
                                                          .primaryColor,
                                                      duration:
                                                          Duration(seconds: 1),
                                                      content: Text(
                                                          'Todo details updated'),
                                                    ));
                                                    Navigator.of(context)
                                                        .popUntil((route) =>
                                                            route.isFirst);
                                                    context
                                                        .read<TodoBloc>()
                                                        .add(
                                                            const FetchTodos());
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                      backgroundColor:
                                                          Colors.red,
                                                      content: Text(
                                                        "title and description fields must not be blank"
                                                            .toUpperCase(),
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ));
                                                  }
                                                },
                                                child: const Text('Update '),
                                              );
                                            },
                                          ),
                                        ],
                                      );
                                    }),
                                  );
                                });
                          },
                          child: const Text('Update')),
                      ElevatedButton(
                          onPressed: () {
                            context
                                .read<TodoBloc>()
                                .add(DeleteTodo(id: state.todo.id!));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.red,
                                duration: const Duration(milliseconds: 500),
                                content:
                                    Text('${state.todo.title} has been delete'),
                              ),
                            );
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                            context.read<TodoBloc>().add(const FetchTodos());
                          },
                          child: const Text('Delete'))
                    ],
                  )
                  //
                ],
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
