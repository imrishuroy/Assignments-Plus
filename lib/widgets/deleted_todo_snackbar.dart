import 'package:flutter/material.dart';

class DeleteTodoSnackBar extends SnackBar {
  DeleteTodoSnackBar({
    Key? key,
    @required String? title,
    @required VoidCallback? onUndo,
  }) : super(
          key: key,
          content: Text(
            'Deleted ${title ?? ''}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          duration: Duration(seconds: 2),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: onUndo!,
          ),
        );
}
