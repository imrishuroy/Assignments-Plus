import 'package:assignments/models/todo_model.dart';
import 'package:flutter/material.dart';

import 'package:timeago/timeago.dart' as timeago;

class SearchItems extends StatelessWidget {
  final GestureTapCallback? onTap;

  final Todo? todo;

  SearchItems({
    Key? key,
    @required this.onTap,
    @required this.todo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final time = todo?.dateTime != null
        ? timeago.format(DateTime.tryParse(todo!.dateTime.toString())!)
        : '';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 5.0),
      child: ListTile(
        onTap: onTap,
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
    );
  }
}
