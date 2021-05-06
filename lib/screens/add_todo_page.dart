import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todo/models/app_user_model.dart';
import 'package:flutter_todo/repository/auth/auth_repository.dart';

class AddTodo extends StatefulWidget {
  @override
  _AddTodoState createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  final TextEditingController _textEditingController = TextEditingController();
  final CollectionReference _todos =
      FirebaseFirestore.instance.collection('todos');

  void _submit(BuildContext context) async {
    AppUser? user =
        await RepositoryProvider.of<AuthRepository>(context).currentUser;
    if (user != null) {
      _todos.add({
        '${user.uid}': _textEditingController.text,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TODO'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 50.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextField(
                    controller: _textEditingController,
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
    );
  }
}
