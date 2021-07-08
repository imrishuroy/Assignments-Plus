import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_todo/blocs/todo/todo_bloc.dart';
import 'package:flutter_todo/models/todo_model.dart';
import 'package:flutter_todo/repositories/utils/util_repository.dart';
import 'package:flutter_todo/screens/add_edit_todo_screen.dart';
import 'package:intl/intl.dart';

import 'dart:core';
import 'package:url_launcher/url_launcher.dart';

class DetailsScreen extends StatelessWidget {
  final String? id;

  DetailsScreen({Key? key, @required this.id}) : super(key: key);

  Future<void> _onOpen(LinkableElement link) async {
    await launch(link.url);
  }

  final DateFormat format = DateFormat('dd MMM yy  hh:mm a');

  void _deleteTodo(BuildContext context, Todo todo) async {
    final utils = context.read<UitilsRepository>();
    final bool result = await utils.askToRemove(context);
    if (result) {
      BlocProvider.of<TodosBloc>(context).add(DeleteTodo(todo));
      Navigator.pop(context, todo);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodosBloc, TodosState>(
      builder: (context, state) {
        final todo = (state as TodosLoaded)
            .todos
            // .firstWhere((todo) => todo.id == id, orElse: () => null);
            .firstWhere((todo) => todo.id == id);

        return Scaffold(
          appBar: AppBar(
            title: Text('Todo Details'),
            actions: [
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
                SwitchListTile.adaptive(
                  value: true,
                  title: Text('Make it public'),
                  onChanged: (value) {},
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Checkbox(
                          value: todo.completed,
                          onChanged: (_) {
                            BlocProvider.of<TodosBloc>(context).add(
                              UpdateTodo(
                                todo.copyWith(completed: !todo.completed),
                              ),
                            );
                          }),
                    ),
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
                              todo.title,
                              style: TextStyle(fontSize: 20),
                              //style: Theme.of(context).textTheme.headline5,
                            ),
                          ),
                          SelectableLinkify(
                            onOpen: _onOpen,
                            options: LinkifyOptions(humanize: false),
                            text: todo.todo,
                            style: Theme.of(context).textTheme.subtitle1,
                            linkStyle: TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                if (todo.notificationDate != null &&
                    todo.notificationDate != todo.dateTime)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Stack(
                        children: [
                          Chip(
                            label: Text(
                              '${format.format(todo.notificationDate!)}',
                            ),
                          ),
                          Positioned(
                            right: -1.7,
                            top: -1.7,
                            child: Icon(
                              Icons.notifications,
                              color: Colors.red,
                              size: 19.0,
                            ),
                          )
                        ],
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
                    return AddEditScreen(
                      onSave: (
                        title,
                        todoString,
                        dateTime, {
                        DateTime? notificationDate,
                        int? notificationId,
                      }) {
                        BlocProvider.of<TodosBloc>(context).add(
                          UpdateTodo(
                            todo.copyWith(
                              title: title,
                              todo: todoString,
                              dateTime: dateTime,
                              notificationDate: notificationDate,
                              notificationId: notificationId,
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
      },
    );
  }
}

// 2021-06-12 18:15:40.444249
// 2021-06-12 18:15:40.444
