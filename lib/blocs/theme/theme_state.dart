part of 'theme_bloc.dart';

class ThemeState extends Equatable {
  final ThemeData? themeData;

  const ThemeState(this.themeData);

  factory ThemeState.initial() {
    return ThemeState(appThemeData[AppTheme.Light]);
  }

  @override
  bool? get stringify => super.stringify;

  @override
  List<Object?> get props => [themeData];
}
