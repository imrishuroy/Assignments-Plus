import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String title;
  final String? content;

  const ErrorDialog({
    Key? key,
    this.title = 'Error !',
    @required this.content,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return _showAndroidDialog(context);
  }

  // CupertinoAlertDialog _showIOSDialog(BuildContext context) {
  //   return CupertinoAlertDialog(
  //     title: Text(title),
  //     content: Text(content!),
  //     actions: [
  //       CupertinoDialogAction(
  //         child: const Text('OK'),
  //         onPressed: () => Navigator.of(context).pop(),
  //       )
  //     ],
  //   );
  // }

  AlertDialog _showAndroidDialog(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content!),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('OK'),
        ),
      ],
    );
  }
}
