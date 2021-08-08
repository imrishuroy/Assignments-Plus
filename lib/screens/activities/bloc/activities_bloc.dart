import 'dart:async';

import 'package:assignments/models/activity.dart';
import 'package:assignments/models/failure_model.dart';
import 'package:assignments/repositories/activities/activities_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'activities_event.dart';
part 'activities_state.dart';

class ActivitiesBloc extends Bloc<ActivitiesEvent, ActivitiesState> {
  final ActivitiesRepository _activitiesRepository;

  StreamSubscription<List<Future<Activity?>>>? _activitiesSubscription;
  ActivitiesBloc({required ActivitiesRepository activitiesRepository})
      : _activitiesRepository = activitiesRepository,
        super(ActivitiesState.initial()) {
    _activitiesSubscription?.cancel();
    _activitiesSubscription =
        _activitiesRepository.getAllActivites().listen((activities) async {
      final allActivities = await Future.wait(activities);
      add(LoadActivities(activities: allActivities));
    });
  }

  @override
  Future<void> close() {
    _activitiesSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<ActivitiesState> mapEventToState(
    ActivitiesEvent event,
  ) async* {
    if (event is LoadActivities) {
      yield* _mapLoadActivitiesToState(event);
    }
  }

  Stream<ActivitiesState> _mapLoadActivitiesToState(
      LoadActivities event) async* {
    yield state.copyWith(
      activities: event.activities,
      status: ActivityStatus.succuss,
    );
  }
}
