import 'package:assignments/repositories/utils/base_util_repository.dart';
import 'package:flutter/material.dart';

class UitilsRepository extends BaseUtilRepository {
  @override
  Future<bool> askToRemove(BuildContext context) async {
    final result = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Delete'),
        content: Text('Do you want to delete this todo?'),
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
    return result ?? false;
  }
}
