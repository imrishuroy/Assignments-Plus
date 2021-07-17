import 'package:assignments/models/app_user_model.dart';
import 'package:assignments/models/public_todos.dart';
import 'package:assignments/repositories/auth/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_bloc/flutter_bloc.dart';

class PublicTodoItem extends StatelessWidget {
  final GestureTapCallback? onTap;

  final PublicTodo? todo;

  const PublicTodoItem({
    Key? key,
    this.onTap,
    this.todo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final time = todo?.dateTime != null
        ? timeago.format(DateTime.tryParse(todo!.dateTime.toString())!)
        : '';
    return (ListTile(
      onTap: onTap,
      title: Text(
        '${todo?.title}',
        style: TextStyle(
          fontSize: 18.0,
        ),
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$time'),
          FutureBuilder<AppUser?>(
            future: context.read<AuthRepository>().getUser(todo?.authorId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // return spinkit;
                return const SpinKitThreeBounce(
                  color: Colors.black12,
                  size: 20.0,
                );
              }

              return Text(
                '${snapshot.data?.name?.split(' ')[0]}',
                style: TextStyle(color: Colors.grey, fontSize: 15.0),
              );
            },
          ),
        ],
      ),
    ));
  }
}

final spinkit = SpinKitThreeBounce(
  itemBuilder: (BuildContext context, int index) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: index.isEven ? Colors.red : Colors.green,
      ),
    );
  },
);
