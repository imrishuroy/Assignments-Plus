part of 'theme_bloc.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

class ThemeChanged extends ThemeEvent {
  final AppTheme theme;

  ThemeChanged(this.theme);

  @override
  bool? get stringify => true;

  @override
  List<Object> get props => [theme];
}
