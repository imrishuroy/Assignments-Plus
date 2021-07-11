import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todo/blocs/filtered-bloc/flitered_bloc.dart';
import 'package:flutter_todo/blocs/todo/todo_bloc.dart';
import 'package:flutter_todo/models/todo_model.dart';
import 'package:flutter_todo/repositories/auth/auth_repository.dart';
import 'package:flutter_todo/repositories/todo/todo_repository.dart';

import 'package:flutter_todo/screens/todos/todos_details_screen.dart';
import 'package:flutter_todo/widgets/deleted_todo_snackbar.dart';
import 'package:flutter_todo/widgets/search_items.dart';

import 'package:flutter_todo/widgets/todo_item.dart';

class FilteredTodos extends StatefulWidget {
  final String userId;

  // static const String routeName = '/filter';

  // static Route route() {
  //   return MaterialPageRoute(
  //     settings: RouteSettings(name: routeName),
  //     builder: (_) => FilteredTodos(),
  //   );
  // }

  FilteredTodos({Key? key, required this.userId}) : super(key: key);

  @override
  _FilteredTodosState createState() => _FilteredTodosState();
}

class _FilteredTodosState extends State<FilteredTodos> {
  bool _searching = false;
  String _searchKeyword = '';

  final _searchController = TextEditingController();

  Future<void> _signOut(BuildContext context) async {
    final result = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Sign Out'),
        content: Text('Do you want to sign out of the app?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Yes',
              style: TextStyle(color: Colors.red),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'No',
              style: TextStyle(color: Colors.green),
            ),
          )
        ],
      ),
    );
    print(result);
    if (result) {
      RepositoryProvider.of<AuthRepository>(context, listen: false).signOut();
      // Navigator.of(context).pushNamed('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    final _todoRepo = context.read<TodosRepository>();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 18.0,
            vertical: 14.0,
          ),
          child: TextField(
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                print(value);
                if (value.length > 0) {
                  _searchKeyword = value;
                  _searching = true;
                } else {
                  _searching = false;
                }

                print(_searching);
              });
            },
            decoration: InputDecoration(
              hintText: 'Search your todos',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              suffixIcon: _searching
                  ? InkWell(
                      onTap: () {
                        _searchController.clear();
                        setState(() {
                          _searching = false;
                        });
                      },
                      child: Icon(Icons.clear),
                    )
                  : Icon(
                      Icons.search,
                      color: Colors.green,
                    ),
            ),
          ),
        ),
        _searching
            ? StreamBuilder<List<Todo>>(
                stream: _todoRepo.searchTodos(_searchKeyword, widget.userId),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Expanded(
                      child: Center(
                        child: Text('Someting went wrong :('),
                      ),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        final todo = snapshot.data?[index];

                        if (todo == null) {
                          return Center(
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  _searching = false;
                                });
                              },
                              child: Text('We Found Nothing Found :('),
                            ),
                          );
                        } else {
                          return SearchItems(
                            todo: todo,
                            onTap: () async {
                              final removedTodo =
                                  await Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) {
                                  return TodoDetailsScreen(id: todo.id);
                                }),
                              );
                              if (removedTodo != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  DeleteTodoSnackBar(
                                    title: todo.title,
                                    onUndo: () =>
                                        BlocProvider.of<TodosBloc>(context)
                                            .add(AddTodo(todo)),
                                  ),
                                );
                              }
                            },
                          );
                        }
                      },
                    ),
                  );
                })
            : BlocBuilder<FilteredTodosBloc, FilteredTodosState>(
                builder: (context, state) {
                  if (state is FilteredTodosLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is FilteredTodosLoaded) {
                    final todos = state.filteredTodos;
                    return Expanded(
                      child: ListView.builder(
                        itemCount: todos.length,
                        itemBuilder: (context, index) {
                          final todo = todos[index];
                          print(todo);
                          return TodoItem(
                            todo: todo,
                            onDelete: () {
                              BlocProvider.of<TodosBloc>(context)
                                  .add(DeleteTodo(todo));
                              ScaffoldMessenger.of(context).showSnackBar(
                                DeleteTodoSnackBar(
                                  title: todo.title,
                                  onUndo: () =>
                                      BlocProvider.of<TodosBloc>(context)
                                          .add(AddTodo(todo)),
                                ),
                              );
                            },
                            onTap: () async {
                              final removedTodo =
                                  await Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) {
                                  return TodoDetailsScreen(id: todo.id);
                                }),
                              );
                              if (removedTodo != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  DeleteTodoSnackBar(
                                    title: todo.title,
                                    onUndo: () =>
                                        BlocProvider.of<TodosBloc>(context)
                                            .add(AddTodo(todo)),
                                  ),
                                );
                              }
                            },
                            onCheckboxChanged: (_) {
                              BlocProvider.of<TodosBloc>(context).add(
                                UpdateTodo(
                                    todo.copyWith(completed: !todo.completed)),
                              );
                            },
                          );
                        },
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
      ],
    );
  }
}
