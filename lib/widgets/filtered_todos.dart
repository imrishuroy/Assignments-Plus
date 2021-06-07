import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todo/blocs/filtered-bloc/flitered_bloc.dart';
import 'package:flutter_todo/blocs/todo/todo_bloc.dart';
import 'package:flutter_todo/screens/details_screen.dart';
import 'package:flutter_todo/widgets/deleted_todo_snackbar.dart';

import 'package:flutter_todo/widgets/todo_item.dart';

class FilteredTodos extends StatelessWidget {
  FilteredTodos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //  final activeTab = BlocProvider.of<TabBloc>(context);

    return Scaffold(
      body: BlocBuilder<FilteredTodosBloc, FilteredTodosState>(
        builder: (context, state) {
          if (state is FilteredTodosLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is FilteredTodosLoaded) {
            final todos = state.filteredTodos;
            return ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                return TodoItem(
                  todo: todo,
                  onDismissed: (direction) {
                    BlocProvider.of<TodosBloc>(context).add(DeleteTodo(todo));
                    ScaffoldMessenger.of(context).showSnackBar(
                      DeleteTodoSnackBar(
                        todo: todo,
                        onUndo: () => BlocProvider.of<TodosBloc>(context)
                            .add(AddTodo(todo)),
                      ),
                    );
                  },
                  onTap: () async {
                    final removedTodo = await Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) {
                        return DetailsScreen(id: todo.id);
                      }),
                    );
                    if (removedTodo != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        DeleteTodoSnackBar(
                          todo: todo,
                          onUndo: () => BlocProvider.of<TodosBloc>(context)
                              .add(AddTodo(todo)),
                        ),
                      );
                    }
                  },
                  onCheckboxChanged: (_) {
                    BlocProvider.of<TodosBloc>(context).add(
                      UpdateTodo(todo.copyWith(completed: !todo.completed)),
                    );
                  },
                );
              },
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
