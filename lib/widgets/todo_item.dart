import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo/models/todo_model.dart';
import 'package:flutter_todo/widgets/dismissible_background.dart';
import 'package:timeago/timeago.dart' as timeago;

class TodoItem extends StatelessWidget {
  final GestureTapCallback? onTap;
  final ValueChanged<bool?>? onCheckboxChanged;
  final Todo? todo;
  final Function? onDelete;

  TodoItem({
    Key? key,
    @required this.onTap,
    @required this.onCheckboxChanged,
    @required this.todo,
    @required this.onDelete,
  }) : super(key: key);

  Future<bool> _deleteTodo(BuildContext context) async {
    final bool res = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("Are you sure you want to delete ${todo?.title}?"),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'Cancel',
                  style: const TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              TextButton(
                child: Text(
                  'Delete',
                  style: const TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  onDelete!();

                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        });
    return res;
  }

  @override
  Widget build(BuildContext context) {
    final time = todo?.dateTime != null
        ? timeago.format(DateTime.tryParse(todo!.dateTime.toString())!)
        : '';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 5.0),
      child: Dismissible(
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) async {
          _deleteTodo(context);
        },
        background: DismissibleBackground(),
        key: Key('__todo_item_${todo!.id}'),
        // onDismissed: onDismissed,
        child: ListTile(
          onTap: onTap,
          trailing: Checkbox(
            value: todo?.completed,
            onChanged: onCheckboxChanged,
          ),
          title: Container(
            width: MediaQuery.of(context).size.width,
            child: Text(
              todo?.title ?? '',
              //style: Theme.of(context).textTheme.headline6,
              style: TextStyle(
                fontSize: 18,
                letterSpacing: 0.8,
              ),
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              '$time',
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey[500],
                letterSpacing: 0.9,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
