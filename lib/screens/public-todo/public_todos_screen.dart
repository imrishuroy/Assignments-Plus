import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todo/blocs/public-todo/publictodo_bloc.dart';
import 'package:flutter_todo/config/paths.dart';
import 'package:flutter_todo/models/public_todos.dart';
import 'package:flutter_todo/screens/public-todo/add_edit_public_todos.dart';
import 'package:flutter_todo/screens/public-todo/widgets/public_todo_item.dart';
import 'package:flutter_todo/screens/public-todo/public_todos.details.dart';
import 'package:flutter_todo/widgets/deleted_todo_snackbar.dart';

class PublicTodosScreen extends StatelessWidget {
  PublicTodosScreen({Key? key}) : super(key: key);
  final CollectionReference publicTodos =
      FirebaseFirestore.instance.collection(Paths.public);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AddEditPublicTodoScreen.routeName);
        },
        child: Icon(Icons.add),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<PublictodoBloc, PublictodoState>(
              listener: (context, state) {},
              builder: (context, state) {
                if (state is PublictodoLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is PublicTodosLoaded) {
                  final todos = state.todos;
                  return ListView.builder(
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      final PublicTodo publicTodo = todos[index];
                      return PublicTodoItem(
                        todo: publicTodo,
                        onTap: () async {
                          final removedTodo = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => PublicTodoDetailsScreen(
                                id: publicTodo.todoId,
                              ),
                            ),
                          );
                          if (removedTodo != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              DeleteTodoSnackBar(
                                title: publicTodo.title,
                                onUndo: () =>
                                    BlocProvider.of<PublictodoBloc>(context)
                                        .add(AddPublicTodo(publicTodo)),
                              ),
                            );
                          }
                        },
                      );
                    },
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
