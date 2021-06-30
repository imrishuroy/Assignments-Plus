import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo/models/todo_model.dart';
import 'package:timeago/timeago.dart' as timeago;

class TodoItem extends StatelessWidget {
  final DismissDirectionCallback? onDismissed;
  final GestureTapCallback? onTap;
  final ValueChanged<bool?>? onCheckboxChanged;
  final Todo? todo;

  TodoItem({
    Key? key,
    @required this.onDismissed,
    @required this.onTap,
    @required this.onCheckboxChanged,
    @required this.todo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final time = todo?.dateTime != null
        ? timeago.format(DateTime.tryParse(todo!.dateTime.toString())!)
        : '';
    return Dismissible(
      key: Key('__todo_item_${todo!.id}'),
      onDismissed: onDismissed,
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
            style: TextStyle(fontSize: 18),
          ),
        ),
        subtitle: Text(
          '$time',
          style: TextStyle(
            fontSize: 14.0,
            color: Colors.grey[500],
            letterSpacing: 0.9,
          ),
        ),
        // subtitle: todo.note.isNotEmpty
        //     ? Text(
        //         todo.note,
        //         maxLines: 1,
        //         overflow: TextOverflow.ellipsis,
        //         style: Theme.of(context).textTheme.subtitle1,
        //       )
        //     : null,
      ),
    );
  }
}
