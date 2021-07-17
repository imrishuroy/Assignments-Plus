import 'dart:async';

import 'package:assignments/models/app_tab_bar.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'tab_event.dart';

class TabBloc extends Bloc<TabEvent, AppTab> {
  TabBloc() : super(AppTab.todos);

  @override
  Future<void> close() {
    return super.close();
  }

  @override
  Stream<AppTab> mapEventToState(TabEvent event) async* {
    if (event is UpdateTab) {
      yield event.tab;
    }
  }
}
