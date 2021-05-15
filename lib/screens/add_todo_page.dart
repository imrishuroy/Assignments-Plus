import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todo/models/app_user_model.dart';
import 'package:flutter_todo/models/todo.dart';
import 'package:flutter_todo/repository/auth/auth_repository.dart';
import 'package:uuid/uuid.dart';

import '../blocs/todo/todo_bloc.dart';
import '../blocs/todo/todo_bloc.dart';
import '../blocs/todo/todo_bloc.dart';
import '../blocs/todo/todo_bloc.dart';
import '../repository/todo/firebase_todo_repository.dart';

class AddTodoScreen extends StatefulWidget {
  static const String routeName = '/addTodo';

  static Route route() {
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (context) => AddTodoScreen());
  }

  @override
  _AddTodoScreenState createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  final CollectionReference _todos =
      FirebaseFirestore.instance.collection('todos');

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String todo = '';
  void _submit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print(todo);
      BlocProvider.of<TodosBloc>(context).add(AddTodo(Todo(
        dateTime: DateTime.now(),
        todo: todo,
        id: Uuid().v4(),
      )));
      Navigator.of(context).pop();
    }

    // AppUser? user =
    //     await RepositoryProvider.of<AuthRepository>(context).currentUser;
    // if (user != null) {
    //   _todos.add({
    //     '${user.uid}': _textEditingController.text,
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TODO'),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 50.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextFormField(
                      validator: (value) =>
                          value!.isEmpty ? 'Todo cannot be blank' : null,
                      controller: _textEditingController,
                      onSaved: (value) => todo = value!,
                    ),
                  ),
                  SizedBox(height: 50.0),
                  ElevatedButton(
                    onPressed: () => _submit(context),
                    child: Text('Submit'),
                  ),
                  SizedBox(height: 50.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
