import 'package:flutter/material.dart';

abstract class BaseUtilRepository {
  Future<bool> askToRemove(BuildContext context);
}
