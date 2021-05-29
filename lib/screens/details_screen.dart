import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todo/blocs/todo/todo_bloc.dart';
import 'package:flutter_todo/screens/add_edit_todo_screen.dart';

class DetailsScreen extends StatelessWidget {
  final String? id;

  DetailsScreen({Key? key, @required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodosBloc, TodosState>(
      builder: (context, state) {
        final todo = (state as TodosLoaded)
            .todos
            // .firstWhere((todo) => todo.id == id, orElse: () => null);
            .firstWhere(
              (todo) => todo.id == id,
            );
        return Scaffold(
          // backgroundColor: Color(0xff222831),
          appBar: AppBar(
            title: Text('Todo Details'),
            actions: [
              IconButton(
                tooltip: 'Delete Todo',
                icon: Icon(Icons.delete),
                onPressed: () {
                  BlocProvider.of<TodosBloc>(context).add(DeleteTodo(todo));
                  Navigator.pop(context, todo);
                },
              )
            ],
          ),
          body:
              // todo == null
              //     ? Container()
              //     :
              Padding(
            padding: EdgeInsets.all(16.0),
            child: ListView(
              children: [
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
                          Hero(
                            tag: '${todo.id}__heroTag',
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.only(
                                top: 8.0,
                                bottom: 16.0,
                              ),
                              child: Text(
                                todo.todo,
                                style: Theme.of(context).textTheme.headline5,
                              ),
                            ),
                          ),
                          Text(
                            todo.todo,
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          SizedBox(height: 20.0),
                          Container(
                            height: 250.0,
                            width: 250.0,
                            child: CachedNetworkImage(imageUrl: todo.imageUrl),
                          )
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
            onPressed:
                //  todo == null
                //     ? null
                //     :
                () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return AddEditScreen(
                      onSave: (todoString, imageUrl) {
                        BlocProvider.of<TodosBloc>(context).add(
                          UpdateTodo(
                            todo.copyWith(todo: todoString),
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
