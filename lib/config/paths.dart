const bool isProduction = bool.fromEnvironment('dart.vm.product');

class Paths {
  static String get users => isProduction ? 'users' : 'dev-users';

  static String get todos => isProduction ? 'todos' : 'dev-todos';

  static String get public => isProduction ? 'public' : 'dev-public';

  static String get contact => isProduction ? 'contact' : 'dev-contact';

  static String get activities =>
      isProduction ? 'activities' : 'dev-activities';

  static String get userActivities => 'userActivities';
}
