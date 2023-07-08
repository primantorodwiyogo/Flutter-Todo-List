import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/todo/todo_bloc.dart';
import '../widgets/custom_text.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();
  bool toggleSwitch = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(8),
          height: MediaQuery.of(context).size.height,
          child: Card(
            elevation: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(text: 'title'.toUpperCase()),
                TextFormField(controller: _title),
                CustomText(text: 'description'.toUpperCase()),
                TextFormField(controller: _description),
                CustomText(text: 'important'.toUpperCase()),
                Switch(
                  value: toggleSwitch,
                  onChanged: (newVal) {
                    setState(() {
                      toggleSwitch = !toggleSwitch;
                    });
                  },
                ),
                BlocBuilder<TodoBloc, TodoState>(
                  builder: (context, state) {
                    return ElevatedButton(
                        onPressed: () {
                          if (_title.text.isNotEmpty &&
                              _description.text.isNotEmpty) {
                            context.read<TodoBloc>().add(
                                  AddTodo(
                                    title: _title.text,
                                    isImportant: toggleSwitch,
                                    number: 0,
                                    description: _description.text,
                                    createdTime: DateTime.now(),
                                  ),
                                );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              backgroundColor: Colors.green,
                              duration: Duration(seconds: 1),
                              content: Text("todo added successfully"),
                            ));
                            context.read<TodoBloc>().add(const FetchTodos());
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.red,
                              content: Text(
                                "title and description fields must not be blank"
                                    .toUpperCase(),
                                style: const TextStyle(color: Colors.black),
                              ),
                            ));
                          }
                        },
                        child: const Text('Add Todo'));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
