import 'dart:async';

import 'package:assignments/config/shared_prefs.dart';
import 'package:assignments/theme/app_theme.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState.initial()) {
    on<ThemeChanged>((event, emit) async {
      await SharedPrefs().setTheme(event.theme.index);
      emit(ThemeState(appThemeData[event.theme]));
    });
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
