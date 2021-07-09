import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_todo/blocs/public-todo/publictodo_bloc.dart';
import 'package:flutter_todo/models/public_todos.dart';
import 'package:flutter_todo/repositories/auth/auth_repository.dart';
import 'package:flutter_todo/repositories/utils/util_repository.dart';
import 'package:flutter_todo/screens/public-todo/add_edit_public_todos.dart';
import 'package:intl/intl.dart';
import 'dart:core';
import 'package:url_launcher/url_launcher.dart';

class PublicTodoDetailsScreen extends StatelessWidget {
  final String? id;

  PublicTodoDetailsScreen({Key? key, @required this.id}) : super(key: key);

  Future<void> _onOpen(LinkableElement link) async {
    await launch(link.url);
  }

  final DateFormat format = DateFormat('dd MMM yy  hh:mm a');

  void _deleteTodo(BuildContext context, PublicTodo todo) async {
    final utils = context.read<UitilsRepository>();
    final bool result = await utils.askToRemove(context);
    if (result) {
      BlocProvider.of<PublictodoBloc>(context).add(DeletePublicTodo(todo));
      Navigator.pop(context, todo);
    }
  }

  @override
  Widget build(BuildContext context) {
    final _authRepo = context.read<AuthRepository>();
    return BlocBuilder<PublictodoBloc, PublictodoState>(
      builder: (context, state) {
        print('this is state of public todos details ----- $state');
        if (state is PublictodoLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is PublicTodosLoaded) {
          if (state.todos.isNotEmpty) {
            final todo = state.todos.firstWhere((todo) => todo.todoId == id);

            return Scaffold(
              appBar: AppBar(
                title: Text('Todo Details'),
                actions: [
                  if (_authRepo.userId == todo.authorId)
                    IconButton(
                      tooltip: 'Delete Todo',
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deleteTodo(context, todo);
                      },
                    )
                ],
              ),
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
                child: ListView(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.only(
                                  top: 8.0,
                                  bottom: 16.0,
                                ),
                                child: Text(
                                  '${todo.title}',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              SelectableLinkify(
                                onOpen: _onOpen,
                                options: LinkifyOptions(humanize: false),
                                text: todo.todo!,
                                style: Theme.of(context).textTheme.subtitle1,
                                linkStyle: TextStyle(color: Colors.blue),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                tooltip: 'Edit Todo',
                child: Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return AddEditPublicTodoScreen(
                          onSave: (title, todoString) {
                            BlocProvider.of<PublictodoBloc>(context).add(
                              UpdatePublicTodo(
                                todo.copyWith(
                                  title: title,
                                  todo: todoString,
                                ),
                              ),
                            );
                          },
                          isEditing: true,
                          todo: todo,
                        );
                      },
                    ),
                  );
                },
              ),
            );
          } else {
            return Container();
          }
        } else {
          return Container();
        }
      },
    );
  }
}

// 2021-06-12 18:15:40.444249
// 2021-06-12 18:15:40.444
